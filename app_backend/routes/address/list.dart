// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// GET /address/list
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /address/list API HIT');

  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'success': false, 'message': 'Token missing'},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    final userId = jwt.payload['id'].toString();

    // Get all addresses first
    final addresses =
        await MongoService.addresses!.find({'userId': userId}).toList();

    // Sort manually (default first, then newest first)
    addresses.sort((a, b) {
      // First sort by isDefault (true comes first)
      final aDefault = a['isDefault'] as bool? ?? false;
      final bDefault = b['isDefault'] as bool? ?? false;

      // For boolean: true (1) should come before false (0)
      // So we want: if aDefault is true and bDefault is false, a comes first
      if (aDefault != bDefault) {
        // Return -1 if a is true (comes first), 1 if b is true
        return aDefault ? -1 : 1;
      }

      // Then sort by createdAt (newest first)
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });

    final transformedAddresses =
        addresses.map((address) {
          return {
            '_id': (address['_id'] as ObjectId).oid,
            'fullName': address['fullName'],
            'mobileNumber': address['mobileNumber'],
            'pincode': address['pincode'],
            'addressLine1': address['addressLine1'],
            'addressLine2': address['addressLine2'] ?? '',
            'landmark': address['landmark'] ?? '',
            'city': address['city'],
            'state': address['state'],
            'country': address['country'] ?? 'India',
            'isDefault': address['isDefault'] ?? false,
            'addressType': address['addressType'] ?? 'home',
            'createdAt':
                address['createdAt'] is DateTime
                    ? (address['createdAt'] as DateTime).toIso8601String()
                    : null,
          };
        }).toList();

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Addresses fetched successfully',
        'data': transformedAddresses,
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

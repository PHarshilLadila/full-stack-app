// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// POST /address/add
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /address/add API HIT');

  if (context.request.method != HttpMethod.post) {
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

    // Read the request body as string first
    final bodyString = await context.request.body();
    print('📝 Raw body: $bodyString');

    if (bodyString.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Request body is empty'},
      );
    }

    // Parse JSON
    Map<String, dynamic> body;
    try {
      body = jsonDecode(bodyString) as Map<String, dynamic>;
    } catch (e) {
      print('❌ JSON parse error: $e');
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'Invalid JSON format: ${e.toString()}',
        },
      );
    }

    // Validate required fields
    final requiredFields = [
      'fullName',
      'mobileNumber',
      'pincode',
      'addressLine1',
      'city',
      'state',
    ];
    for (final field in requiredFields) {
      if (body[field] == null || body[field].toString().isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': '$field is required'},
        );
      }
    }

    // If this is default address, remove default from other addresses
    final isDefault = body['isDefault'] as bool? ?? false;
    if (isDefault) {
      await MongoService.addresses!.updateMany(
        {'userId': userId},
        {
          '\$set': {'isDefault': false},
        },
      );
    }

    final addressData = {
      'userId': userId,
      'fullName': body['fullName'].toString(),
      'mobileNumber': body['mobileNumber'].toString(),
      'pincode': body['pincode'].toString(),
      'addressLine1': body['addressLine1'].toString(),
      'addressLine2': body['addressLine2']?.toString() ?? '',
      'landmark': body['landmark']?.toString() ?? '',
      'city': body['city'].toString(),
      'state': body['state'].toString(),
      'country': body['country']?.toString() ?? 'India',
      'isDefault': isDefault,
      'addressType': body['addressType']?.toString() ?? 'home',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    final result = await MongoService.addresses!.insertOne(addressData);

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to add address'},
      );
    }

    final insertedId = (result.document!['_id'] as ObjectId).oid;

    return Response.json(
      statusCode: 201,
      body: {
        'success': true,
        'message': 'Address added successfully',
        'data': {'addressId': insertedId},
      },
    );
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: ${e.toString()}'},
    );
  }
}

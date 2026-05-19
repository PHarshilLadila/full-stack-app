// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// PUT /address/update
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /address/update API HIT');

  if (context.request.method != HttpMethod.put) {
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

    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final addressId = body['addressId']?.toString();

    if (addressId == null || addressId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Address ID required'},
      );
    }

    // Verify address belongs to user
    final existingAddress = await MongoService.addresses!.findOne({
      '_id': ObjectId.parse(addressId),
      'userId': userId,
    });

    if (existingAddress == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Address not found'},
      );
    }

    final updateData = <String, dynamic>{};

    final updatableFields = [
      'fullName',
      'mobileNumber',
      'pincode',
      'addressLine1',
      'addressLine2',
      'landmark',
      'city',
      'state',
      'country',
      'addressType',
    ];

    for (final field in updatableFields) {
      if (body[field] != null) {
        updateData[field] = body[field].toString();
      }
    }

    // Handle default address
    if (body['isDefault'] == true) {
      await MongoService.addresses!.updateMany(
        {'userId': userId},
        {
          '\$set': {'isDefault': false},
        },
      );
      updateData['isDefault'] = true;
    } else if (body['isDefault'] == false) {
      updateData['isDefault'] = false;
    }

    if (updateData.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'No fields to update'},
      );
    }

    updateData['updatedAt'] = DateTime.now();

    final result = await MongoService.addresses!.updateOne(
      {'_id': ObjectId.parse(addressId)},
      {'\$set': updateData},
    );

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to update address'},
      );
    }

    return Response.json(
      statusCode: 200,
      body: {'success': true, 'message': 'Address updated successfully'},
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

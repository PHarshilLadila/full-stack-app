// ignore_for_file: avoid_print, avoid_dynamic_calls

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /user/update API HIT');

  final authHeader = context.request.headers['authorization'];

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(statusCode: 401, body: {'error': 'Token missing'});
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    final userId = jwt.payload['id'] as String;

    final body = jsonDecode(await context.request.body());
    print('📦 Update Body: $body');

    final updateData = <String, dynamic>{};

    if (body['fullName'] != null) updateData['fullName'] = body['fullName'];
    if (body['username'] != null) updateData['username'] = body['username'];
    if (body['email'] != null) updateData['email'] = body['email'];
    if (body['mobile'] != null) updateData['mobile'] = body['mobile'];
    if (body['profileImage'] != null) {
      updateData['profileImage'] = body['profileImage'];
    }
    
    // Only allow role update if provided (optional)
    if (body['role'] != null) {
      if (body['role'] == 'customer' || body['role'] == 'seller') {
        updateData['role'] = body['role'];
      } else {
        return Response.json(body: {'error': 'Invalid role. Must be customer or seller'});
      }
    }

    // Convert DateTime to String
    updateData['updatedAt'] = DateTime.now().toIso8601String();

    if (updateData.isEmpty) {
      return Response.json(body: {'error': 'No data to update'});
    }

    // BEST UPDATE METHOD
    final result = await MongoService.users!.updateOne(
      where.id(ObjectId.parse(userId)),
      {r'$set': updateData},
    );

    if (!result.isSuccess) {
      return Response.json(body: {'error': 'Update failed'});
    }

    print('✅ User updated successfully');

    return Response.json(
      body: {
        'message': 'User updated successfully',
        'updatedFields': updateData,
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(statusCode: 401, body: {'error': 'Invalid token'});
  }
}
// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

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
    return Response.json(
      statusCode: 401,
      body: {'error': 'Token missing', 'success': false},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    final userId = jwt.payload['id'] as String;
    final currentRole = jwt.payload['role'] as String? ?? 'customer';

    // Check if users collection exists
    if (MongoService.users == null) {
      return Response.json(
        statusCode: 500,
        body: {'error': 'Database not connected', 'success': false},
      );
    }

    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    print('📦 Update Body: $body');

    final updateData = <String, dynamic>{};

    // Validate and add update fields
    if (body['fullName'] != null && body['fullName'].toString().isNotEmpty) {
      updateData['fullName'] = body['fullName'].toString();
    }
    
    if (body['username'] != null && body['username'].toString().isNotEmpty) {
      // Check if username is already taken by another user
      final existingUser = await MongoService.users!.findOne({
        'username': body['username'].toString(),
        '_id': {r'$ne': ObjectId.parse(userId)},
      });
      
      if (existingUser != null) {
        return Response.json(
          body: {'error': 'Username already taken', 'success': false},
        );
      }
      updateData['username'] = body['username'].toString();
    }
    
    if (body['email'] != null && body['email'].toString().isNotEmpty) {
      // Check if email is already taken by another user
      final existingUser = await MongoService.users!.findOne({
        'email': body['email'].toString(),
        '_id': {r'$ne': ObjectId.parse(userId)},
      });
      
      if (existingUser != null) {
        return Response.json(
          body: {'error': 'Email already taken', 'success': false},
        );
      }
      updateData['email'] = body['email'].toString();
    }
    
    if (body['mobile'] != null && body['mobile'].toString().isNotEmpty) {
      // Check if mobile is already taken by another user
      final existingUser = await MongoService.users!.findOne({
        'mobile': body['mobile'].toString(),
        '_id': {r'$ne': ObjectId.parse(userId)},
      });
      
      if (existingUser != null) {
        return Response.json(
          body: {'error': 'Mobile number already taken', 'success': false},
        );
      }
      updateData['mobile'] = body['mobile'].toString();
    }
    
    if (body['profileImage'] != null && body['profileImage'].toString().isNotEmpty) {
      updateData['profileImage'] = body['profileImage'].toString();
    }
    
    // Role update - only allow if properly authorized
    if (body['role'] != null) {
      final newRole = body['role'].toString();
      if (newRole == 'customer' || newRole == 'seller') {
        // In production, you might want to restrict role changes
        // or require admin approval
        updateData['role'] = newRole;
        print('⚠️ Role changing from $currentRole to $newRole');
      } else {
        return Response.json(
          body: {'error': 'Invalid role. Must be customer or seller', 'success': false},
        );
      }
    }

    // Add updated timestamp
    updateData['updatedAt'] = DateTime.now();

    if (updateData.isEmpty) {
      return Response.json(
        body: {'error': 'No data to update', 'success': false},
      );
    }

    // Update user
    final result = await MongoService.users!.updateOne(
      {'_id': ObjectId.parse(userId)},
      {r'$set': updateData},
    );

    if (!result.isSuccess) {
      return Response.json(
        body: {'error': 'Update failed', 'success': false},
      );
    }

    // Get updated user data
    final updatedUser = await MongoService.users!.findOne({
      '_id': ObjectId.parse(userId),
    });

    // Remove sensitive data
    updatedUser?.remove('passwordHash');
    
    // Convert ObjectId to string
    if (updatedUser != null && updatedUser['_id'] is ObjectId) {
      updatedUser['_id'] = (updatedUser['_id'] as ObjectId).oid;
    }
    
    // Convert DateTime to string
    if (updatedUser != null && updatedUser['createdAt'] is DateTime) {
      updatedUser['createdAt'] = (updatedUser['createdAt'] as DateTime).toIso8601String();
    }
    if (updatedUser != null && updatedUser['updatedAt'] is DateTime) {
      updatedUser['updatedAt'] = (updatedUser['updatedAt'] as DateTime).toIso8601String();
    }

    print('✅ User updated successfully');

    return Response.json(
      body: {
        'success': true,
        'message': 'User updated successfully',
        'updatedFields': updateData,
        'data': updatedUser,
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to update user: $e', 'success': false},
    );
  }
}

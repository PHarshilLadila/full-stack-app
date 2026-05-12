// ignore_for_file: avoid_dynamic_calls, avoid_print

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /user/me API HIT');

  final authHeader = context.request.headers['authorization'];
  print('👉 Header: $authHeader');

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    print('❌ Token missing or wrong format');
    return Response.json(statusCode: 401, body: {'error': 'Token missing'});
  }

  final token = authHeader.split(' ')[1];
  print('🔑 Token: $token');

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    print('✅ Token verified');

    final userId = jwt.payload['id'] as String;
    final userRole = jwt.payload['role'] as String? ?? 'customer';
    print('👤 User ID: $userId');
    print('👤 User Role: $userRole');

    // Check if users collection exists
    if (MongoService.users == null) {
      return Response.json(
        statusCode: 500,
        body: {'error': 'Database not connected'},
      );
    }

    final user = await MongoService.users!.findOne({
      '_id': ObjectId.parse(userId),
    });

    if (user == null) {
      print('❌ User not found');
      return Response.json(
        statusCode: 404,
        body: {'error': 'User not found'},
      );
    }

    // Remove sensitive data
    user.remove('passwordHash');

    // Convert ObjectId → String
    user['_id'] = (user['_id'] as ObjectId).oid;

    // Convert DateTime → String
    if (user['createdAt'] is DateTime) {
      user['createdAt'] = (user['createdAt'] as DateTime).toIso8601String();
    }
    
    if (user['updatedAt'] is DateTime) {
      user['updatedAt'] = (user['updatedAt'] as DateTime).toIso8601String();
    }

    // Ensure role field exists (for backward compatibility)
    if (user['role'] == null) {
      user['role'] = userRole;
    }

    print('✅ User fetched successfully');

    return Response.json(
      body: {
        'success': true,
        'message': 'User fetched successfully',
        'data': user,
        'role': user['role'],
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 401,
      body: {'error': 'Invalid token', 'success': false},
    );
  }
}

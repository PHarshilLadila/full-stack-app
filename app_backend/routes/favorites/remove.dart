// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// DELETE /favorites/remove
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /favorites/remove API HIT');

  if (context.request.method != HttpMethod.delete) {
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
    final productId = body['productId']?.toString();

    if (productId == null || productId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product ID required'},
      );
    }

    final result = await MongoService.favorites!.remove({
      'userId': userId,
      'productId': productId,
    });

    if (result == null || result['n'] == 0) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Product not found in favorites'},
      );
    }

    return Response.json(
      statusCode: 200,
      body: {'success': true, 'message': 'Product removed from favorites'},
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

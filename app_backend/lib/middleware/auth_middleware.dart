// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:my_backend/config/env.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final request = context.request;

    // Allow public routes
    if (request.uri.path.contains('/auth/login') ||
        request.uri.path.contains('/auth/register')) {
      return handler(context);
    }

    final authHeader = request.headers['authorization'];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(statusCode: 401, body: {'error': 'Token missing'});
    }

    final token = authHeader.split(' ')[1];

    try {
      // final env = DotEnv()..load();

      // JWT.verify(token, SecretKey(env['JWT_SECRET']!));
      // final secret = Platform.environment['JWT_SECRET']!;
      JWT.verify(token, SecretKey(Env.jwtSecret));
      // JWT.verify(token, SecretKey(secret));

      // Token valid → allow request
      return handler(context);
    } catch (e) {
      return Response.json(statusCode: 401, body: {'error': 'Invalid token'});
    }
  };
}

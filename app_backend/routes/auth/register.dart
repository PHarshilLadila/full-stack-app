// ignore_for_file: avoid_print, avoid_dynamic_calls

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/auth_service.dart';
import 'package:my_backend/utils/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  final body = jsonDecode(await context.request.body());

  print('REGISTER BODY: $body');

  final fullName = body['fullName'];
  final username = body['username'];
  final email = body['email'];
  final mobile = body['mobile'];
  final password = body['password'];
  final confirmPassword = body['confirmPassword'];

  if (MongoService.users == null) {
    return Response.json(body: {'error': 'DB not connected'});
  }

  if (!isValidEmail(email.toString())) {
    return Response.json(body: {'error': 'Invalid email'});
  }

  if (!isValidMobile(mobile.toString())) {
    return Response.json(body: {'error': 'Invalid mobile'});
  }

  if (password != confirmPassword) {
    return Response.json(body: {'error': 'Password mismatch'});
  }

  final existing = await MongoService.users!.findOne({
    r'$or': [
      {'email': email},
      {'username': username},
      {'mobile': mobile},
    ],
  });

  if (existing != null) {
    return Response.json(body: {'error': 'User already exists'});
  }

  final hashed = AuthService.hashPassword(password.toString());

  await MongoService.users!.insert({
    'fullName': fullName,
    'username': username,
    'email': email,
    'mobile': mobile,
    'passwordHash': hashed,
    'createdAt': DateTime.now(),
  });

  print('✅ User inserted');

  return Response.json(body: {'message': 'Registered successfully'});
}

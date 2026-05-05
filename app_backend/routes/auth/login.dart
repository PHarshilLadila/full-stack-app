// ignore_for_file: avoid_print, avoid_dynamic_calls

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final body = jsonDecode(await context.request.body());

  print('LOGIN BODY: $body');

  final identifier = body['identifier']?.toString() ?? '';
  final password = body['password']?.toString() ?? '';

  if (identifier.isEmpty || password.isEmpty) {
    return Response.json(body: {'error': 'Identifier and password required'});
  }

  if (MongoService.users == null) {
    return Response.json(body: {'error': 'DB not connected'});
  }

  final user = await MongoService.users!.findOne({
    r'$or': [
      {'email': identifier},
      {'username': identifier},
      {'mobile': identifier},
    ],
  });

  if (user == null) {
    return Response.json(body: {'error': 'User not found'});
  }

  final valid = AuthService.verifyPassword(
    password,
    user['passwordHash'].toString(),
  );

  if (!valid) {
    return Response.json(body: {'error': 'Wrong password'});
  }

  final objectId = user['_id'] as ObjectId;

  final token = AuthService.generateToken(objectId.oid);

  print('🆔 ObjectId: ${objectId.oid}');
  print('🔐 Generated Token: $token');
  print('✅ Login success');

  return Response.json(body: {'message': 'Login success', 'token': token});
}

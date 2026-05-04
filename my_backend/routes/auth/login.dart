import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/db/mongo.dart';
import '../../lib/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final body = jsonDecode(await context.request.body());

  print("LOGIN BODY: $body");

  final identifier = body['identifier'];
  final password = body['password'];

  if (MongoService.users == null) {
    return Response.json(body: {'error': 'DB not connected'});
  }

  final user = await MongoService.users!.findOne({
    r'$or': [
      {'email': identifier},
      {'username': identifier},
      {'mobile': identifier}
    ]
  });

  if (user == null) {
    return Response.json(body: {'error': 'User not found'});
  }

  final valid = AuthService.verifyPassword(
    password.toString(),
    user['passwordHash'].toString(),
  );

  if (!valid) {
    return Response.json(body: {'error': 'Wrong password'});
  }

  final token = AuthService.generateToken(user['_id'].toString());

  print("✅ Login success");

  return Response.json(body: {
    'message': 'Login success',
    'token': token,
  });
}
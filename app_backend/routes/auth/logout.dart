// ignore_for_file: unused_local_variable

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final authHeader = context.request.headers['authorization'];

  if (authHeader != null && authHeader.startsWith('Bearer ')) {
    final token = authHeader.split(' ')[1];

    // Optional: Store token in blacklist collection
    // await MongoService.blacklistedTokens!.insert({
    //   'token': token,
    //   'expiresAt': DateTime.now().add(Duration(days: 7)),
    // });
  }

  return Response.json(
    body: {
      'success': true,
      'message':
          'Logout successful. Please delete your token from client side.',
    },
  );
}

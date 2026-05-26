// app_backend/routes/user/update_fcm_token.dart
import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/services/notification_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
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
    final userRole = jwt.payload['role']?.toString() ?? 'customer';

    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final fcmToken = body['fcmToken']?.toString();

    if (fcmToken == null || fcmToken.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'FCM token required'},
      );
    }

    // Save token to database
    await NotificationService.saveFCMToken(
      userId: userId,
      fcmToken: fcmToken,
      role: userRole,
    );

    return Response.json(
      statusCode: 200,
      body: {'success': true, 'message': 'FCM token updated'},
    );
  } catch (e) {
    print('❌ Error updating FCM token: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: ${e.toString()}'},
    );
  }
}

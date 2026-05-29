// app_backend/lib/routes/notifications/unread_count.dart
// ignore_for_file: avoid_redundant_argument_values, avoid_print, noop_primitive_operations, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/middleware/auth_middleware.dart';

/// GET /notifications/unread_count
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  try {
    // ✅ FIX: Use AuthData instead of context.get()
    final authData = context.read<AuthData>();
    final userId = authData.userId;

    // Count unread notifications
    final filter = {'userId': userId, 'isRead': false};
    final unreadCount = await MongoService.notifications!.count(filter);

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'data': {'unreadCount': unreadCount},
      },
    );
  } catch (e) {
    print('Error getting unread count: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: ${e.toString()}'},
    );
  }
}

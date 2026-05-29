// app_backend/lib/routes/notifications/mark_read.dart
// ignore_for_file: lines_longer_than_80_chars, avoid_redundant_argument_values, avoid_print

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/middleware/auth_middleware.dart';
 
/// PUT /notifications/mark_read
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.put) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }
  
  try {
    // ✅ FIX: Use AuthData instead of context.get()
    final authData = context.read<AuthData>();
    final userId = authData.userId;
    
    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final notificationId = body['notificationId']?.toString();
    final markAll = body['markAll'] as bool? ?? false;
    
    if (markAll) {
      // Mark all notifications as read for this user
      await MongoService.notifications!.updateMany(
        {'userId': userId, 'isRead': false},
        {r'$set': {'isRead': true}},
      );
      
      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'All notifications marked as read',
        },
      );
    } else {
      // Mark single notification as read
      if (notificationId == null || notificationId.isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': 'notificationId is required'},
        );
      }
      
      await MongoService.notifications!.updateOne(
        {'notificationId': notificationId, 'userId': userId},
        {r'$set': {'isRead': true}},
      );
      
      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'Notification marked as read',
        },
      );
    }
  } catch (e) {
    print('Error marking notification as read: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

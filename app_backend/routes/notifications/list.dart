// app_backend/lib/routes/notifications/list.dart
// ignore_for_file: avoid_redundant_argument_values, avoid_print

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/middleware/auth_middleware.dart';

/// GET /notifications/list?page=1&limit=20
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  try {
    // ✅ FIX 1: Use AuthData instead of context.get()
    final authData = context.read<AuthData>();
    final userId = authData.userId;

    // Get query parameters
    final queryParams = context.request.uri.queryParameters;
    final page = int.tryParse(queryParams['page'] ?? '1') ?? 1;
    final limit = int.tryParse(queryParams['limit'] ?? '20') ?? 20;
    final type = queryParams['type'];
    final skip = (page - 1) * limit;

    // Build filter
    final filter = <String, dynamic>{'userId': userId};
    if (type != null && type.isNotEmpty) {
      filter['type'] = type;
    }

    // Get total count
    final totalCount = await MongoService.notifications!.count(filter);

    // ✅ FIX 2: Correct way to sort in mongo_dart
    // Use .find().toList() then sort manually, OR use aggregate
    final notifications =
        await MongoService.notifications!.find(filter).toList();

    // Sort manually (newest first) - createdAt should be DateTime
    notifications.sort((a, b) {
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });

    // Apply pagination after sorting
    final paginatedNotifications =
        notifications.skip(skip).take(limit).toList();

    // Transform notifications for response
    final transformedNotifications =
        paginatedNotifications.map((notif) {
          return {
            'id': (notif['_id'] as ObjectId).oid,
            'notificationId': notif['notificationId'],
            'title': notif['title'],
            'body': notif['body'],
            'type': notif['type'],
            'data': notif['data'],
            'isRead': notif['isRead'] ?? false,
            'createdAt': (notif['createdAt'] as DateTime).toIso8601String(),
          };
        }).toList();

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'data': transformedNotifications,
        'pagination': {
          'currentPage': page,
          'totalPages': totalCount > 0 ? (totalCount / limit).ceil() : 0,
          'totalItems': totalCount,
          'itemsPerPage': limit,
        },
      },
    );
  } catch (e) {
    print('Error fetching notifications: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/analytics_service.dart';

/// GET /analytics/orders?period=week
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /analytics/orders API HIT');

  if (context.request.method != HttpMethod.get) {
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

    if (userRole != 'seller') {
      return Response.json(
        statusCode: 403,
        body: {'success': false, 'message': 'Only sellers can view analytics'},
      );
    }

    final queryParams = context.request.uri.queryParameters;
    final period = queryParams['period'] ?? 'week';

    final analytics = AnalyticsService(sellerId: userId);

    final orderStatus = await analytics.getOrderStatusAnalytics();
    final salesData = await analytics.getSalesAnalytics(period: period);

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Order analytics fetched successfully',
        'data': {
          'orderStatusBreakdown': orderStatus,
          'totalOrders': salesData['totalOrders'],
          'completedOrders': orderStatus['delivered'],
          'pendingOrders': orderStatus['pending'],
          'cancelledOrders': orderStatus['cancelled'],
          'orderCompletionRate':
              (salesData['totalOrders'] as int) > 0
                  ? ((orderStatus['delivered'] ?? 0) /
                          (salesData['totalOrders'] as int)) *
                      100
                  : 0,
          'cancellationRate':
              (salesData['totalOrders'] as int) > 0
                  ? ((orderStatus['cancelled'] ?? 0) /
                          (salesData['totalOrders'] as int)) *
                      100
                  : 0,
        },
      },
    );
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: ${e.toString()}'},
    );
  }
}

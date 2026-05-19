// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/analytics_service.dart';

/// GET /analytics/sales?period=week
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /analytics/sales API HIT');

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

    final salesData = await analytics.getSalesAnalytics(period: period);
    final revenueData = await analytics.getRevenueAnalytics();

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Sales analytics fetched successfully',
        'data': {
          'salesOverview': salesData,
          'revenueTrend': revenueData['breakdown'],
          'dailyRevenue': revenueData['daily'],
          'weeklyRevenue': revenueData['weekly'],
          'monthlyRevenue': revenueData['monthly'],
          'yearlyRevenue': revenueData['yearly'],
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

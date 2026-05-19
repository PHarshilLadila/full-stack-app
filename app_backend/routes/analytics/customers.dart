// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/analytics_service.dart';

/// GET /analytics/customers
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /analytics/customers API HIT');

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

    final analytics = AnalyticsService(sellerId: userId);

    final customerData = await analytics.getCustomerAnalytics();
    final salesData = await analytics.getSalesAnalytics(period: 'month');

    final totalCustomers = (customerData['totalCustomers'] as int?) ?? 0;
    final totalRevenue = (salesData['totalRevenue'] as num?) ?? 0;

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Customer analytics fetched successfully',
        'data': {
          ...customerData,
          'averageRevenuePerCustomer':
              totalRevenue / (totalCustomers > 0 ? totalCustomers : 1),
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

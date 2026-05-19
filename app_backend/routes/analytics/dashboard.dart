// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/analytics_service.dart';

/// GET /analytics/dashboard?period=week
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /analytics/dashboard API HIT');

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

    DateTime? startDate;
    DateTime? endDate;

    if (queryParams['startDate'] != null && queryParams['endDate'] != null) {
      try {
        startDate = DateTime.parse(queryParams['startDate']!);
        endDate = DateTime.parse(queryParams['endDate']!);
      } catch (e) {
        print('Date parsing error: $e');
      }
    }

    final analytics = AnalyticsService(sellerId: userId);

    // Check if collections exist
    if (MongoService.products == null || MongoService.orders == null) {
      return Response.json(
        statusCode: 500,
        body: {
          'success': false,
          'message': 'Database collections not initialized',
        },
      );
    }

    // Get all analytics data with error handling for each
    Map<String, dynamic> salesData = {};
    Map<String, int> orderStatusData = {};
    Map<String, dynamic> revenueData = {};
    Map<String, List<Map<String, dynamic>>> topProductsData = {};
    Map<String, dynamic> customerData = {};
    List<Map<String, dynamic>> productPerformanceData = [];

    try {
      salesData = await analytics.getSalesAnalytics(
        period: period,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      print('Error getting sales analytics: $e');
      salesData = _getEmptySalesData();
    }

    try {
      orderStatusData = await analytics.getOrderStatusAnalytics();
    } catch (e) {
      print('Error getting order status: $e');
      orderStatusData = _getEmptyOrderStatus();
    }

    try {
      revenueData = await analytics.getRevenueAnalytics();
    } catch (e) {
      print('Error getting revenue analytics: $e');
      revenueData = _getEmptyRevenueData();
    }

    try {
      topProductsData = await analytics.getTopProducts();
    } catch (e) {
      print('Error getting top products: $e');
      topProductsData = _getEmptyTopProducts();
    }

    try {
      customerData = await analytics.getCustomerAnalytics();
    } catch (e) {
      print('Error getting customer analytics: $e');
      customerData = _getEmptyCustomerData();
    }

    try {
      productPerformanceData = await analytics.getProductPerformance();
    } catch (e) {
      print('Error getting product performance: $e');
      productPerformanceData = [];
    }

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Analytics fetched successfully',
        'data': {
          'salesOverview': salesData,
          'orderStatus': orderStatusData,
          'revenueAnalytics': revenueData,
          'topProducts': topProductsData,
          'customerAnalytics': customerData,
          'productPerformance': productPerformanceData.take(20).toList(),
          'summary': _calculateSummary(salesData),
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

Map<String, dynamic> _calculateSummary(Map<String, dynamic> salesOverview) {
  final totalRevenue =
      (salesOverview['totalRevenue'] as num?)?.toDouble() ?? 0.0;

  final totalOrders = (salesOverview['totalOrders'] as num?)?.toInt() ?? 0;

  final averageOrderValue =
      (salesOverview['averageOrderValue'] as num?)?.toDouble() ?? 0.0;

  final totalCustomers =
      (salesOverview['totalCustomers'] as num?)?.toInt() ?? 0;

  final totalProducts = (salesOverview['totalProducts'] as num?)?.toInt() ?? 0;

  return {
    'totalRevenue': totalRevenue,
    'totalOrders': totalOrders,
    'averageOrderValue': averageOrderValue,
    'totalCustomers': totalCustomers,
    'totalProducts': totalProducts,
  };
}

Map<String, dynamic> _getEmptySalesData() {
  return {
    'totalRevenue': 0.0,
    'totalProfit': 0.0,
    'totalOrders': 0,
    'totalProducts': 0,
    'totalCustomers': 0,
    'averageOrderValue': 0.0,
    'conversionRate': 0.0,
    'periodData': {
      'startDate': DateTime.now().toIso8601String(),
      'endDate': DateTime.now().toIso8601String(),
      'period': 'none',
    },
  };
}

Map<String, int> _getEmptyOrderStatus() {
  return {
    'pending': 0,
    'confirmed': 0,
    'shipped': 0,
    'outForDelivery': 0,
    'delivered': 0,
    'cancelled': 0,
    'returned': 0,
  };
}

Map<String, dynamic> _getEmptyRevenueData() {
  return {
    'daily': 0.0,
    'weekly': 0.0,
    'monthly': 0.0,
    'yearly': 0.0,
    'breakdown': {},
  };
}

Map<String, List<Map<String, dynamic>>> _getEmptyTopProducts() {
  return {
    'bestSelling': [],
    'topRated': [],
    'mostViewed': [],
    'lowStock': [],
    'outOfStock': [],
  };
}

Map<String, dynamic> _getEmptyCustomerData() {
  return {
    'totalCustomers': 0,
    'newCustomers': 0,
    'repeatCustomers': 0,
    'customerRetentionRate': 0.0,
    'averageOrderPerCustomer': 0.0,
    'lifetimeValue': 0.0,
  };
}

// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/analytics_service.dart';

/// GET /analytics/reports?type=daily&date=2024-01-15
///
/// Types: daily, weekly, monthly, yearly
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /analytics/reports API HIT');

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
        body: {'success': false, 'message': 'Only sellers can view reports'},
      );
    }

    final queryParams = context.request.uri.queryParameters;
    final reportType = queryParams['type'] ?? 'daily';
    final dateStr = queryParams['date'];

    DateTime reportDate;
    if (dateStr != null) {
      reportDate = DateTime.parse(dateStr);
    } else {
      reportDate = DateTime.now();
    }

    final analytics = AnalyticsService(sellerId: userId);

    Map<String, dynamic> reportData;

    switch (reportType) {
      case 'daily':
        reportData = await _getDailyReport(analytics, reportDate);
        break;
      case 'weekly':
        reportData = await _getWeeklyReport(analytics, reportDate);
        break;
      case 'monthly':
        reportData = await _getMonthlyReport(analytics, reportDate);
        break;
      case 'yearly':
        reportData = await _getYearlyReport(analytics, reportDate);
        break;
      default:
        reportData = await _getDailyReport(analytics, reportDate);
    }

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Report generated successfully',
        'data': reportData,
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

Future<Map<String, dynamic>> _getDailyReport(
  AnalyticsService analytics,
  DateTime date,
) async {
  final startDate = DateTime(date.year, date.month, date.day);
  final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

  final salesData = await analytics.getSalesAnalytics(
    period: 'custom',
    startDate: startDate,
    endDate: endDate,
  );

  final topProducts = await analytics.getTopProducts();

  return {
    'reportType': 'daily',
    'date': date.toIso8601String(),
    'salesSummary': salesData,
    'topProducts': topProducts['bestSelling']?.take(5).toList() ?? [],
    'insights': _generateInsights(salesData),
  };
}

Future<Map<String, dynamic>> _getWeeklyReport(
  AnalyticsService analytics,
  DateTime date,
) async {
  final startDate = date.subtract(Duration(days: date.weekday - 1));
  final endDate = startDate.add(const Duration(days: 6));

  final salesData = await analytics.getSalesAnalytics(
    period: 'custom',
    startDate: startDate,
    endDate: endDate,
  );

  final dailyBreakdown = await _getDailyBreakdown(
    analytics,
    startDate,
    endDate,
  );
  final topProducts = await analytics.getTopProducts();

  return {
    'reportType': 'weekly',
    'weekStart': startDate.toIso8601String(),
    'weekEnd': endDate.toIso8601String(),
    'salesSummary': salesData,
    'dailyBreakdown': dailyBreakdown,
    'topProducts': topProducts['bestSelling']?.take(10).toList() ?? [],
    'insights': _generateInsights(salesData),
  };
}

Future<Map<String, dynamic>> _getMonthlyReport(
  AnalyticsService analytics,
  DateTime date,
) async {
  final startDate = DateTime(date.year, date.month, 1);
  final endDate = DateTime(date.year, date.month + 1, 0, 23, 59, 59);

  final salesData = await analytics.getSalesAnalytics(
    period: 'custom',
    startDate: startDate,
    endDate: endDate,
  );

  final weeklyBreakdown = await _getWeeklyBreakdown(
    analytics,
    startDate,
    endDate,
  );
  final topProducts = await analytics.getTopProducts();
  final customerData = await analytics.getCustomerAnalytics();

  return {
    'reportType': 'monthly',
    'month': date.month,
    'year': date.year,
    'salesSummary': salesData,
    'weeklyBreakdown': weeklyBreakdown,
    'topProducts': topProducts['bestSelling']?.take(15).toList() ?? [],
    'customerAnalytics': customerData,
    'insights': _generateInsights(salesData),
  };
}

Future<Map<String, dynamic>> _getYearlyReport(
  AnalyticsService analytics,
  DateTime date,
) async {
  final startDate = DateTime(date.year, 1, 1);
  final endDate = DateTime(date.year, 12, 31, 23, 59, 59);

  final salesData = await analytics.getSalesAnalytics(
    period: 'custom',
    startDate: startDate,
    endDate: endDate,
  );

  final monthlyBreakdown = await _getMonthlyBreakdown(
    analytics,
    startDate,
    endDate,
  );
  final topProducts = await analytics.getTopProducts();
  final customerData = await analytics.getCustomerAnalytics();
  final orderStatus = await analytics.getOrderStatusAnalytics();

  return {
    'reportType': 'yearly',
    'year': date.year,
    'salesSummary': salesData,
    'monthlyBreakdown': monthlyBreakdown,
    'topProducts': topProducts['bestSelling']?.take(20).toList() ?? [],
    'customerAnalytics': customerData,
    'orderStatus': orderStatus,
    'insights': _generateYearlyInsights(salesData, customerData),
  };
}

Future<Map<String, double>> _getDailyBreakdown(
  AnalyticsService analytics,
  DateTime startDate,
  DateTime endDate,
) async {
  final breakdown = <String, double>{};

  for (
    var date = startDate;
    date.isBefore(endDate);
    date = date.add(const Duration(days: 1))
  ) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final salesData = await analytics.getSalesAnalytics(
      period: 'custom',
      startDate: dayStart,
      endDate: dayEnd,
    );

    final key = '${date.day}/${date.month}';
    breakdown[key] = salesData['totalRevenue'] as double;
  }

  return breakdown;
}

Future<Map<String, double>> _getWeeklyBreakdown(
  AnalyticsService analytics,
  DateTime startDate,
  DateTime endDate,
) async {
  final breakdown = <String, double>{};

  var currentStart = startDate;
  int weekNum = 1;

  while (currentStart.isBefore(endDate)) {
    var currentEnd = currentStart.add(const Duration(days: 6));
    if (currentEnd.isAfter(endDate)) {
      currentEnd = endDate;
    }

    final salesData = await analytics.getSalesAnalytics(
      period: 'custom',
      startDate: currentStart,
      endDate: currentEnd,
    );

    breakdown['Week $weekNum'] = salesData['totalRevenue'] as double;

    currentStart = currentStart.add(const Duration(days: 7));
    weekNum++;
  }

  return breakdown;
}

Future<Map<String, double>> _getMonthlyBreakdown(
  AnalyticsService analytics,
  DateTime startDate,
  DateTime endDate,
) async {
  final breakdown = <String, double>{};

  for (var month = startDate.month; month <= endDate.month; month++) {
    final monthStart = DateTime(startDate.year, month, 1);
    final monthEnd = DateTime(startDate.year, month + 1, 0, 23, 59, 59);

    final salesData = await analytics.getSalesAnalytics(
      period: 'custom',
      startDate: monthStart,
      endDate: monthEnd,
    );

    breakdown[_getMonthName(month)] = salesData['totalRevenue'] as double;
  }

  return breakdown;
}

String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

List<String> _generateInsights(Map<String, dynamic> salesData) {
  final insights = <String>[];
  final totalRevenue = salesData['totalRevenue'] as double;
  final totalOrders = salesData['totalOrders'] as int;
  final avgOrderValue = salesData['averageOrderValue'] as double;

  if (totalOrders > 0) {
    insights.add('Total orders: $totalOrders');
    insights.add('Average order value: ₹${avgOrderValue.toStringAsFixed(2)}');
  }

  if (totalRevenue > 100000) {
    insights.add('🎉 Great! You\'ve crossed ₹1,00,000 in revenue!');
  } else if (totalRevenue > 50000) {
    insights.add('👍 Good revenue performance!');
  } else if (totalRevenue > 10000) {
    insights.add('📈 Keep growing! You\'re on the right track.');
  }

  return insights;
}

List<String> _generateYearlyInsights(
  Map<String, dynamic> salesData,
  Map<String, dynamic> customerData,
) {
  final insights = <String>[];
  final totalRevenue = salesData['totalRevenue'] as double;
  final totalOrders = salesData['totalOrders'] as int;
  final totalCustomers = customerData['totalCustomers'] as int;
  final repeatCustomers = customerData['repeatCustomers'] as int;

  insights.add('Yearly Revenue: ₹${totalRevenue.toStringAsFixed(2)}');
  insights.add('Total Orders: $totalOrders');
  insights.add('Total Customers: $totalCustomers');

  if (repeatCustomers > 0) {
    final retentionRate = (repeatCustomers / totalCustomers) * 100;
    insights.add(
      'Customer Retention Rate: ${retentionRate.toStringAsFixed(1)}%',
    );
  }

  return insights;
}

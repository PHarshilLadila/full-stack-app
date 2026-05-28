// lib/features/analytics/services/analytics_service.dart

import 'dart:convert';

import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/analytics/model/analytics_models.dart';

enum AnalyticsPeriod { today, week, month, year }

class AnalyticsService {
  final ApiClient _apiClient = ApiClient();

  Future<DashboardAnalytics> getDashboardAnalytics({
    required String token,
    AnalyticsPeriod period = AnalyticsPeriod.week,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, dynamic>{};

    if (startDate != null && endDate != null) {
      queryParams['startDate'] = startDate;
      queryParams['endDate'] = endDate;
    } else {
      queryParams['period'] = _getPeriodString(period);
    }

    final response = await _apiClient.get(
      '/analytics/dashboard',
      token: token,
      queryParams: queryParams,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return DashboardAnalytics.fromJson(jsonResponse['data']);
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to fetch dashboard analytics',
        );
      }
    } else {
      throw Exception(
        'Failed to fetch dashboard analytics: ${response.statusCode}',
      );
    }
  }

  Future<OrderAnalytics> getOrderAnalytics({
    required String token,
    AnalyticsPeriod period = AnalyticsPeriod.month,
  }) async {
    final response = await _apiClient.get(
      '/analytics/orders',
      token: token,
      queryParams: {'period': _getPeriodString(period)},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return OrderAnalytics.fromJson(jsonResponse['data']);
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to fetch order analytics',
        );
      }
    } else {
      throw Exception(
        'Failed to fetch order analytics: ${response.statusCode}',
      );
    }
  }

  Future<SalesAnalytics> getSalesAnalytics({
    required String token,
    AnalyticsPeriod period = AnalyticsPeriod.week,
  }) async {
    final response = await _apiClient.get(
      '/analytics/sales',
      token: token,
      queryParams: {'period': _getPeriodString(period)},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return SalesAnalytics.fromJson(jsonResponse['data']);
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to fetch sales analytics',
        );
      }
    } else {
      throw Exception(
        'Failed to fetch sales analytics: ${response.statusCode}',
      );
    }
  }

  Future<ProductAnalyticsResponse> getProductAnalytics({
    required String token,
    String sortBy = 'revenue',
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/analytics/products',
      token: token,
      queryParams: {'sortBy': sortBy, 'limit': limit},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return ProductAnalyticsResponse.fromJson(jsonResponse['data']);
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to fetch product analytics',
        );
      }
    } else {
      throw Exception(
        'Failed to fetch product analytics: ${response.statusCode}',
      );
    }
  }

  Future<CustomerAnalytics> getCustomerAnalytics({
    required String token,
  }) async {
    final response = await _apiClient.get('/analytics/customers', token: token);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return CustomerAnalytics.fromJson(jsonResponse['data']);
      } else {
        throw Exception(
          jsonResponse['message'] ?? 'Failed to fetch customer analytics',
        );
      }
    } else {
      throw Exception(
        'Failed to fetch customer analytics: ${response.statusCode}',
      );
    }
  }

  Future<ReportResponse> getReport({
    required String token,
    required String type,
    required String date,
  }) async {
    final response = await _apiClient.get(
      '/analytics/reports',
      token: token,
      queryParams: {'type': type, 'date': date},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return ReportResponse.fromJson(jsonResponse['data']);
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to fetch report');
      }
    } else {
      throw Exception('Failed to fetch report: ${response.statusCode}');
    }
  }

  String _getPeriodString(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.today:
        return 'today';
      case AnalyticsPeriod.week:
        return 'week';
      case AnalyticsPeriod.month:
        return 'month';
      case AnalyticsPeriod.year:
        return 'year';
    }
  }
}

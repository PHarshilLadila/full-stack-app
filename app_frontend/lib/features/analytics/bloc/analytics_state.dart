// lib/features/analytics/bloc/analytics_state.dart

import 'package:app_frontend/features/analytics/model/analytics_models.dart';
import 'package:app_frontend/features/analytics/service/analytics_service.dart';
import 'package:equatable/equatable.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class DashboardAnalyticsLoaded extends AnalyticsState {
  final DashboardAnalytics dashboardAnalytics;
  final AnalyticsPeriod currentPeriod;

  const DashboardAnalyticsLoaded({
    required this.dashboardAnalytics,
    this.currentPeriod = AnalyticsPeriod.week,
  });

  @override
  List<Object?> get props => [dashboardAnalytics, currentPeriod];
}

class OrderAnalyticsLoaded extends AnalyticsState {
  final OrderAnalytics orderAnalytics;
  final AnalyticsPeriod currentPeriod;

  const OrderAnalyticsLoaded({
    required this.orderAnalytics,
    this.currentPeriod = AnalyticsPeriod.month,
  });

  @override
  List<Object?> get props => [orderAnalytics, currentPeriod];
}

class SalesAnalyticsLoaded extends AnalyticsState {
  final SalesAnalytics salesAnalytics;
  final AnalyticsPeriod currentPeriod;

  const SalesAnalyticsLoaded({
    required this.salesAnalytics,
    this.currentPeriod = AnalyticsPeriod.week,
  });

  @override
  List<Object?> get props => [salesAnalytics, currentPeriod];
}

class ProductAnalyticsLoaded extends AnalyticsState {
  final ProductAnalyticsResponse productAnalytics;
  final String currentSortBy;

  const ProductAnalyticsLoaded({
    required this.productAnalytics,
    this.currentSortBy = 'revenue',
  });

  @override
  List<Object?> get props => [productAnalytics, currentSortBy];
}

class CustomerAnalyticsLoaded extends AnalyticsState {
  final CustomerAnalytics customerAnalytics;

  const CustomerAnalyticsLoaded({required this.customerAnalytics});

  @override
  List<Object?> get props => [customerAnalytics];
}

class ReportLoaded extends AnalyticsState {
  final ReportResponse report;

  const ReportLoaded({required this.report});

  @override
  List<Object?> get props => [report];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}

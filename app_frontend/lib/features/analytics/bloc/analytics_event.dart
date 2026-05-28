// lib/features/analytics/bloc/analytics_event.dart

 
import 'package:app_frontend/features/analytics/service/analytics_service.dart';
import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class FetchDashboardAnalytics extends AnalyticsEvent {
  final AnalyticsPeriod period;
  final String? startDate;
  final String? endDate;

  const FetchDashboardAnalytics({
    this.period = AnalyticsPeriod.week,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [period, startDate, endDate];
}

class FetchOrderAnalytics extends AnalyticsEvent {
  final AnalyticsPeriod period;

  const FetchOrderAnalytics({this.period = AnalyticsPeriod.month});

  @override
  List<Object?> get props => [period];
}

class FetchSalesAnalytics extends AnalyticsEvent {
  final AnalyticsPeriod period;

  const FetchSalesAnalytics({this.period = AnalyticsPeriod.week});

  @override
  List<Object?> get props => [period];
}

class FetchProductAnalytics extends AnalyticsEvent {
  final String sortBy;
  final int limit;

  const FetchProductAnalytics({this.sortBy = 'revenue', this.limit = 20});

  @override
  List<Object?> get props => [sortBy, limit];
}

class FetchCustomerAnalytics extends AnalyticsEvent {
  const FetchCustomerAnalytics();
}

class FetchReport extends AnalyticsEvent {
  final String type;
  final String date;

  const FetchReport({required this.type, required this.date});

  @override
  List<Object?> get props => [type, date];
}

class ChangeAnalyticsPeriod extends AnalyticsEvent {
  final AnalyticsPeriod period;

  const ChangeAnalyticsPeriod(this.period);

  @override
  List<Object?> get props => [period];
}
// lib/features/analytics/bloc/analytics_bloc.dart

import 'package:app_frontend/features/analytics/bloc/analytics_event.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_state.dart';
import 'package:app_frontend/features/analytics/service/analytics_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsService _analyticsService = AnalyticsService();
  String _token;

  String get token => _token;

  // Loading flags to prevent duplicate requests
  bool _isLoadingDashboard = false;
  bool _isLoadingOrders = false;
  bool _isLoadingSales = false;
  bool _isLoadingProducts = false;
  bool _isLoadingCustomers = false;
  bool _isLoadingReport = false;

  AnalyticsBloc({required String token})
    : _token = token,
      super(AnalyticsInitial()) {
    on<FetchDashboardAnalytics>(_onFetchDashboardAnalytics);
    on<FetchOrderAnalytics>(_onFetchOrderAnalytics);
    on<FetchSalesAnalytics>(_onFetchSalesAnalytics);
    on<FetchProductAnalytics>(_onFetchProductAnalytics);
    on<FetchCustomerAnalytics>(_onFetchCustomerAnalytics);
    on<FetchReport>(_onFetchReport);
    on<ChangeAnalyticsPeriod>(_onChangeAnalyticsPeriod);
  }

  void updateToken(String newToken) {
    _token = newToken;
  }

  Future<void> _onFetchDashboardAnalytics(
    FetchDashboardAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Prevent duplicate requests
    if (_isLoadingDashboard) return;

    _isLoadingDashboard = true;
    emit(AnalyticsLoading());

    try {
      final data = await _analyticsService.getDashboardAnalytics(
        token: _token,
        period: event.period,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (!isClosed) {
        emit(
          DashboardAnalyticsLoaded(
            dashboardAnalytics: data,
            currentPeriod: event.period,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(AnalyticsError(e.toString()));
      }
    } finally {
      _isLoadingDashboard = false;
    }
  }

  Future<void> _onFetchOrderAnalytics(
    FetchOrderAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Prevent duplicate requests
    if (_isLoadingOrders) return;

    _isLoadingOrders = true;
    emit(AnalyticsLoading());

    try {
      final data = await _analyticsService.getOrderAnalytics(
        token: _token,
        period: event.period,
      );

      if (!isClosed) {
        emit(
          OrderAnalyticsLoaded(
            orderAnalytics: data,
            currentPeriod: event.period,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(AnalyticsError(e.toString()));
      }
    } finally {
      _isLoadingOrders = false;
    }
  }

  Future<void> _onFetchSalesAnalytics(
    FetchSalesAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Prevent duplicate requests
    if (_isLoadingSales) return;

    _isLoadingSales = true;
    emit(AnalyticsLoading());

    try {
      final data = await _analyticsService.getSalesAnalytics(
        token: _token,
        period: event.period,
      );

      if (!isClosed) {
        emit(
          SalesAnalyticsLoaded(
            salesAnalytics: data,
            currentPeriod: event.period,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(AnalyticsError(e.toString()));
      }
    } finally {
      _isLoadingSales = false;
    }
  }

  Future<void> _onFetchProductAnalytics(
    FetchProductAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Prevent duplicate requests
    if (_isLoadingProducts) return;

    _isLoadingProducts = true;
    emit(AnalyticsLoading());

    try {
      final data = await _analyticsService.getProductAnalytics(
        token: _token,
        sortBy: event.sortBy,
        limit: event.limit,
      );

      if (!isClosed) {
        emit(
          ProductAnalyticsLoaded(
            productAnalytics: data,
            currentSortBy: event.sortBy,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(AnalyticsError(e.toString()));
      }
    } finally {
      _isLoadingProducts = false;
    }
  }

  Future<void> _onFetchCustomerAnalytics(
    FetchCustomerAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Prevent duplicate requests
    if (_isLoadingCustomers) return;

    _isLoadingCustomers = true;
    emit(AnalyticsLoading());

    try {
      final data = await _analyticsService.getCustomerAnalytics(token: _token);

      if (!isClosed) {
        emit(CustomerAnalyticsLoaded(customerAnalytics: data));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AnalyticsError(e.toString()));
      }
    } finally {
      _isLoadingCustomers = false;
    }
  }

  Future<void> _onFetchReport(
    FetchReport event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Prevent duplicate requests
    if (_isLoadingReport) return;

    _isLoadingReport = true;
    emit(AnalyticsLoading());

    try {
      final data = await _analyticsService.getReport(
        token: _token,
        type: event.type,
        date: event.date,
      );

      if (!isClosed) {
        emit(ReportLoaded(report: data));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AnalyticsError(e.toString()));
      }
    } finally {
      _isLoadingReport = false;
    }
  }

  void _onChangeAnalyticsPeriod(
    ChangeAnalyticsPeriod event,
    Emitter<AnalyticsState> emit,
  ) {
    if (state is DashboardAnalyticsLoaded) {
      add(FetchDashboardAnalytics(period: event.period));
    } else if (state is OrderAnalyticsLoaded) {
      add(FetchOrderAnalytics(period: event.period));
    } else if (state is SalesAnalyticsLoaded) {
      add(FetchSalesAnalytics(period: event.period));
    }
  }

  @override
  Future<void> close() async {
    // Reset all loading flags when closing
    _isLoadingDashboard = false;
    _isLoadingOrders = false;
    _isLoadingSales = false;
    _isLoadingProducts = false;
    _isLoadingCustomers = false;
    _isLoadingReport = false;
    await super.close();
  }
}

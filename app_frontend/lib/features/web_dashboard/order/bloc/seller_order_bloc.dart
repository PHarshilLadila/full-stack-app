import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'seller_order_event.dart';
import 'seller_order_state.dart';
import '../model/seller_order_model.dart';
import '../service/seller_order_service.dart';

class SellerOrderBloc extends Bloc<SellerOrderEvent, SellerOrderState> {
  final SellerOrderService _orderService;
  List<SellerOrderModel> allOrders = [];
  PaginationInfo? currentPagination;
  String? currentFilter;

  SellerOrderBloc({required SellerOrderService orderService})
      : _orderService = orderService,
        super(SellerOrderInitial()) {
    on<FetchSellerOrders>(_onFetchOrders);
    on<RefreshSellerOrders>(_onRefreshOrders);
    on<LoadMoreSellerOrders>(_onLoadMoreOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<FilterOrdersByStatus>(_onFilterOrders);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _onFetchOrders(
    FetchSellerOrders event,
    Emitter<SellerOrderState> emit,
  ) async {
    emit(SellerOrderLoading());
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const SellerOrderError(message: 'Please login to continue'));
        return;
      }

      final result = await _orderService.getSellerOrders(
        token: token,
        page: event.page,
        limit: event.limit,
        status: event.status,
      );

      allOrders = result['orders'] as List<SellerOrderModel>;
      currentPagination = result['pagination'] as PaginationInfo;
      currentFilter = event.status;

      emit(SellerOrderLoaded(
        orders: allOrders,
        pagination: currentPagination!,
        hasReachedMax: currentPagination!.currentPage >= currentPagination!.totalPages,
        currentFilter: currentFilter,
      ));
    } catch (e) {
      emit(SellerOrderError(message: e.toString()));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshSellerOrders event,
    Emitter<SellerOrderState> emit,
  ) async {
    add(FetchSellerOrders(
      page: 1,
      limit: 10,
      status: event.status ?? currentFilter,
    ));
  }

  Future<void> _onLoadMoreOrders(
    LoadMoreSellerOrders event,
    Emitter<SellerOrderState> emit,
  ) async {
    if (state is SellerOrderLoaded && !(state as SellerOrderLoaded).hasReachedMax) {
      try {
        final token = await _getToken();
        if (token == null || token.isEmpty) return;

        final result = await _orderService.getSellerOrders(
          token: token,
          page: event.page,
          limit: 10,
          status: currentFilter,
        );

        final newOrders = result['orders'] as List<SellerOrderModel>;
        final newPagination = result['pagination'] as PaginationInfo;

        allOrders.addAll(newOrders);
        currentPagination = newPagination;

        emit(SellerOrderLoaded(
          orders: allOrders,
          pagination: newPagination,
          hasReachedMax: newPagination.currentPage >= newPagination.totalPages,
          currentFilter: currentFilter,
        ));
      } catch (e) {
        emit(SellerOrderError(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<SellerOrderState> emit,
  ) async {
    emit(OrderStatusUpdating(orderId: event.orderId));
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const SellerOrderError(message: 'Please login to continue'));
        return;
      }

      final response = await _orderService.updateOrderStatus(
        token: token,
        orderId: event.orderId,
        orderStatus: event.orderStatus,
        trackingId: event.trackingId,
      );

      if (response['success'] == true) {
        emit(OrderStatusUpdated(
          message: response['message'] ?? 'Order status updated successfully',
          orderId: event.orderId,
          newStatus: event.orderStatus,
        ));
        // Refresh orders after update
        add(RefreshSellerOrders(status: currentFilter));
      } else {
        emit(SellerOrderError(message: response['message'] ?? 'Failed to update status'));
      }
    } catch (e) {
      emit(SellerOrderError(message: e.toString()));
    }
  }

  Future<void> _onFilterOrders(
    FilterOrdersByStatus event,
    Emitter<SellerOrderState> emit,
  ) async {
    currentFilter = event.status;
    add(FetchSellerOrders(
      page: 1,
      limit: 10,
      status: event.status,
    ));
  }
}
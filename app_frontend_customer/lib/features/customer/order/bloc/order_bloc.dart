import 'package:app_frontend_customer/features/customer/order/model/order_model.dart';
import 'package:app_frontend_customer/features/customer/order/service/order_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderService orderService;
  List<OrderModel> allOrders = [];
  PaginationInfo? currentPagination;

  OrderBloc({required this.orderService}) : super(OrderInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<RefreshOrders>(_onRefreshOrders);
    on<LoadMoreOrders>(_onLoadMoreOrders);
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final result = await orderService.getCustomerOrders(
        page: event.page,
        limit: event.limit,
      );

      allOrders = result['orders'] as List<OrderModel>;
      currentPagination = result['pagination'] as PaginationInfo;

      emit(
        OrderLoaded(
          orders: allOrders,
          pagination: currentPagination!,
          hasReachedMax:
              currentPagination!.currentPage >= currentPagination!.totalPages,
        ),
      );
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrderState> emit,
  ) async {
    add(const FetchOrders(page: 1));
  }

  Future<void> _onLoadMoreOrders(
    LoadMoreOrders event,
    Emitter<OrderState> emit,
  ) async {
    if (state is OrderLoaded && !(state as OrderLoaded).hasReachedMax) {
      try {
        final result = await orderService.getCustomerOrders(
          page: event.page,
          limit: 10,
        );

        final newOrders = result['orders'] as List<OrderModel>;
        final newPagination = result['pagination'] as PaginationInfo;

        allOrders.addAll(newOrders);
        currentPagination = newPagination;

        emit(
          OrderLoaded(
            orders: allOrders,
            pagination: newPagination,
            hasReachedMax:
                newPagination.currentPage >= newPagination.totalPages,
          ),
        );
      } catch (e) {
        emit(OrderError(message: e.toString()));
      }
    }
  }
}

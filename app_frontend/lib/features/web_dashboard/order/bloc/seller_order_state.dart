import 'package:equatable/equatable.dart';
import '../model/seller_order_model.dart';

abstract class SellerOrderState extends Equatable {
  const SellerOrderState();

  @override
  List<Object?> get props => [];
}

class SellerOrderInitial extends SellerOrderState {}

class SellerOrderLoading extends SellerOrderState {}

class SellerOrderLoaded extends SellerOrderState {
  final List<SellerOrderModel> orders;
  final PaginationInfo pagination;
  final bool hasReachedMax;
  final String? currentFilter;

  const SellerOrderLoaded({
    required this.orders,
    required this.pagination,
    this.hasReachedMax = false,
    this.currentFilter,
  });

  SellerOrderLoaded copyWith({
    List<SellerOrderModel>? orders,
    PaginationInfo? pagination,
    bool? hasReachedMax,
    String? currentFilter,
  }) {
    return SellerOrderLoaded(
      orders: orders ?? this.orders,
      pagination: pagination ?? this.pagination,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [orders, pagination, hasReachedMax, currentFilter];
}

class SellerOrderError extends SellerOrderState {
  final String message;

  const SellerOrderError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderStatusUpdating extends SellerOrderState {
  final String orderId;

  const OrderStatusUpdating({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderStatusUpdated extends SellerOrderState {
  final String message;
  final String orderId;
  final String newStatus;

  const OrderStatusUpdated({
    required this.message,
    required this.orderId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [message, orderId, newStatus];
}
import 'package:app_frontend_customer/features/customer/order/model/order_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;
  final PaginationInfo pagination;
  final bool hasReachedMax;

  const OrderLoaded({
    required this.orders,
    required this.pagination,
    this.hasReachedMax = false,
  });

  OrderLoaded copyWith({
    List<OrderModel>? orders,
    PaginationInfo? pagination,
    bool? hasReachedMax,
  }) {
    return OrderLoaded(
      orders: orders ?? this.orders,
      pagination: pagination ?? this.pagination,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [orders, pagination, hasReachedMax];
}

class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

abstract class SellerOrderEvent extends Equatable {
  const SellerOrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchSellerOrders extends SellerOrderEvent {
  final int page;
  final int limit;
  final String? status;

  const FetchSellerOrders({
    this.page = 1,
    this.limit = 10,
    this.status,
  });

  @override
  List<Object?> get props => [page, limit, status];
}

class RefreshSellerOrders extends SellerOrderEvent {
  final String? status;

  const RefreshSellerOrders({this.status});

  @override
  List<Object?> get props => [status];
}

class LoadMoreSellerOrders extends SellerOrderEvent {
  final int page;

  const LoadMoreSellerOrders({required this.page});

  @override
  List<Object?> get props => [page];
}

class UpdateOrderStatus extends SellerOrderEvent {
  final String orderId;
  final String orderStatus;
  final String? trackingId;

  const UpdateOrderStatus({
    required this.orderId,
    required this.orderStatus,
    this.trackingId,
  });

  @override
  List<Object?> get props => [orderId, orderStatus, trackingId];
}

class FilterOrdersByStatus extends SellerOrderEvent {
  final String? status;

  const FilterOrdersByStatus({this.status});

  @override
  List<Object?> get props => [status];
}
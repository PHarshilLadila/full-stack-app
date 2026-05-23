import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrders extends OrderEvent {
  final int page;
  final int limit;

  const FetchOrders({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

class RefreshOrders extends OrderEvent {}

class LoadMoreOrders extends OrderEvent {
  final int page;

  const LoadMoreOrders({required this.page});

  @override
  List<Object?> get props => [page];
}
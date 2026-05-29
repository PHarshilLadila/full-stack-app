// lib/features/seller/home/bloc/product_event.dart
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// Fetch Seller Products
class FetchSellerProducts extends ProductEvent {
  final int page;
  final int limit;

  const FetchSellerProducts({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

// Load More Seller Products
class LoadMoreSellerProducts extends ProductEvent {
  final int page;

  const LoadMoreSellerProducts({required this.page});

  @override
  List<Object?> get props => [page];
}

// Refresh Seller Products
class RefreshSellerProducts extends ProductEvent {}
// lib/features/seller/home/bloc/product_state.dart
import 'package:equatable/equatable.dart';
import '../model/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class SellerProductLoading extends ProductState {}

class SellerProductLoaded extends ProductState {
  final List<Product> products;
  final Pagination pagination;
  final bool hasReachedMax;

  const SellerProductLoaded({
    required this.products,
    required this.pagination,
    this.hasReachedMax = false,
  });

  SellerProductLoaded copyWith({
    List<Product>? products,
    Pagination? pagination,
    bool? hasReachedMax,
  }) {
    return SellerProductLoaded(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [products, pagination, hasReachedMax];
}

class SellerProductLoadingMore extends ProductState {}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

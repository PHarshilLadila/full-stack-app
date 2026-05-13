// lib/features/product/bloc/product_state.dart
import 'package:equatable/equatable.dart';
import '../model/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final Pagination pagination;
  final bool hasReachedMax;
  final String? currentCategory;
  final String? searchQuery;

  const ProductLoaded({
    required this.products,
    required this.pagination,
    this.hasReachedMax = false,
    this.currentCategory,
    this.searchQuery,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    Pagination? pagination,
    bool? hasReachedMax,
    String? currentCategory,
    String? searchQuery,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentCategory: currentCategory ?? this.currentCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    products,
    pagination,
    hasReachedMax,
    currentCategory,
    searchQuery,
  ];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductLoadingMore extends ProductState {}

class ProductSearchLoading extends ProductState {}

class ProductSearchLoaded extends ProductState {
  final List<Product> products;
  final String query;

  const ProductSearchLoaded({
    required this.products,
    required this.query,
  });

  @override
  List<Object?> get props => [products, query];
}
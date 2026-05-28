// lib/features/seller/products/bloc/product_state.dart

import 'package:app_frontend/features/seller/products/model/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  ProductLoaded({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  ProductLoaded copyWith({
    List<ProductModel>? products,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
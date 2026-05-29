// lib/features/seller/home/bloc/product_bloc.dart
import 'dart:developer';

import 'package:app_frontend/features/seller/home/bloc/product_event.dart';
import 'package:app_frontend/features/seller/home/bloc/product_state.dart';
import 'package:app_frontend/features/seller/home/model/product_model.dart';
import 'package:app_frontend/features/seller/home/service/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc({required this.productService}) : super(ProductInitial()) {
    on<FetchSellerProducts>(_onFetchSellerProducts);
    on<LoadMoreSellerProducts>(_onLoadMoreSellerProducts);
    on<RefreshSellerProducts>(_onRefreshSellerProducts);
  }

  // Fetch Seller Products
  Future<void> _onFetchSellerProducts(
    FetchSellerProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(SellerProductLoading());
      log('Fetching seller products - Page: ${event.page}, Limit: ${event.limit}');

      final response = await productService.getSellerProducts(
        page: event.page,
        limit: event.limit,
      );

      emit(
        SellerProductLoaded(
          products: response.data,
          pagination: response.pagination,
          hasReachedMax:
              response.pagination.currentPage >= response.pagination.totalPages,
        ),
      );
      log('Seller products loaded successfully - Count: ${response.data.length}');
    } catch (e) {
      log('Fetch seller products error: $e');
      emit(ProductError(e.toString()));
    }
  }

  // Load More Seller Products
  Future<void> _onLoadMoreSellerProducts(
    LoadMoreSellerProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is SellerProductLoaded) {
      final currentState = state as SellerProductLoaded;

      if (currentState.hasReachedMax) {
        log('Already reached max seller products');
        return;
      }

      try {
        emit(SellerProductLoadingMore());
        log('Loading more seller products - Page: ${event.page}');

        final response = await productService.getSellerProducts(
          page: event.page,
          limit: currentState.pagination.itemsPerPage,
        );

        final updatedProducts = List<Product>.from(currentState.products)
          ..addAll(response.data);

        emit(
          SellerProductLoaded(
            products: updatedProducts,
            pagination: response.pagination,
            hasReachedMax:
                response.pagination.currentPage >=
                response.pagination.totalPages,
          ),
        );
        log('Loaded more seller products - Total: ${updatedProducts.length}');
      } catch (e) {
        log('Load more seller products error: $e');
        emit(ProductError(e.toString()));
      }
    }
  }

  // Refresh Seller Products
  Future<void> _onRefreshSellerProducts(
    RefreshSellerProducts event,
    Emitter<ProductState> emit,
  ) async {
    add(const FetchSellerProducts());
  }
}
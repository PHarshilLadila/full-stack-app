// lib/features/seller/products/bloc/product_bloc.dart

import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc(this.productService) : super(ProductInitial()) {
    on<FetchSellerProductsEvent>(_fetchProducts);
    on<ChangePageEvent>(_changePage);
  }

  Future<void> _fetchProducts(
    FetchSellerProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final paginatedData = await productService.fetchSellerProducts(
        page: event.page,
        limit: event.limit,
      );

      emit(
        ProductLoaded(
          products: paginatedData.products,
          currentPage: paginatedData.currentPage,
          totalPages: paginatedData.totalPages,
          totalItems: paginatedData.totalItems,
          itemsPerPage: paginatedData.itemsPerPage,
        ),
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _changePage(
    ChangePageEvent event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(ProductLoading());

      try {
        final paginatedData = await productService.fetchSellerProducts(
          page: event.page,
          limit: event.limit,
        );

        emit(
          ProductLoaded(
            products: paginatedData.products,
            currentPage: paginatedData.currentPage,
            totalPages: paginatedData.totalPages,
            totalItems: paginatedData.totalItems,
            itemsPerPage: paginatedData.itemsPerPage,
          ),
        );
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }
}

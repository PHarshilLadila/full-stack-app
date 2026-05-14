// lib/features/product/bloc/product_bloc.dart
import 'dart:developer';

 
import 'package:app_frontend_customer/features/customer/home/bloc/product_event.dart';
import 'package:app_frontend_customer/features/customer/home/bloc/product_state.dart';
import 'package:app_frontend_customer/features/customer/home/model/product_model.dart';
import 'package:app_frontend_customer/features/customer/home/service/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc({required this.productService}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<FetchProductsByCategory>(_onFetchProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      log('Fetching products - Page: ${event.page}, Limit: ${event.limit}');

      final response = await productService.getProducts(
        page: event.page,
        limit: event.limit,
        category: event.category,
        searchQuery: event.searchQuery,
      );

      emit(
        ProductLoaded(
          products: response.data,
          pagination: response.pagination,
          hasReachedMax:
              response.pagination.currentPage >= response.pagination.totalPages,
          currentCategory: event.category,
          searchQuery: event.searchQuery,
        ),
      );
      log('Products loaded successfully - Count: ${response.data.length}');
    } catch (e) {
      log('Fetch products error: $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchProductsByCategory(
    FetchProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());
      log('Fetching products by category: ${event.category}');

      final response = await productService.getProductsByCategory(
        event.category,
      );

      emit(
        ProductLoaded(
          products: response.data,
          pagination: response.pagination,
          hasReachedMax:
              response.pagination.currentPage >= response.pagination.totalPages,
          currentCategory: event.category,
        ),
      );
      log('Category products loaded - Count: ${response.data.length}');
    } catch (e) {
      log('Fetch products by category error: $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductSearchLoading());
      log('Searching products: ${event.query}');

      final response = await productService.searchProducts(event.query);

      emit(ProductSearchLoaded(products: response.data, query: event.query));
      log('Search products loaded - Count: ${response.data.length}');
    } catch (e) {
      log('Search products error: $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      if (currentState.hasReachedMax) {
        log('Already reached max products');
        return;
      }

      try {
        emit(ProductLoadingMore());
        log('Loading more products - Page: ${event.page}');

        final response = await productService.getProducts(
          page: event.page,
          limit: currentState.pagination.itemsPerPage,
          category: currentState.currentCategory,
          searchQuery: currentState.searchQuery,
        );

        final updatedProducts = List<Product>.from(currentState.products)
          ..addAll(response.data);

        emit(
          currentState.copyWith(
            products: updatedProducts,
            pagination: response.pagination,
            hasReachedMax:
                response.pagination.currentPage >=
                response.pagination.totalPages,
          ),
        );
        log('Loaded more products - Total: ${updatedProducts.length}');
      } catch (e) {
        log('Load more products error: $e');
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      add(
        FetchProducts(
          category: currentState.currentCategory,
          searchQuery: currentState.searchQuery,
        ),
      );
    } else {
      add(const FetchProducts());
    }
  }
}

// lib/features/customer/home/bloc/product_details_bloc.dart
import 'dart:developer';
import 'package:app_frontend_customer/features/customer/home/bloc/product_details_bloc/product_details_event.dart';
import 'package:app_frontend_customer/features/customer/home/bloc/product_details_bloc/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_frontend_customer/features/customer/home/service/product_details_service.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductDetailsService productDetailsService;

  ProductDetailsBloc({required this.productDetailsService}) 
      : super(ProductDetailsInitial()) {
    on<FetchProductDetails>(_onFetchProductDetails);
    on<ClearProductDetails>(_onClearProductDetails);
  }

  Future<void> _onFetchProductDetails(
    FetchProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    try {
      emit(ProductDetailsLoading());
      log('Fetching product details for ID: ${event.productId}');

      final product = await productDetailsService.getProductDetails(event.productId);

      emit(ProductDetailsLoaded(product: product));
      log('Product details loaded successfully');
    } catch (e) {
      log('Fetch product details error: $e');
      emit(ProductDetailsError(message: e.toString()));
    }
  }

  void _onClearProductDetails(
    ClearProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) {
    emit(ProductDetailsInitial());
  }
}
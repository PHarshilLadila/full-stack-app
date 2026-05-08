import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';

// Events
abstract class ProductDetailsEvent {}

class FetchProductDetailsEvent extends ProductDetailsEvent {
  final String productId;
  FetchProductDetailsEvent(this.productId);
}

// States
abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductModel product;
  ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  ProductDetailsError(this.message);
}

// BLoC
class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductService productService;

  ProductDetailsBloc(this.productService) : super(ProductDetailsInitial()) {
    on<FetchProductDetailsEvent>(_fetchProductDetails);
  }

  Future<void> _fetchProductDetails(
    FetchProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      log("Fetching product details for ID: ${event.productId}");
      final product = await productService.fetchProductDetails(event.productId);
      log("Product details fetched: ${product.productName}");
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      log("Product Details Error: $e");
      emit(ProductDetailsError(e.toString()));
    }
  }
}
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_details/product_details_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_details/product_details_state.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final CustomerWebService customerWebService;

  ProductDetailsBloc({required this.customerWebService})
    : super(ProductDetailsInitial()) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<LoadProductReviews>(_onLoadProductReviews);
    on<SelectProductImage>(_onSelectProductImage);
    on<SelectProductQuantity>(_onSelectProductQuantity);
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final productDetails = await customerWebService.getProductDetails(
        event.productId,
      );

      emit(
        ProductDetailsLoaded(
          product: productDetails.data,
          reviews: const [], // Empty list initially
          averageRating: productDetails.data.rating,
          totalReviews: productDetails.data.totalReviews,
          ratingDistribution: {},
        ),
      );

      // Load reviews after product details
      add(LoadProductReviews(productId: event.productId));
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductReviews(
    LoadProductReviews event,
    Emitter<ProductDetailsState> emit,
  ) async {
    try {
      final reviewsResponse = await customerWebService.getProductReviews(
        event.productId,
      );

      if (state is ProductDetailsLoaded) {
        final currentState = state as ProductDetailsLoaded;
        final data = reviewsResponse.data;

        // Data already contains List<ReviewData> - no cast needed
        final reviewsList = data.reviews;

        emit(
          ProductDetailsLoaded(
            product: currentState.product,
            reviews: reviewsList,
            averageRating: data.averageRating,
            totalReviews: data.totalReviews,
            ratingDistribution: data.ratingDistribution,
            selectedImageIndex: currentState.selectedImageIndex,
            quantity: currentState.quantity,
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to load reviews: $e');
      // Optionally emit error state or just log
    }
  }

  void _onSelectProductImage(
    SelectProductImage event,
    Emitter<ProductDetailsState> emit,
  ) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(
        ProductDetailsLoaded(
          product: currentState.product,
          reviews: currentState.reviews,
          averageRating: currentState.averageRating,
          totalReviews: currentState.totalReviews,
          ratingDistribution: currentState.ratingDistribution,
          selectedImageIndex: event.index,
          quantity: currentState.quantity,
        ),
      );
    }
  }

  void _onSelectProductQuantity(
    SelectProductQuantity event,
    Emitter<ProductDetailsState> emit,
  ) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(
        ProductDetailsLoaded(
          product: currentState.product,
          reviews: currentState.reviews,
          averageRating: currentState.averageRating,
          totalReviews: currentState.totalReviews,
          ratingDistribution: currentState.ratingDistribution,
          selectedImageIndex: currentState.selectedImageIndex,
          quantity: event.quantity,
        ),
      );
    }
  }
}

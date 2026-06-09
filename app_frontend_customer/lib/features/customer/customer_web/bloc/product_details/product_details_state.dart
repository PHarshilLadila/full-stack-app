// lib/features/customer/customer_web/customer_web_home/bloc/product_details/product_details_state.dart
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_details/product_details_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_review/product_reviews_model.dart';
 import 'package:equatable/equatable.dart'; 

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsData product;
  final List<ReviewData> reviews;
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingDistribution;
  final int selectedImageIndex;
  final int quantity;

  const ProductDetailsLoaded({
    required this.product,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    this.selectedImageIndex = 0,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [
    product,
    reviews,
    averageRating,
    totalReviews,
    ratingDistribution,
    selectedImageIndex,
    quantity,
  ];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
// lib/features/customer/customer_web/customer_web_home/bloc/product_details/product_details_event.dart
import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetails extends ProductDetailsEvent {
  final String productId;

  const LoadProductDetails({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class LoadProductReviews extends ProductDetailsEvent {
  final String productId;

  const LoadProductReviews({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class SelectProductImage extends ProductDetailsEvent {
  final int index;

  const SelectProductImage({required this.index});

  @override
  List<Object?> get props => [index];
}

class SelectProductQuantity extends ProductDetailsEvent {
  final int quantity;

  const SelectProductQuantity({required this.quantity});

  @override
  List<Object?> get props => [quantity];
}
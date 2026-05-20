// lib/features/customer/home/bloc/product_details_event.dart
import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductDetails extends ProductDetailsEvent {
  final String productId;

  const FetchProductDetails({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ClearProductDetails extends ProductDetailsEvent {}
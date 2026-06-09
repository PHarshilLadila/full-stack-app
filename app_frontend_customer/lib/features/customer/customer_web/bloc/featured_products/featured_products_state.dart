// lib/features/customer/customer_web/customer_web_home/bloc/featured_products/featured_products_state.dart
import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class FeaturedProductsState extends Equatable {
  const FeaturedProductsState();

  @override
  List<Object?> get props => [];
}

class FeaturedProductsInitial extends FeaturedProductsState {}

class FeaturedProductsLoading extends FeaturedProductsState {}

class FeaturedProductsLoaded extends FeaturedProductsState {
  final List<ProductData> products;

  const FeaturedProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class FeaturedProductsError extends FeaturedProductsState {
  final String message;

  const FeaturedProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
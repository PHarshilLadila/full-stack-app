// lib/features/customer/customer_web/customer_web_home/bloc/trending_products/trending_products_state.dart
import 'package:equatable/equatable.dart';
import '../../models/product_model.dart';

abstract class TrendingProductsState extends Equatable {
  const TrendingProductsState();

  @override
  List<Object?> get props => [];
}

class TrendingProductsInitial extends TrendingProductsState {}

class TrendingProductsLoading extends TrendingProductsState {}

class TrendingProductsLoaded extends TrendingProductsState {
  final List<ProductData> products;

  const TrendingProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class TrendingProductsError extends TrendingProductsState {
  final String message;

  const TrendingProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
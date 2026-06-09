// lib/features/customer/customer_web/customer_web_home/bloc/trending_products/trending_products_event.dart
import 'package:equatable/equatable.dart';

abstract class TrendingProductsEvent extends Equatable {
  const TrendingProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrendingProducts extends TrendingProductsEvent {
  const LoadTrendingProducts();
}
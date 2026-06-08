// lib/features/customer/customer_web/customer_web_home/bloc/featured_products/featured_products_event.dart
import 'package:equatable/equatable.dart';

abstract class FeaturedProductsEvent extends Equatable {
  const FeaturedProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeaturedProducts extends FeaturedProductsEvent {
  const LoadFeaturedProducts();

  @override
  List<Object?> get props => [];
}
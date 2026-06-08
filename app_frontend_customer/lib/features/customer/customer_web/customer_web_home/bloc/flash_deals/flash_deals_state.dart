// lib/features/customer/customer_web/customer_web_home/bloc/flash_deals/flash_deals_state.dart
import 'package:equatable/equatable.dart';
import '../../../models/product_model.dart';

abstract class FlashDealsState extends Equatable {
  const FlashDealsState();

  @override
  List<Object?> get props => [];
}

class FlashDealsInitial extends FlashDealsState {}

class FlashDealsLoading extends FlashDealsState {}

class FlashDealsLoaded extends FlashDealsState {
  final List<ProductData> products;

  const FlashDealsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class FlashDealsError extends FlashDealsState {
  final String message;

  const FlashDealsError({required this.message});

  @override
  List<Object?> get props => [message];
}
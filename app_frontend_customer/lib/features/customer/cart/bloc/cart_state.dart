import 'package:equatable/equatable.dart';
import 'package:app_frontend_customer/features/customer/cart/model/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

// Initial state
class CartInitial extends CartState {}

// Loading state
class CartLoading extends CartState {}

// Loaded state
class CartLoaded extends CartState {
  final CartSummary cartSummary;

  const CartLoaded({required this.cartSummary});

  @override
  List<Object?> get props => [cartSummary];
}

// Adding to cart state
class CartAdding extends CartState {
  final String productId;

  const CartAdding({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Add to cart success
class CartAddSuccess extends CartState {
  final String message;
  final int itemCount;

  const CartAddSuccess({required this.message, required this.itemCount});

  @override
  List<Object?> get props => [message, itemCount];
}

// Updating cart item state
class CartUpdating extends CartState {
  final String productId;

  const CartUpdating({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Update cart success
class CartUpdateSuccess extends CartState {
  final String message;

  const CartUpdateSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// Removing from cart state
class CartRemoving extends CartState {
  final String productId;

  const CartRemoving({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Remove from cart success
class CartRemoveSuccess extends CartState {
  final String message;

  const CartRemoveSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// Error state
class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}
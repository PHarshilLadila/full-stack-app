import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

// Load cart
class LoadCart extends CartEvent {
  const LoadCart();
}

// Refresh cart
class RefreshCart extends CartEvent {
  const RefreshCart();
}

// Add item to cart
class AddToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const AddToCartEvent({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

// Update cart item quantity
class UpdateCartItemEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateCartItemEvent({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

// Remove item from cart
class RemoveFromCartEvent extends CartEvent {
  final String productId;

  const RemoveFromCartEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Clear cart
class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
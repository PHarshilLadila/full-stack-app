import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrder extends CheckoutEvent {
  final String addressId;
  final String paymentMethod;
  final bool isDirectOrder;
  final String? directProductId;
  final int? directQuantity;

  const CreateOrder({
    required this.addressId,
    required this.paymentMethod,
    this.isDirectOrder = false,
    this.directProductId,
    this.directQuantity,
  });

  @override
  List<Object?> get props => [addressId, paymentMethod, isDirectOrder, directProductId, directQuantity];
}

class ConfirmPayment extends CheckoutEvent {
  final String orderId;
  final String paymentIntentId;

  const ConfirmPayment({
    required this.orderId,
    required this.paymentIntentId,
  });

  @override
  List<Object?> get props => [orderId, paymentIntentId];
}

class ResetCheckout extends CheckoutEvent {}
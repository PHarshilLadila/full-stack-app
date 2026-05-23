import 'package:equatable/equatable.dart';
import '../model/checkout_model.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutOrderCreated extends CheckoutState {
  final OrderData orderData;

  const CheckoutOrderCreated({required this.orderData});

  @override
  List<Object?> get props => [orderData];
}

class CheckoutPaymentConfirmed extends CheckoutState {
  final String orderId;
  final String orderStatus;
  final String paymentStatus;

  const CheckoutPaymentConfirmed({
    required this.orderId,
    required this.orderStatus,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props => [orderId, orderStatus, paymentStatus];
}

class CheckoutSuccess extends CheckoutState {
  final String message;
  final String orderId;

  const CheckoutSuccess({required this.message, required this.orderId});

  @override
  List<Object?> get props => [message, orderId];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object?> get props => [message];
}
import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePayment extends PaymentEvent {
  final String orderId;
  final String paymentMethod;

  const InitiatePayment({
    required this.orderId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [orderId, paymentMethod];
}

class VerifyPayment extends PaymentEvent {
  final String orderId;
  final String razorpayPaymentId;
  final String razorpayOrderId;
  final String razorpaySignature;

  const VerifyPayment({
    required this.orderId,
    required this.razorpayPaymentId,
    required this.razorpayOrderId,
    required this.razorpaySignature,
  });

  @override
  List<Object?> get props => [orderId, razorpayPaymentId, razorpayOrderId, razorpaySignature];
}

class CheckPaymentStatus extends PaymentEvent {
  final String orderId;

  const CheckPaymentStatus({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ResetPayment extends PaymentEvent {}
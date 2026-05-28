import 'package:app_frontend_customer/features/customer/payment/model/payment_model.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentInitiated extends PaymentState {
  final PaymentInitiateData paymentData;

  const PaymentInitiated({required this.paymentData});

  @override
  List<Object?> get props => [paymentData];
}

class PaymentVerified extends PaymentState {
  final PaymentVerifyData verificationData;

  const PaymentVerified({required this.verificationData});

  @override
  List<Object?> get props => [verificationData];
}

class PaymentStatusChecked extends PaymentState {
  final PaymentStatusData statusData;

  const PaymentStatusChecked({required this.statusData});

  @override
  List<Object?> get props => [statusData];
}

class PaymentSuccess extends PaymentState {
  final String orderId;
  final String message;

  const PaymentSuccess({required this.orderId, required this.message});

  @override
  List<Object?> get props => [orderId, message];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}

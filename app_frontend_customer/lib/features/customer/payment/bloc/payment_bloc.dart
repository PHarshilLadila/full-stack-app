import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment_event.dart';
import 'payment_state.dart';
import '../service/payment_service.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService _paymentService;

  PaymentBloc({required PaymentService paymentService})
    : _paymentService = paymentService,
      super(PaymentInitial()) {
    on<InitiatePayment>(_onInitiatePayment);
    on<VerifyPayment>(_onVerifyPayment);
    on<CheckPaymentStatus>(_onCheckPaymentStatus);
    on<ResetPayment>(_onResetPayment);
  }

  Future<String?> _getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("auth_token");
  }

  Future<void> _onInitiatePayment(
    InitiatePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const PaymentError(message: 'Please login to continue'));
        return;
      }

      final response = await _paymentService.initiatePayment(
        token: token,
        orderId: event.orderId,
        paymentMethod: event.paymentMethod,
      );

      if (response.success && response.data != null) {
        emit(PaymentInitiated(paymentData: response.data!));
      } else {
        emit(PaymentError(message: response.message));
      }
    } catch (e) {
      emit(
        PaymentError(message: 'Failed to initiate payment: ${e.toString()}'),
      );
    }
  }

  Future<void> _onVerifyPayment(
    VerifyPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const PaymentError(message: 'Please login to continue'));
        return;
      }

      final response = await _paymentService.verifyPayment(
        token: token,
        orderId: event.orderId,
        razorpayPaymentId: event.razorpayPaymentId,
        razorpayOrderId: event.razorpayOrderId,
        razorpaySignature: event.razorpaySignature,
      );

      if (response.success && response.data != null) {
        emit(PaymentVerified(verificationData: response.data!));
        emit(PaymentSuccess(orderId: event.orderId, message: response.message));
      } else {
        emit(PaymentError(message: response.message));
      }
    } catch (e) {
      emit(PaymentError(message: 'Failed to verify payment: ${e.toString()}'));
    }
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatus event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const PaymentError(message: 'Please login to continue'));
        return;
      }

      final response = await _paymentService.getPaymentStatus(
        token: token,
        orderId: event.orderId,
      );

      if (response.success && response.data != null) {
        emit(PaymentStatusChecked(statusData: response.data!));
      } else {
        emit(PaymentError(message: 'Failed to get payment status'));
      }
    } catch (e) {
      emit(
        PaymentError(message: 'Failed to get payment status: ${e.toString()}'),
      );
    }
  }

  void _onResetPayment(ResetPayment event, Emitter<PaymentState> emit) {
    emit(PaymentInitial());
  }
}

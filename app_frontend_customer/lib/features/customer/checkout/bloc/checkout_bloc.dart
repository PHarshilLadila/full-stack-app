import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';
import '../service/checkout_service.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutService checkoutService;

  CheckoutBloc({required this.checkoutService}) : super(CheckoutInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<ConfirmPayment>(_onConfirmPayment);
    on<ResetCheckout>(_onResetCheckout);
  }

  Future<String?> _getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("auth_token");
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CheckoutError(message: 'Please login to continue'));
        return;
      }

      final response = await checkoutService.createOrder(
        token: token,
        addressId: event.addressId,
        paymentMethod: event.paymentMethod,
        isDirectOrder: event.isDirectOrder,
        directProductId: event.directProductId,
        directQuantity: event.directQuantity,
      );

      print("========== CHECKOUT RESPONSE ==========");
      print("Success: ${response.success}");
      print("Message: ${response.message}");
      print("Order Data: ${response.data}");
      print("Payment Method: ${event.paymentMethod}");
      print("=======================================");

      if (response.success && response.data != null) {
        if (event.paymentMethod == 'cod') {
          // For COD, order is directly placed
          emit(
            CheckoutSuccess(
              message: response.message,
              orderId: response.data!.orderId,
            ),
          );
        } else if (event.paymentMethod == 'online') {
          // For online, go to payment screen
          emit(CheckoutOrderCreated(orderData: response.data!));
        } else {
          emit(CheckoutError(message: response.message));
        }
      } else {
        emit(CheckoutError(message: response.message));
      }
    } catch (e) {
      print("Checkout Error: $e");
      emit(CheckoutError(message: e.toString()));
    }
  }

  Future<void> _onConfirmPayment(
    ConfirmPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        emit(const CheckoutError(message: 'Please login to continue'));
        return;
      }

      final response = await checkoutService.confirmPayment(
        token: token,
        orderId: event.orderId,
        paymentIntentId: event.paymentIntentId,
      );

      if (response['success'] == true) {
        final data = response['data'];
        emit(
          CheckoutPaymentConfirmed(
            orderId: data['orderId'],
            orderStatus: data['orderStatus'],
            paymentStatus: data['paymentStatus'],
          ),
        );
        emit(
          CheckoutSuccess(
            message: 'Order placed successfully!',
            orderId: event.orderId,
          ),
        );
      } else {
        emit(
          CheckoutError(
            message: response['message'] ?? 'Payment confirmation failed',
          ),
        );
      }
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }

  void _onResetCheckout(ResetCheckout event, Emitter<CheckoutState> emit) {
    emit(CheckoutInitial());
  }
}
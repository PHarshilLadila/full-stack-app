import 'dart:convert';
import 'package:app_frontend_customer/core/network/api_client.dart';
import '../model/checkout_model.dart';

class CheckoutService {
  final ApiClient apiClient = ApiClient();

  Future<OrderResponse> createOrder({
    required String token,
    required String addressId,
    required String paymentMethod,
    bool isDirectOrder = false,
    String? directProductId,
    int? directQuantity,
  }) async {
    try {
      final request = CreateOrderRequest(
        addressId: addressId,
        paymentMethod: paymentMethod,
        isDirectOrder: isDirectOrder,
        directProduct: isDirectOrder && directProductId != null && directQuantity != null
            ? DirectProduct(productId: directProductId, quantity: directQuantity)
            : null,
      );

      final response = await apiClient.postWithParam(
        '/order/create',
        request.toJson(),
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return OrderResponse.fromJson(data);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  Future<Map<String, dynamic>> confirmPayment({
    required String token,
    required String orderId,
    required String paymentIntentId,
  }) async {
    try {
      final request = ConfirmPaymentRequest(
        orderId: orderId,
        paymentIntentId: paymentIntentId,
      );

      final response = await apiClient.postWithParam(
        '/order/confirm_payment',
        request.toJson(),
        token: token,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to confirm payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error confirming payment: $e');
    }
  }
}
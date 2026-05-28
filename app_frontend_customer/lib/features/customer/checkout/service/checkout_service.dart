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
      print("========== CREATE ORDER API ==========");
      print("Address ID: $addressId");
      print("Payment Method: $paymentMethod");
      print("Is Direct Order: $isDirectOrder");
      print("Direct Product ID: $directProductId");
      print("Direct Quantity: $directQuantity");

      final request = CreateOrderRequest(
        addressId: addressId,
        paymentMethod: paymentMethod,
        isDirectOrder: isDirectOrder,
        directProduct:
            isDirectOrder && directProductId != null && directQuantity != null
                ? DirectProduct(
                  productId: directProductId,
                  quantity: directQuantity,
                )
                : null,
      );

      print("Request Body: ${json.encode(request.toJson())}");

      final response = await apiClient.postWithParam(
        '/order/create',
        request.toJson(),
        token: token,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        print("Order Created Successfully");
        print("=====================================");

        return OrderResponse.fromJson(data);
      } else {
        print("Create Order Failed");
        print("=====================================");

        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      print("Create Order Exception: $e");
      print("=====================================");

      throw Exception('Error creating order: $e');
    }
  }

  Future<Map<String, dynamic>> confirmPayment({
    required String token,
    required String orderId,
    required String paymentIntentId,
  }) async {
    try {
      print("========== CONFIRM PAYMENT API ==========");
      print("Order ID: $orderId");
      print("Payment Intent ID: $paymentIntentId");

      final request = ConfirmPaymentRequest(
        orderId: orderId,
        paymentIntentId: paymentIntentId,
      );

      print("Request Body: ${json.encode(request.toJson())}");

      final response = await apiClient.postWithParam(
        '/order/confirm_payment',
        request.toJson(),
        token: token,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print("Payment Confirmed Successfully");
        print("========================================");

        return data;
      } else {
        print("Confirm Payment Failed");
        print("========================================");

        throw Exception('Failed to confirm payment: ${response.statusCode}');
      }
    } catch (e) {
      print("Confirm Payment Exception: $e");
      print("========================================");

      throw Exception('Error confirming payment: $e');
    }
  }
}

import 'dart:convert';
import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/customer/payment/model/payment_model.dart';

class PaymentService {
  final ApiClient _apiClient = ApiClient();

  Future<PaymentInitiateResponse> initiatePayment({
    required String token,
    required String orderId,
    required String paymentMethod,
  }) async {
    try {
      print("========== INITIATE PAYMENT API ==========");
      print("Order ID: $orderId");
      print("Payment Method: $paymentMethod");

      final response = await _apiClient.initiatePayment(
        orderId: orderId,
        paymentMethod: paymentMethod,
        token: token,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PaymentInitiateResponse.fromJson(data);
      } else {
        throw Exception('Failed to initiate payment: ${response.statusCode}');
      }
    } catch (e) {
      print("Initiate Payment Exception: $e");
      rethrow;
    }
  }

  Future<PaymentVerifyResponse> verifyPayment({
    required String token,
    required String orderId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    try {
      print("========== VERIFY PAYMENT API ==========");
      print("Order ID: $orderId");
      print("Payment ID: $razorpayPaymentId");
      print("Razorpay Order ID: $razorpayOrderId");

      final response = await _apiClient.verifyPayment(
        orderId: orderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpayOrderId: razorpayOrderId,
        razorpaySignature: razorpaySignature,
        token: token,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PaymentVerifyResponse.fromJson(data);
      } else {
        throw Exception('Failed to verify payment: ${response.statusCode}');
      }
    } catch (e) {
      print("Verify Payment Exception: $e");
      rethrow;
    }
  }

  Future<PaymentStatusResponse> getPaymentStatus({
    required String token,
    required String orderId,
  }) async {
    try {
      print("========== GET PAYMENT STATUS API ==========");
      print("Order ID: $orderId");

      final response = await _apiClient.getPaymentStatus(
        orderId: orderId,
        token: token,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PaymentStatusResponse.fromJson(data);
      } else {
        throw Exception('Failed to get payment status: ${response.statusCode}');
      }
    } catch (e) {
      print("Get Payment Status Exception: $e");
      rethrow;
    }
  }
}

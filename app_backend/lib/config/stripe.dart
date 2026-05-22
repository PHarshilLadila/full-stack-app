// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'package:http/http.dart' as http;

class StripeConfig {
  static late String secretKey;

  static void init(String key) {
    secretKey = key;
  }

  static Map<String, String> get _headers {
    return {
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
    double amount,
    String currency,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: _headers,
        body: {
          'amount': (amount * 100).toInt().toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body) as Map<dynamic, dynamic>,
        );
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      print('Error creating payment intent: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> retrievePaymentIntent(
    String paymentIntentId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        // Cast the decoded JSON to Map<String, dynamic>
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        throw Exception('Failed to retrieve payment intent: ${response.body}');
      }
    } catch (e) {
      print('Error retrieving payment intent: $e');
      rethrow;
    }
  }

  // Optional: Add method to confirm payment intent
  static Future<Map<String, dynamic>> confirmPaymentIntent(
    String paymentIntentId,
    String paymentMethodId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://api.stripe.com/v1/payment_intents/$paymentIntentId/confirm',
        ),
        headers: _headers,
        body: {'payment_method': paymentMethodId},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        throw Exception('Failed to confirm payment intent: ${response.body}');
      }
    } catch (e) {
      print('Error confirming payment intent: $e');
      rethrow;
    }
  }
}

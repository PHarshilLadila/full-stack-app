import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "https://full-stack-app-1-4iqk.onrender.com";

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");

    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    final uri = Uri.parse("$baseUrl$endpoint").replace(
      queryParameters: queryParams?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final headers = {"Content-Type": "application/json"};

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    log('GET Request: ${uri.toString()}');
    log('Headers: $headers');
    return await http.get(uri, headers: headers);
  }

  Future<http.Response> postWithParam(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final headers = {"Content-Type": "application/json"};

    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final headers = {"Content-Type": "application/json"};
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    return await http.put(url, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> logout(String endpoint, {String? token}) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final headers = {"Content-Type": "application/json"};

    if (token != null) {
      headers["Authorization"] = token;
    }

    return await http.post(url, headers: headers, body: jsonEncode({}));
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final headers = {"Content-Type": "application/json"};
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    log('DELETE Request: ${url.toString()}');
    log('Headers: $headers');
    log('Body: $body');

    return await http.delete(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> initiatePayment({
    required String orderId,
    required String paymentMethod,
    required String token,
  }) async {
    return await postWithParam('/payment/initiate', {
      'orderId': orderId,
      'paymentMethod': paymentMethod,
    }, token: token);
  }

  Future<http.Response> verifyPayment({
    required String orderId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    required String token,
  }) async {
    return await postWithParam('/payment/verify', {
      'orderId': orderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpayOrderId': razorpayOrderId,
      'razorpaySignature': razorpaySignature,
    }, token: token);
  }

  Future<http.Response> getPaymentStatus({
    required String orderId,
    required String token,
  }) async {
    return await get(
      '/payment/status',
      queryParams: {'orderId': orderId},
      token: token,
    );
  }
}

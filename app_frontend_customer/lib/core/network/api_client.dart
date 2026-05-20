import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "https://full-stack-app-4vxu.onrender.com";

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
}

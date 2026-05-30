import 'dart:convert';
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

    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

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

  Future<http.Response> uploadImage(
    String endpoint,
    String filePath, {
    required String token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');

      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('profileImage', filePath),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}

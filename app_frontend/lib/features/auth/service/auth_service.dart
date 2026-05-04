import 'dart:convert';

import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/auth/model/register_model.dart';

class AuthService {
  final ApiClient apiClient = ApiClient();

  Future<String> register(RegisterModel model) async {
    final response = await apiClient.post("/auth/register", model.toJson());

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    } else {
      throw Exception(data['error']);
    }
  }
}

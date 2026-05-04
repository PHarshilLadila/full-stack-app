// lib/features/user/service/user_service.dart

import 'dart:convert';
import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/home/model/user_model.dart';

class UserService {
  final ApiClient apiClient = ApiClient();

  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await apiClient.get(
        "/user/me",
        token: token,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
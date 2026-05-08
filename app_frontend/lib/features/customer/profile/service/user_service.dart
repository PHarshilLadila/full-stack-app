// lib/features/user/service/user_service.dart

import 'dart:convert';
import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/customer/profile/model/user_model.dart';

class UserService {
  final ApiClient apiClient = ApiClient();

  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await apiClient.get("/user/me", token: token);

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

  Future<Map<String, dynamic>> updateUserProfile({
    required String token,
    required String fullName,
    required String username,
    required String email,
    required String mobile,
    String? profileImage,
  }) async {
    try {
      final body = {
        "fullName": fullName,
        "username": username,
        "email": email,
        "mobile": mobile,
      };

      if (profileImage != null && profileImage.isNotEmpty) {
        body["profileImage"] = profileImage;
      }

      final response = await apiClient.put("/user/update", body, token: token);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to update user data');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

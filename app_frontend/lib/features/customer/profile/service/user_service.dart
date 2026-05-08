import 'dart:convert';
import 'dart:developer';
import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/customer/profile/model/user_model.dart';

class UserService {
  final ApiClient apiClient = ApiClient();

  // user_service.dart - Update getUserProfile method
  Future<UserModel> getUserProfile(String token) async {
    try {
      log("Fetching user profile with token: $token");
      final response = await apiClient.get("/user/me", token: token);

      log("User Profile Response Status: ${response.statusCode}");
      log("User Profile Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        UserModel user;

        // Your API returns: { success, message, data: {...}, role }
        if (data['data'] != null) {
          user = UserModel.fromJson(data['data']);
        } else if (data['user'] != null) {
          user = UserModel.fromJson(data['user']);
        } else {
          user = UserModel.fromJson(data);
        }

        log("User parsed successfully: ${user.fullName}, Role: ${user.role}");
        return user;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch user data');
      }
    } catch (e) {
      log("Get User Profile Error: $e");
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

      log("Updating user profile with data: $body");
      final response = await apiClient.put("/user/update", body, token: token);

      final data = jsonDecode(response.body);
      log("Update Profile Response: ${response.body}");

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to update user data');
      }
    } catch (e) {
      log("Update Profile Error: $e");
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Seller specific methods
  Future<Map<String, dynamic>> getSellerStats(String token) async {
    try {
      final response = await apiClient.get("/seller/stats", token: token);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch seller stats');
      }
    } catch (e) {
      log("Get Seller Stats Error: $e");
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getSellerProducts(String token) async {
    try {
      final response = await apiClient.get("/seller/products", token: token);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      log("Get Seller Products Error: $e");
      throw Exception('Network error: ${e.toString()}');
    }
  }
}

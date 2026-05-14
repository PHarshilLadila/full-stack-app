import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/customer/profile/model/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  final ApiClient apiClient = ApiClient();

  Future<UserModel> getUserProfile(String token) async {
    try {
      log("Fetching user profile with token: $token");
      final response = await apiClient.get("/user/me", token: token);

      log("User Profile Response Status: ${response.statusCode}");
      log("User Profile Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        UserModel user;

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
    File? imageFile,
  }) async {
    try {
      final uri = Uri.parse(
        "https://full-stack-app-4vxu.onrender.com/user/update",
      );

      final request = http.MultipartRequest('PUT', uri);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      request.fields['fullName'] = fullName;
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['mobile'] = mobile;

      // Add image file if selected
      if (imageFile != null) {
        final imageStream = http.MultipartFile.fromPath(
          'profileImage',
          imageFile.path,
        );
        request.files.add(await imageStream);
        log("Adding profile image: ${imageFile.path}");
      }

      log("Sending update request with fields: ${request.fields}");

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      log("Update Profile Response Status: ${response.statusCode}");
      log("Update Profile Response Body: $responseBody");

      final data = jsonDecode(responseBody);

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

  Future<Map<String, dynamic>> logout(String token) async {
    try {
      log("Calling logout API");
      final response = await apiClient.logout("/auth/logout", token: token);

      log("Logout Response Status: ${response.statusCode}");
      log("Logout Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Logged out successfully',
        };
      } else {
        throw Exception(data['message'] ?? 'Failed to logout');
      }
    } catch (e) {
      log("Logout Error: $e");
      throw Exception('Network error: ${e.toString()}');
    }
  }

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

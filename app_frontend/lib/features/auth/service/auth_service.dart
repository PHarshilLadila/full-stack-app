import 'dart:convert';
import 'dart:developer';

import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/auth/model/login_model.dart';
import 'package:app_frontend/features/auth/model/register_model.dart';

class AuthService {
  final ApiClient apiClient = ApiClient();

  Future<String> register(RegisterModel model) async {
    log("Register Request: ${jsonEncode(model.toJson())}");
    
    final response = await apiClient.post("/auth/register", model.toJson());
    
    log("Register Response Status: ${response.statusCode}");
    log("Register Response Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Registration Successful: ${data['message']}");
      return data['message'];
    } else {
      log("Registration Error: ${data['error'] ?? data['message']}");
      throw Exception(data['error'] ?? data['message'] ?? "Registration failed");
    }
  }

  Future<LoginResponseModel> login(LoginModel model) async {
    log("Login Request: ${jsonEncode(model.toJson())}");
    
    final response = await apiClient.post("/auth/login", model.toJson());
    
    log("Login Response Status: ${response.statusCode}");
    log("Login Response Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      log("Login Successful - Token: ${data['token']}");
      log("Login Successful - Role: ${data['role']}");
      log("Login Successful - UserId: ${data['userId']}");
      return LoginResponseModel.fromJson(data);
    } else {
      log("Login Error: ${data['error'] ?? data['message']}");
      throw Exception(data['error'] ?? data['message'] ?? "Login failed");
    }
  }
}
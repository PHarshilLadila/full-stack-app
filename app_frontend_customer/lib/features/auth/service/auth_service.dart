// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/auth/model/login_model.dart';
import 'package:app_frontend_customer/features/auth/model/register_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class AuthService {
  final ApiClient apiClient = ApiClient();

  Future<String> register(RegisterModel model) async {
    log("Register Request with profile image: ${model.profileImage != null}");

    final uri = Uri.parse(
      "https://full-stack-app-4vxu.onrender.com/auth/register",
    );
    final request = http.MultipartRequest('POST', uri);

    // Add text fields
    request.fields['fullName'] = model.fullName;
    request.fields['username'] = model.username;
    request.fields['email'] = model.email;
    request.fields['mobile'] = model.mobile;
    request.fields['password'] = model.password;
    request.fields['confirmPassword'] = model.confirmPassword;
    request.fields['role'] = model.role;

    // Add profile image if selected
    if (model.profileImage != null) {
      final File imageFile = model.profileImage!;
      final stream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();

      final multipartFile = http.MultipartFile(
        'profileImage',
        stream,
        length,
        filename: path.basename(imageFile.path),
      );

      request.files.add(multipartFile);
      log("Profile image added: ${path.basename(imageFile.path)}");
    }

    // Send request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    log("Register Response Status: ${response.statusCode}");
    log("Register Response Body: $responseBody");

    final data = jsonDecode(responseBody);

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Registration Successful: ${data['message']}");
      return data['message'];
    } else {
      log("Registration Error: ${data['error'] ?? data['message']}");
      throw Exception(
        data['error'] ?? data['message'] ?? "Registration failed",
      );
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

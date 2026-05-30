// lib/services/image_upload_service.dart
import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:app_frontend/core/network/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageUploadService {
  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        log("❌ No auth token found");
        throw Exception('No auth token found');
      }

      log(
        "📸 Uploading profile image to: ${ApiClient.baseUrl}/user/upload-profile-image",
      );
      log("📸 File path: ${imageFile.path}");
      log("📸 File size: ${await imageFile.length()} bytes");

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/user/upload-profile-image'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add file
      final multipartFile = await http.MultipartFile.fromPath(
        'profileImage',
        imageFile.path,
      );
      request.files.add(multipartFile);

      log("📸 Sending request...");

      // Send request
      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      final data = jsonDecode(responseBody);

      log("📸 Response status: ${streamedResponse.statusCode}");
      log("📸 Response body: $responseBody");

      if (streamedResponse.statusCode == 200 && data['success'] == true) {
        log("✅ Image uploaded successfully: ${data['imageUrl']}");
        return data['imageUrl'];
      } else {
        log("❌ Upload failed: ${data['error']}");
        return null;
      }
    } catch (e) {
      log("❌ Image upload error: $e");
      return null;
    }
  }
}

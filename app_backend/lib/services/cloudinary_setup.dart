// services/cloudinary_setup.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class CloudinarySetup {
  // Your Cloudinary credentials
  static const String cloudName = 'dyorzq6ir';
  static const String apiKey = '522897178834612';
  static const String apiSecret = '3tUnx4lp-KW8-AFhLtjk2hHTxuw';

  // Upload preset (we'll create this)
  static const String uploadPreset = 'ecommerce_preset'; // We'll create this

  // Test if Cloudinary is accessible
  static Future<bool> testConnection() async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );
      print('Testing Cloudinary connection to: $url');
      return true;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Direct upload method that works
  static Future<String?> uploadImageDirect({
    required Uint8List bytes,
    required String fileName,
    String folder = "ecommerce/products",
  }) async {
    try {
      print('🚀 Starting direct Cloudinary upload...');
      print('📁 Cloud Name: $cloudName');
      print('📂 Folder: $folder');
      print('🖼️ File: $fileName');
      print(
        '📊 Size: ${bytes.length} bytes (${(bytes.length / 1024 / 1024).toStringAsFixed(2)} MB)',
      );

      // Create upload URL
      final uploadUrl = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      // Create multipart request
      final request = http.MultipartRequest('POST', uploadUrl);

      // Add required fields
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;
      request.fields['api_key'] = apiKey;

      // Add the image file
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      );
      request.files.add(multipartFile);

      print('📤 Sending upload request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('✅ Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final secureUrl = data['secure_url'] as String;
        final publicId = data['public_id'];
        print('🎉 Upload successful!');
        print('🔗 URL: $secureUrl');
        print('🆔 Public ID: $publicId');
        return secureUrl;
      } else {
        print('❌ Upload failed with status: ${response.statusCode}');
        print('📝 Response: ${response.body}');

        // Provide helpful error messages
        if (response.body.contains('upload preset')) {
          print('\n⚠️ Upload preset not found!');
          print('Please create an upload preset named: $uploadPreset');
          print('Follow these steps:');
          print('1. Go to https://console.cloudinary.com');
          print('2. Click Settings (gear icon)');
          print('3. Go to Upload tab');
          print('4. Scroll to "Upload presets"');
          print('5. Click "Add Upload Preset"');
          print('6. Name it: $uploadPreset');
          print('7. Set Signing Mode to: Unsigned');
          print('8. Click Save\n');
        }

        return null;
      }
    } catch (e, stackTrace) {
      print('❌ Upload error: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}

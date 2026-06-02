// // ignore_for_file: public_member_api_docs, avoid_print, lines_longer_than_80_chars, avoid_dynamic_calls, prefer_single_quotes

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;

// class CloudinarySetup {
//   static const String cloudName = 'dyorzq6ir';
//   static const String apiKey = '522897178834612';
//   static const String apiSecret = '3tUnx4lp-KW8-AFhLtjk2hHTxuw';

//   static const String uploadPreset = 'ecommerce_preset';

//   static Future<bool> testConnection() async {
//     try {
//       final url = Uri.parse(
//         'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
//       );
//       print('Testing Cloudinary connection to: $url');
//       return true;
//     } catch (e) {
//       print('Connection test failed: $e');
//       return false;
//     }
//   }

//   // Direct upload method that works
//   static Future<String?> uploadImageDirect({
//     required Uint8List bytes,
//     required String fileName,
//     String folder = "ecommerce/products",
//   }) async {
//     try {
//       print('🚀 Starting direct Cloudinary upload...');
//       print('📁 Cloud Name: $cloudName');
//       print('📂 Folder: $folder');
//       print('🖼️ File: $fileName');
//       print(
//         '📊 Size: ${bytes.length} bytes (${(bytes.length / 1024 / 1024).toStringAsFixed(2)} MB)',
//       );

//       final uploadUrl = Uri.parse(
//         'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
//       );

//       final request = http.MultipartRequest('POST', uploadUrl);

//       request.fields['upload_preset'] = uploadPreset;
//       request.fields['folder'] = folder;
//       request.fields['api_key'] = apiKey;

//       final multipartFile = http.MultipartFile.fromBytes(
//         'file',
//         bytes,
//         filename: fileName,
//       );
//       request.files.add(multipartFile);

//       print('📤 Sending upload request...');
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       print('✅ Response status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final secureUrl = data['secure_url'] as String;
//         final publicId = data['public_id'];
//         print('🎉 Upload successful!');
//         print('🔗 URL: $secureUrl');
//         print('🆔 Public ID: $publicId');
//         return secureUrl;
//       } else {
//         print('❌ Upload failed with status: ${response.statusCode}');
//         print('📝 Response: ${response.body}');
//         if (response.body.contains('upload preset')) {
//           print('\n⚠️ Upload preset not found!');
//           print('Please create an upload preset named: $uploadPreset');
//           print('Follow these steps:');
//           print('1. Go to https://console.cloudinary.com');
//           print('2. Click Settings (gear icon)');
//           print('3. Go to Upload tab');
//           print('4. Scroll to "Upload presets"');
//           print('5. Click "Add Upload Preset"');
//           print('6. Name it: $uploadPreset');
//           print('7. Set Signing Mode to: Unsigned');
//           print('8. Click Save\n');
//         }
//         return null;
//       }
//     } catch (e, stackTrace) {
//       print('❌ Upload error: $e');
//       print('Stack trace: $stackTrace');
//       return null;
//     }
//   }
// }

// lib/services/cloudinary_service.dart
// ignore_for_file: avoid_print, public_member_api_docs

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CloudinarySetup {
  static const String cloudName = 'dyorzq6ir';
  static const String apiKey = '522897178834612';
  static const String apiSecret = '3tUnx4lp-KW8-AFhLtjk2hHTxuw';
  static const String uploadPreset = 'ecommerce_preset';

  /// Upload file from File object (for multipart file uploads)
  static Future<String?> uploadFile({
    required File file,
    required String fileName,
    String folder = "ecommerce/reviews",
  }) async {
    try {
      print('🚀 Starting Cloudinary file upload...');
      print('📁 Cloud Name: $cloudName');
      print('📂 Folder: $folder');
      print('🖼️ File: $fileName');
      
      final fileSize = await file.length();
      print('📊 Size: $fileSize bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)');

      final uploadUrl = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uploadUrl);

      // Get file bytes and determine MIME type
      final bytes = await file.readAsBytes();
      final mimeType = lookupMimeType(fileName) ?? 'image/jpeg';
      
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;
      request.fields['api_key'] = apiKey;

      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);

      print('📤 Sending upload request to Cloudinary...');
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

  /// Upload from bytes (alternative method)
  static Future<String?> uploadBytes({
    required Uint8List bytes,
    required String fileName,
    String folder = "ecommerce/reviews",
  }) async {
    try {
      print('🚀 Starting Cloudinary bytes upload...');

      final uploadUrl = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uploadUrl);
      final mimeType = lookupMimeType(fileName) ?? 'image/jpeg';

      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;
      request.fields['api_key'] = apiKey;

      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['secure_url'] as String;
      }
      return null;
    } catch (e) {
      print('❌ Bytes upload error: $e');
      return null;
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

      final uploadUrl = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uploadUrl);

      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;
      request.fields['api_key'] = apiKey;

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

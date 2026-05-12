// import 'dart:convert';

// import 'package:http/http.dart' as http;
// // cloudinary_service.dart
// import 'dart:typed_data';
// import 'package:cloudinary/cloudinary.dart';
// import '../config/env.dart';

// class CloudinaryService {
//   static Cloudinary? _cloudinary;

//   static Cloudinary get cloudinary {
//     if (_cloudinary == null) {
//       try {
//         final uri = Uri.parse(Env.cloudinaryUrl);
//         final apiKey = uri.userInfo.split(':')[0];
//         final apiSecret = uri.userInfo.split(':')[1];
//         final cloudName = uri.host;

//         print('🌩️ Initializing Cloudinary');
//         print('Cloud Name: $cloudName');
//         print('API Key: ${apiKey.substring(0, min(5, apiKey.length))}...');

//         _cloudinary = Cloudinary.signedConfig(
//           apiKey: apiKey,
//           apiSecret: apiSecret,
//           cloudName: cloudName,
//         );

//         print('✅ Cloudinary initialized successfully');
//       } catch (e) {
//         print('❌ Failed to initialize Cloudinary: $e');
//         rethrow;
//       }
//     }
//     return _cloudinary!;
//   }

//   static Future<String?> uploadImage({
//     required Uint8List bytes,
//     required String fileName,
//     String folder = "ecommerce/products",
//   }) async {
//     try {
//       print('📤 Uploading to Cloudinary: $fileName');
//       print('📊 Image size: ${bytes.length} bytes');
//       print('📁 Folder: $folder');

//       // The correct way to upload with cloudinary package
//       final response = await cloudinary
//           .upload(
//             fileBytes: bytes,
//             fileName: fileName,
//             resourceType: CloudinaryResourceType.image,
//             folder: folder,
//           )
//           .timeout(
//             const Duration(seconds: 30),
//             onTimeout: () {
//               print('❌ Cloudinary upload timeout');
//               throw Exception('Upload timeout');
//             },
//           );

//       print('Cloudinary response isSuccessful: ${response.isSuccessful}');

//       if (response.isSuccessful) {
//         final secureUrl = response.secureUrl;
//         print('✅ Upload successful: $secureUrl');
//         return secureUrl;
//       } else {
//         print('❌ Cloudinary upload failed: ${response.error}');
//         return null;
//       }
//     } catch (e, stackTrace) {
//       print('❌ Cloudinary exception: $e');
//       print('Stack trace: $stackTrace');
//       return null;
//     }
//   }
// }

// int min(int a, int b) => a < b ? a : b;

// class AlternativeCloudinaryService {
//   static String _getApiKey() {
//     final uri = Uri.parse(Env.cloudinaryUrl);
//     return uri.userInfo.split(':')[0];
//   }

//   static String _getCloudName() {
//     final uri = Uri.parse(Env.cloudinaryUrl);
//     return uri.host;
//   }

//   static Future<String?> uploadImage({
//     required Uint8List bytes,
//     required String fileName,
//     String folder = "ecommerce/products",
//   }) async {
//     try {
//       final cloudName = _getCloudName();

//       // Using unsigned upload with upload preset
//       final url = Uri.parse(
//         'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
//       );

//       // Create multipart request
//       final request = http.MultipartRequest('POST', url);

//       // Add fields - you need to create an upload preset in Cloudinary dashboard
//       request.fields['upload_preset'] =
//           'ml_default'; // Create this in Cloudinary
//       request.fields['folder'] = folder;

//       // Add file
//       final multipartFile = http.MultipartFile.fromBytes(
//         'file',
//         bytes,
//         filename: fileName,
//       );
//       request.files.add(multipartFile);

//       print('📤 Sending request to Cloudinary...');
//       final response = await request.send();

//       final responseBody = await response.stream.bytesToString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseBody');

//       final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;

//       if (response.statusCode == 200) {
//         final secureUrl = jsonResponse['secure_url'] as String?;
//         if (secureUrl != null) {
//           print('✅ Alternative upload successful: $secureUrl');
//           return secureUrl;
//         }
//       }

//       print('❌ Alternative upload failed: ${response.statusCode}');
//       if (jsonResponse.containsKey('error')) {
//         print('Error: ${jsonResponse['error']}');
//       }
//       return null;
//     } catch (e, stackTrace) {
//       print('❌ Alternative upload exception: $e');
//       print('Stack trace: $stackTrace');
//       return null;
//     }
//   }
// }

// class DirectCloudinaryService {
//   static Future<String?> uploadImage({
//     required Uint8List bytes,
//     required String fileName,
//     String folder = "ecommerce/products",
//   }) async {
//     try {
//       final uri = Uri.parse(Env.cloudinaryUrl);
//       final apiKey = uri.userInfo.split(':')[0];
//       final apiSecret = uri.userInfo.split(':')[1];
//       final cloudName = uri.host;

//       // Create timestamp for signature
//       final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//       // Create signature (for signed upload)
//       final signatureString =
//           'folder=$folder&timestamp=$timestamp&upload_preset=ml_default$apiSecret';

//       // For simplicity, let's use unsigned upload first
//       final uploadUrl = Uri.parse(
//         'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
//       );

//       var request = http.MultipartRequest('POST', uploadUrl);

//       request.fields['upload_preset'] = 'ml_default';
//       request.fields['folder'] = folder;
//       request.fields['api_key'] = apiKey;
//       request.fields['timestamp'] = timestamp.toString();

//       request.files.add(
//         http.MultipartFile.fromBytes('file', bytes, filename: fileName),
//       );

//       print('📤 Sending direct request to Cloudinary...');
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       print('Response status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final secureUrl = data['secure_url'] as String?;
//         print('✅ Direct upload successful: $secureUrl');
//         return secureUrl;
//       } else {
//         print('❌ Direct upload failed: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Direct upload error: $e');
//       return null;
//     }
//   }
// }

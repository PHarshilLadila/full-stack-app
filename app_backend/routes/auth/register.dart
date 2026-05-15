// // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:my_backend/db/mongo.dart';
// import 'package:my_backend/services/auth_service.dart';
// import 'package:my_backend/utils/validators.dart';

// Future<Response> onRequest(RequestContext context) async {
//   final body = jsonDecode(await context.request.body());

//   print('REGISTER BODY: $body');

//   final fullName = body['fullName'];
//   final username = body['username'];
//   final email = body['email'];
//   final mobile = body['mobile'];
//   final password = body['password'];
//   final confirmPassword = body['confirmPassword'];
//   final profileImage = body['profileImage']; // base64 or URL (optional)
//   final role = body['role']?.toString() ?? 'customer'; // 'customer' or 'seller'

//   if (MongoService.users == null) {
//     return Response.json(body: {'error': 'DB not connected'});
//   }

//   // Validate role
//   if (role != 'customer' && role != 'seller') {
//     return Response.json(body: {'error': 'Invalid role. Must be customer or seller'});
//   }

//   if (!isValidEmail(email.toString())) {
//     return Response.json(body: {'error': 'Invalid email'});
//   }

//   if (!isValidMobile(mobile.toString())) {
//     return Response.json(body: {'error': 'Invalid mobile'});
//   }

//   if (password != confirmPassword) {
//     return Response.json(body: {'error': 'Password mismatch'});
//   }

//   final existing = await MongoService.users!.findOne({
//     r'$or': [
//       {'email': email},
//       {'username': username},
//       {'mobile': mobile},
//     ],
//   });

//   if (existing != null) {
//     return Response.json(body: {'error': 'User already exists'});
//   }

//   final hashed = AuthService.hashPassword(password.toString());

//   await MongoService.users!.insert({
//     'fullName': fullName,
//     'username': username,
//     'email': email,
//     'mobile': mobile,
//     'passwordHash': hashed,
//     'profileImage': profileImage ?? '',
//     'role': role, // Add role field
//     'createdAt': DateTime.now(),
//   });

//   print('✅ User inserted with role: $role');

//   return Response.json(
//     body: {
//       'message': 'Registered successfully',
//       'role': role,
//     },
//   );
// }

// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars, omit_local_variable_types, deprecated_member_use
// routes/auth/register.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_frog/dart_frog.dart';

import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/auth_service.dart';
import 'package:my_backend/services/cloudinary_setup.dart';
import 'package:my_backend/utils/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    print('🔥 REGISTER API HIT');

    final contentType = context.request.headers['content-type'] ?? '';

    if (contentType.contains('multipart/form-data')) {
      return _handleMultipartRegister(context);
    }

    return _handleJsonRegister(context);
  } catch (e, stackTrace) {
    print('❌ REGISTER ERROR: $e');
    print('STACK TRACE: $stackTrace');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Internal server error'},
    );
  }
}

Future<Response> _handleMultipartRegister(RequestContext context) async {
  try {
    final formData = await context.request.formData();

    print('📋 FORM DATA RECEIVED');
    print('📋 Fields: ${formData.fields.keys}');
    print('📋 Files: ${formData.files.keys}');

    final fullName = formData['fullName']?.trim() ?? '';
    final username = formData['username']?.trim() ?? '';
    final email = formData['email']?.trim() ?? '';
    final mobile = formData['mobile']?.trim() ?? '';
    final password = formData['password']?.trim() ?? '';
    final confirmPassword = formData['confirmPassword']?.trim() ?? '';

    final role = formData['role']?.toString().trim() ?? 'customer';

    if (MongoService.users == null) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Database not connected'},
      );
    }

    if (fullName.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Full name is required'},
      );
    }

    if (username.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Username is required'},
      );
    }

    if (!isValidEmail(email)) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid email'},
      );
    }

    if (!isValidMobile(mobile)) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid mobile number'},
      );
    }

    if (password.length < 6) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'Password must be at least 6 characters',
        },
      );
    }

    if (password != confirmPassword) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Passwords do not match'},
      );
    }

    if (role != 'customer' && role != 'seller') {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid role'},
      );
    }

    final existingUser = await MongoService.users!.findOne({
      r'$or': [
        {'email': email},
        {'username': username},
        {'mobile': mobile},
      ],
    });

    if (existingUser != null) {
      return Response.json(
        statusCode: 409,
        body: {'success': false, 'message': 'User already exists'},
      );
    }

    String profileImage = '';

    final profileFile = formData.files['profileImage'];

    if (profileFile != null) {
      print('📸 Uploading profile image: ${profileFile.name}');

      profileImage = await _uploadToCloudinary(profileFile);

      if (profileImage.isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': 'Failed to upload profile image'},
        );
      }
    }
    final hashedPassword = AuthService.hashPassword(password);

    final userData = {
      'fullName': fullName,
      'username': username,
      'email': email,
      'mobile': mobile,
      'passwordHash': hashedPassword,
      'profileImage': profileImage,
      'role': role,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'isActive': true,
    };

    final result = await MongoService.users!.insertOne(userData);

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to create account'},
      );
    }

    print('✅ USER REGISTERED SUCCESSFULLY');
    print('👤 EMAIL: $email');
    print('🎭 ROLE: $role');
    print('🖼️ PROFILE IMAGE: $profileImage');

    return Response.json(
      statusCode: 201,
      body: {
        'success': true,
        'message': 'Registered successfully',
        'data': {
          'fullName': fullName,
          'username': username,
          'email': email,
          'mobile': mobile,
          'profileImage': profileImage,
          'role': role,
        },
      },
    );
  } catch (e, stackTrace) {
    print('❌ MULTIPART REGISTER ERROR: $e');
    print('STACK TRACE: $stackTrace');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error'},
    );
  }
}

Future<Response> _handleJsonRegister(RequestContext context) async {
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;

  final fullName = body['fullName']?.toString().trim() ?? '';

  final username = body['username']?.toString().trim() ?? '';

  final email = body['email']?.toString().trim() ?? '';

  final mobile = body['mobile']?.toString().trim() ?? '';

  final password = body['password']?.toString().trim() ?? '';

  final confirmPassword = body['confirmPassword']?.toString().trim() ?? '';

  final role = body['role']?.toString().trim() ?? 'customer';

  if (MongoService.users == null) {
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Database not connected'},
    );
  }

  if (!isValidEmail(email)) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'message': 'Invalid email'},
    );
  }

  if (!isValidMobile(mobile)) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'message': 'Invalid mobile number'},
    );
  }

  if (password != confirmPassword) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'message': 'Passwords do not match'},
    );
  }

  final existingUser = await MongoService.users!.findOne({
    r'$or': [
      {'email': email},
      {'username': username},
      {'mobile': mobile},
    ],
  });

  if (existingUser != null) {
    return Response.json(
      statusCode: 409,
      body: {'success': false, 'message': 'User already exists'},
    );
  }

  final hashedPassword = AuthService.hashPassword(password);

  await MongoService.users!.insertOne({
    'fullName': fullName,
    'username': username,
    'email': email,
    'mobile': mobile,
    'passwordHash': hashedPassword,
    'profileImage': '',
    'role': role,
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
    'isActive': true,
  });

  return Response.json(
    statusCode: 201,
    body: {'success': true, 'message': 'Registered successfully'},
  );
}

Future<String> _uploadToCloudinary(UploadedFile file) async {
  try {
    print('📸 Processing file: ${file.name}');

    final bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      print('❌ Empty image file');
      return '';
    }

    final imageBytes = Uint8List.fromList(bytes);

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final extension =
        file.name.contains('.') ? file.name.split('.').last : 'jpg';

    final fileName = '${timestamp}_profile.$extension';

    final imageUrl = await CloudinarySetup.uploadImageDirect(
      bytes: imageBytes,
      fileName: fileName,
      folder: 'ecommerce/users',
    );

    if (imageUrl == null || imageUrl.isEmpty) {
      print('❌ Cloudinary upload failed');
      return '';
    }

    print('✅ CLOUDINARY URL: $imageUrl');

    return imageUrl;
  } catch (e, stackTrace) {
    print('❌ CLOUDINARY ERROR: $e');
    print('STACK TRACE: $stackTrace');
    return '';
  }
}

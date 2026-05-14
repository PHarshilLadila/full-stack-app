// // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:my_backend/config/env.dart';
// import 'package:my_backend/db/mongo.dart';

// Future<Response> onRequest(RequestContext context) async {
//   print('🔥 /user/update API HIT');

//   final authHeader = context.request.headers['authorization'];

//   if (authHeader == null || !authHeader.startsWith('Bearer ')) {
//     return Response.json(
//       statusCode: 401,
//       body: {'error': 'Token missing', 'success': false},
//     );
//   }

//   final token = authHeader.split(' ')[1];

//   try {
//     final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
//     final userId = jwt.payload['id'] as String;
//     final currentRole = jwt.payload['role'] as String? ?? 'customer';

//     // Check if users collection exists
//     if (MongoService.users == null) {
//       return Response.json(
//         statusCode: 500,
//         body: {'error': 'Database not connected', 'success': false},
//       );
//     }

//     final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
//     print('📦 Update Body: $body');

//     final updateData = <String, dynamic>{};

//     // Validate and add update fields
//     if (body['fullName'] != null && body['fullName'].toString().isNotEmpty) {
//       updateData['fullName'] = body['fullName'].toString();
//     }

//     if (body['username'] != null && body['username'].toString().isNotEmpty) {
//       // Check if username is already taken by another user
//       final existingUser = await MongoService.users!.findOne({
//         'username': body['username'].toString(),
//         '_id': {r'$ne': ObjectId.parse(userId)},
//       });

//       if (existingUser != null) {
//         return Response.json(
//           body: {'error': 'Username already taken', 'success': false},
//         );
//       }
//       updateData['username'] = body['username'].toString();
//     }

//     if (body['email'] != null && body['email'].toString().isNotEmpty) {
//       // Check if email is already taken by another user
//       final existingUser = await MongoService.users!.findOne({
//         'email': body['email'].toString(),
//         '_id': {r'$ne': ObjectId.parse(userId)},
//       });

//       if (existingUser != null) {
//         return Response.json(
//           body: {'error': 'Email already taken', 'success': false},
//         );
//       }
//       updateData['email'] = body['email'].toString();
//     }

//     if (body['mobile'] != null && body['mobile'].toString().isNotEmpty) {
//       // Check if mobile is already taken by another user
//       final existingUser = await MongoService.users!.findOne({
//         'mobile': body['mobile'].toString(),
//         '_id': {r'$ne': ObjectId.parse(userId)},
//       });

//       if (existingUser != null) {
//         return Response.json(
//           body: {'error': 'Mobile number already taken', 'success': false},
//         );
//       }
//       updateData['mobile'] = body['mobile'].toString();
//     }

//     if (body['profileImage'] != null && body['profileImage'].toString().isNotEmpty) {
//       updateData['profileImage'] = body['profileImage'].toString();
//     }

//     // Role update - only allow if properly authorized
//     if (body['role'] != null) {
//       final newRole = body['role'].toString();
//       if (newRole == 'customer' || newRole == 'seller') {
//         // In production, you might want to restrict role changes
//         // or require admin approval
//         updateData['role'] = newRole;
//         print('⚠️ Role changing from $currentRole to $newRole');
//       } else {
//         return Response.json(
//           body: {'error': 'Invalid role. Must be customer or seller', 'success': false},
//         );
//       }
//     }

//     // Add updated timestamp
//     updateData['updatedAt'] = DateTime.now();

//     if (updateData.isEmpty) {
//       return Response.json(
//         body: {'error': 'No data to update', 'success': false},
//       );
//     }

//     // Update user
//     final result = await MongoService.users!.updateOne(
//       {'_id': ObjectId.parse(userId)},
//       {r'$set': updateData},
//     );

//     if (!result.isSuccess) {
//       return Response.json(
//         body: {'error': 'Update failed', 'success': false},
//       );
//     }

//     // Get updated user data
//     final updatedUser = await MongoService.users!.findOne({
//       '_id': ObjectId.parse(userId),
//     });

//     // Remove sensitive data
//     updatedUser?.remove('passwordHash');

//     // Convert ObjectId to string
//     if (updatedUser != null && updatedUser['_id'] is ObjectId) {
//       updatedUser['_id'] = (updatedUser['_id'] as ObjectId).oid;
//     }

//     // Convert DateTime to string
//     if (updatedUser != null && updatedUser['createdAt'] is DateTime) {
//       updatedUser['createdAt'] = (updatedUser['createdAt'] as DateTime).toIso8601String();
//     }
//     if (updatedUser != null && updatedUser['updatedAt'] is DateTime) {
//       updatedUser['updatedAt'] = (updatedUser['updatedAt'] as DateTime).toIso8601String();
//     }

//     print('✅ User updated successfully');

//     return Response.json(
//       body: {
//         'success': true,
//         'message': 'User updated successfully',
//         'updatedFields': updateData,
//         'data': updatedUser,
//       },
//     );
//   } catch (e) {
//     print('❌ ERROR: $e');
//     return Response.json(
//       statusCode: 500,
//       body: {'error': 'Failed to update user: $e', 'success': false},
//     );
//   }
// }

// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/cloudinary_setup.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /user/update API HIT');

  final authHeader = context.request.headers['authorization'];

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'success': false, 'error': 'Token missing'},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));

    final userId = jwt.payload['id'].toString();

    final currentRole = jwt.payload['role']?.toString() ?? 'customer';

    if (MongoService.users == null) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'error': 'Database not connected'},
      );
    }

    final contentType = context.request.headers['content-type'] ?? '';

    // ==========================================
    // MULTIPART REQUEST
    // ==========================================

    if (contentType.contains('multipart/form-data')) {
      return _handleMultipartUpdate(context, userId, currentRole);
    }

    // ==========================================
    // JSON REQUEST
    // ==========================================

    return _handleJsonUpdate(context, userId, currentRole);
  } catch (e, stackTrace) {
    print('❌ UPDATE ERROR: $e');
    print('STACK TRACE: $stackTrace');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'error': 'Failed to update user: $e'},
    );
  }
}

// =======================================================
// MULTIPART UPDATE
// =======================================================

Future<Response> _handleMultipartUpdate(
  RequestContext context,
  String userId,
  String currentRole,
) async {
  try {
    final formData = await context.request.formData();

    print('📋 FORM DATA RECEIVED');
    print('📋 Fields: ${formData.fields.keys}');
    print('📋 Files: ${formData.files.keys}');

    final updateData = <String, dynamic>{};

    // ==========================================
    // FULL NAME
    // ==========================================

    final fullName = formData['fullName']?.trim();

    if (fullName != null && fullName.isNotEmpty) {
      updateData['fullName'] = fullName;
    }

    // ==========================================
    // USERNAME
    // ==========================================

    final username = formData['username']?.trim();

    if (username != null && username.isNotEmpty) {
      final existingUser = await MongoService.users!.findOne({
        'username': username,
        '_id': {r'$ne': ObjectId.parse(userId)},
      });

      if (existingUser != null) {
        return Response.json(
          statusCode: 409,
          body: {'success': false, 'error': 'Username already taken'},
        );
      }

      updateData['username'] = username;
    }

    // ==========================================
    // EMAIL
    // ==========================================

    final email = formData['email']?.trim();

    if (email != null && email.isNotEmpty) {
      final existingUser = await MongoService.users!.findOne({
        'email': email,
        '_id': {r'$ne': ObjectId.parse(userId)},
      });

      if (existingUser != null) {
        return Response.json(
          statusCode: 409,
          body: {'success': false, 'error': 'Email already taken'},
        );
      }

      updateData['email'] = email;
    }

    // ==========================================
    // MOBILE
    // ==========================================

    final mobile = formData['mobile']?.trim();

    if (mobile != null && mobile.isNotEmpty) {
      final existingUser = await MongoService.users!.findOne({
        'mobile': mobile,
        '_id': {r'$ne': ObjectId.parse(userId)},
      });

      if (existingUser != null) {
        return Response.json(
          statusCode: 409,
          body: {'success': false, 'error': 'Mobile number already taken'},
        );
      }

      updateData['mobile'] = mobile;
    }

    // ==========================================
    // ROLE
    // ==========================================

    final role = formData['role']?.trim();

    if (role != null) {
      if (role == 'customer' || role == 'seller') {
        updateData['role'] = role;

        print('⚠️ ROLE CHANGED FROM $currentRole TO $role');
      } else {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'error': 'Invalid role'},
        );
      }
    }

    // ==========================================
    // PROFILE IMAGE
    // ==========================================

    final profileImageFile = formData.files['profileImage'];

    if (profileImageFile != null) {
      print('📸 Uploading profile image: ${profileImageFile.name}');

      final imageUrl = await _uploadToCloudinary(profileImageFile);

      if (imageUrl.isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'error': 'Failed to upload profile image'},
        );
      }

      updateData['profileImage'] = imageUrl;
    }

    // ==========================================
    // EMPTY CHECK
    // ==========================================

    if (updateData.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'error': 'No data to update'},
      );
    }

    // ==========================================
    // UPDATED AT
    // ==========================================

    updateData['updatedAt'] = DateTime.now();

    // ==========================================
    // UPDATE USER
    // ==========================================

    final result = await MongoService.users!.updateOne(
      {'_id': ObjectId.parse(userId)},
      {r'$set': updateData},
    );

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'error': 'Update failed'},
      );
    }

    // ==========================================
    // GET UPDATED USER
    // ==========================================

    final updatedUser = await MongoService.users!.findOne({
      '_id': ObjectId.parse(userId),
    });

    if (updatedUser != null) {
      updatedUser.remove('passwordHash');

      if (updatedUser['_id'] is ObjectId) {
        updatedUser['_id'] = (updatedUser['_id'] as ObjectId).oid;
      }

      if (updatedUser['createdAt'] is DateTime) {
        updatedUser['createdAt'] =
            (updatedUser['createdAt'] as DateTime).toIso8601String();
      }

      if (updatedUser['updatedAt'] is DateTime) {
        updatedUser['updatedAt'] =
            (updatedUser['updatedAt'] as DateTime).toIso8601String();
      }
    }

    print('✅ USER UPDATED SUCCESSFULLY');

    final responseUpdateData = Map<String, dynamic>.from(updateData);

    if (responseUpdateData['updatedAt'] is DateTime) {
      responseUpdateData['updatedAt'] =
          (responseUpdateData['updatedAt'] as DateTime).toIso8601String();
    }

    return Response.json(
      body: {
        'success': true,
        'message': 'User updated successfully',
        'updatedFields': responseUpdateData,
        'data': updatedUser,
      },
    );
  } catch (e, stackTrace) {
    print('❌ MULTIPART UPDATE ERROR: $e');
    print('STACK TRACE: $stackTrace');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'error': 'Server error'},
    );
  }
}

// =======================================================
// JSON UPDATE
// =======================================================

Future<Response> _handleJsonUpdate(
  RequestContext context,
  String userId,
  String currentRole,
) async {
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;

  final updateData = <String, dynamic>{};

  if (body['fullName'] != null) {
    updateData['fullName'] = body['fullName'].toString();
  }

  if (body['username'] != null) {
    final existingUser = await MongoService.users!.findOne({
      'username': body['username'].toString(),
      '_id': {r'$ne': ObjectId.parse(userId)},
    });

    if (existingUser != null) {
      return Response.json(
        statusCode: 409,
        body: {'success': false, 'error': 'Username already taken'},
      );
    }

    updateData['username'] = body['username'].toString();
  }

  if (body['email'] != null) {
    final existingUser = await MongoService.users!.findOne({
      'email': body['email'].toString(),
      '_id': {r'$ne': ObjectId.parse(userId)},
    });

    if (existingUser != null) {
      return Response.json(
        statusCode: 409,
        body: {'success': false, 'error': 'Email already taken'},
      );
    }

    updateData['email'] = body['email'].toString();
  }

  if (body['mobile'] != null) {
    final existingUser = await MongoService.users!.findOne({
      'mobile': body['mobile'].toString(),
      '_id': {r'$ne': ObjectId.parse(userId)},
    });

    if (existingUser != null) {
      return Response.json(
        statusCode: 409,
        body: {'success': false, 'error': 'Mobile number already taken'},
      );
    }

    updateData['mobile'] = body['mobile'].toString();
  }

  if (body['profileImage'] != null) {
    updateData['profileImage'] = body['profileImage'].toString();
  }

  if (body['role'] != null) {
    final newRole = body['role'].toString();

    if (newRole == 'customer' || newRole == 'seller') {
      updateData['role'] = newRole;

      print('⚠️ ROLE CHANGED FROM $currentRole TO $newRole');
    } else {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'error': 'Invalid role'},
      );
    }
  }

  if (updateData.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'error': 'No data to update'},
    );
  }

  updateData['updatedAt'] = DateTime.now();

  final result = await MongoService.users!.updateOne(
    {'_id': ObjectId.parse(userId)},
    {r'$set': updateData},
  );

  if (!result.isSuccess) {
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'error': 'Update failed'},
    );
  }

  final updatedUser = await MongoService.users!.findOne({
    '_id': ObjectId.parse(userId),
  });

  updatedUser?.remove('passwordHash');

  if (updatedUser != null && updatedUser['_id'] is ObjectId) {
    updatedUser['_id'] = (updatedUser['_id'] as ObjectId).oid;
  }

  return Response.json(
    body: {
      'success': true,
      'message': 'User updated successfully',
      'data': updatedUser,
    },
  );
}

// =======================================================
// CLOUDINARY IMAGE UPLOAD
// =======================================================

Future<String> _uploadToCloudinary(UploadedFile file) async {
  try {
    print('📸 Processing image: ${file.name}');

    final bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      print('❌ Empty image');
      return '';
    }

    final imageBytes = Uint8List.fromList(bytes);

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final extension =
        file.name.contains('.') ? file.name.split('.').last : 'jpg';

    final fileName = '${timestamp}_user.$extension';

    final imageUrl = await CloudinarySetup.uploadImageDirect(
      bytes: imageBytes,
      fileName: fileName,
      folder: 'ecommerce/users',
    );

    if (imageUrl == null || imageUrl.isEmpty) {
      print('❌ Upload failed');
      return '';
    }

    print('✅ IMAGE UPLOADED: $imageUrl');

    return imageUrl;
  } catch (e, stackTrace) {
    print('❌ IMAGE UPLOAD ERROR: $e');
    print('STACK TRACE: $stackTrace');

    return '';
  }
}

// app_backend/lib/routes/fcm/token.dart
// ignore_for_file: avoid_dynamic_calls, avoid_print, omit_local_variable_types, avoid_redundant_argument_values, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// POST /fcm/token - Save or update FCM token
/// DELETE /fcm/token - Remove FCM token
Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;

  if (method == HttpMethod.post) {
    return _saveToken(context);
  } else if (method == HttpMethod.delete) {
    return _removeToken(context);
  }

  return Response.json(
    statusCode: 405,
    body: {'success': false, 'message': 'Method not allowed'},
  );
}

/// Extract user ID from JWT token
String? _getUserIdFromToken(RequestContext context) {
  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return null;
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    return jwt.payload['id']?.toString();
  } catch (e) {
    print('Invalid token: $e');
    return null;
  }
}

/// Save FCM token
Future<Response> _saveToken(RequestContext context) async {
  try {
    // Get user ID from JWT token directly
    final userId = _getUserIdFromToken(context);

    if (userId == null) {
      return Response.json(
        statusCode: 401,
        body: {'success': false, 'message': 'User not authenticated'},
      );
    }

    // Parse request body
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final fcmToken = body['fcmToken']?.toString();
    final deviceType = body['deviceType']?.toString() ?? 'android';
    final appType = body['appType']?.toString();

    // Validate required fields
    if (fcmToken == null || fcmToken.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'fcmToken is required'},
      );
    }

    if (appType == null || appType.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'appType is required'},
      );
    }

    // Get user from database
    final userObjectId = ObjectId.parse(userId);
    final Map<String, dynamic>? user = await MongoService.users!.findOne({
      '_id': userObjectId,
    });

    if (user == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'User not found'},
      );
    }

    // Get existing tokens or create new list
    List<dynamic> existingTokens = [];
    if (user['fcmTokens'] != null) {
      existingTokens = List<dynamic>.from(user['fcmTokens'] as List);
    }

    // Check if token already exists
    bool tokenExists = false;
    for (int i = 0; i < existingTokens.length; i++) {
      final tokenObj = existingTokens[i] as Map<String, dynamic>;
      if (tokenObj['token'] == fcmToken) {
        tokenObj['deviceType'] = deviceType;
        tokenObj['appType'] = appType;
        tokenObj['lastUsed'] = DateTime.now().toIso8601String();
        tokenObj['isActive'] = true;
        existingTokens[i] = tokenObj;
        tokenExists = true;
        break;
      }
    }

    // Add new token if not exists
    if (!tokenExists) {
      existingTokens.add({
        'token': fcmToken,
        'deviceType': deviceType,
        'appType': appType,
        'createdAt': DateTime.now().toIso8601String(),
        'lastUsed': DateTime.now().toIso8601String(),
        'isActive': true,
      });
    }

    // Update user document
    await MongoService.users!.updateOne(
      {'_id': userObjectId},
      {
        r'$set': {'fcmTokens': existingTokens},
      },
    );

    return Response.json(
      statusCode: 200,
      body: {'success': true, 'message': 'FCM token saved successfully'},
    );
  } catch (e) {
    print('Error saving FCM token: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

/// Remove FCM token
Future<Response> _removeToken(RequestContext context) async {
  try {
    final userId = _getUserIdFromToken(context);
    if (userId == null) {
      return Response.json(
        statusCode: 401,
        body: {'success': false, 'message': 'User not authenticated'},
      );
    }

    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final fcmToken = body['fcmToken']?.toString();

    if (fcmToken == null || fcmToken.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'fcmToken is required'},
      );
    }

    final userObjectId = ObjectId.parse(userId);
    final Map<String, dynamic>? user = await MongoService.users!.findOne({
      '_id': userObjectId,
    });

    if (user == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'User not found'},
      );
    }

    List<dynamic> existingTokens = [];
    if (user['fcmTokens'] != null) {
      existingTokens = List<dynamic>.from(user['fcmTokens'] as List);
    }

    existingTokens.removeWhere((token) {
      final tokenObj = token as Map<String, dynamic>;
      return tokenObj['token'] == fcmToken;
    });

    await MongoService.users!.updateOne(
      {'_id': userObjectId},
      {
        r'$set': {'fcmTokens': existingTokens},
      },
    );

    return Response.json(
      statusCode: 200,
      body: {'success': true, 'message': 'FCM token removed successfully'},
    );
  } catch (e) {
    print('Error removing FCM token: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

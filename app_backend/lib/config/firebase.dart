// app_backend/lib/config/firebase.dart
// ignore_for_file: public_member_api_docs, avoid_slow_async_io, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FirebaseConfig {
  static String? _accessToken;
  static DateTime? _tokenExpiry;
  static String? _projectId;

  /// Initialize Firebase (load credentials)
  static Future<void> init() async {
    try {
      // Get project ID from environment or file
      _projectId = Platform.environment['FIREBASE_PROJECT_ID'];

      if (_projectId == null || _projectId!.isEmpty) {
        final file = File('firebase-adminsdk.json');
        if (await file.exists()) {
          final jsonString = await file.readAsString();
          final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
          _projectId = jsonData['project_id'] as String?;
        }
      }

      if (_projectId != null && _projectId!.isNotEmpty) {
        print('✅ Firebase configured with project ID: $_projectId');
      } else {
        print('⚠️ Firebase project ID not found');
      }
    } catch (e) {
      print('❌ Failed to initialize Firebase: $e');
    }
  }

  /// Get OAuth2 access token for FCM REST API
  static Future<String> getAccessToken() async {
    // Return cached token if still valid
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    try {
      // Try environment variables first
      final clientEmail = Platform.environment['FIREBASE_CLIENT_EMAIL'];
      final privateKey = Platform.environment['FIREBASE_PRIVATE_KEY'];

      if (clientEmail != null &&
          clientEmail.isNotEmpty &&
          privateKey != null &&
          privateKey.isNotEmpty) {
        final cleanedPrivateKey = privateKey.replaceAll(r'\n', '\n');

        final credentials = ServiceAccountCredentials.fromJson({
          'client_email': clientEmail,
          'private_key': cleanedPrivateKey,
        });

        final client = await clientViaServiceAccount(credentials, [
          'https://www.googleapis.com/auth/firebase.messaging',
        ]);

        _accessToken = client.credentials.accessToken.data;
        _tokenExpiry = DateTime.now().add(const Duration(seconds: 3500));
        print('✅ Access token obtained from environment');
        return _accessToken!;
      }

      // Fallback to file
      final file = File('firebase-adminsdk.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

        final clientEmailFromFile = jsonData['client_email'] as String;
        final privateKeyFromFile = jsonData['private_key'] as String;

        final credentials = ServiceAccountCredentials.fromJson({
          'client_email': clientEmailFromFile,
          'private_key': privateKeyFromFile,
        });

        final client = await clientViaServiceAccount(credentials, [
          'https://www.googleapis.com/auth/firebase.messaging',
        ]);

        _accessToken = client.credentials.accessToken.data;
        _tokenExpiry = DateTime.now().add(const Duration(seconds: 3500));
        print('✅ Access token obtained from file');
        return _accessToken!;
      }

      throw Exception('No Firebase credentials found');
    } catch (e) {
      print('❌ Failed to get access token: $e');
      rethrow;
    }
  }

  /// Get project ID
  static String? get projectId => _projectId;

  /// Send FCM notification using HTTP REST API
  static Future<bool> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      if (_projectId == null || _projectId!.isEmpty) {
        print('⚠️ Project ID not configured');
        return false;
      }

      final accessToken = await getAccessToken();

      final url =
          'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

      final payload = <String, dynamic>{
        'message': {
          'token': fcmToken,
          'notification': {'title': title, 'body': body},
          'android': {
            'priority': 'high',
            'notification': {
              'channelId': 'ecommerce_orders',
              'sound': 'default',
            },
          },
          'apns': {
            'payload': {
              'aps': {'sound': 'default', 'badge': 1},
            },
          },
          if (data != null) 'data': data,
        },
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('✅ Notification sent successfully');
        return true;
      } else {
        print('❌ Failed to send notification: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending notification: $e');
      return false;
    }
  }
}

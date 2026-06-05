// lib/service/fcm_notification_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FCMNotificationService {
  static bool get _isWeb => kIsWeb;
  static bool _initialized = false;

  /// Initialize FCM - SKIP ON WEB
  static Future<void> initialize() async {
    if (_isWeb) {
      log('🌐 Web platform - FCM notifications disabled');
      return;
    }

    if (_initialized) return;

    try {
      await _initializeMobile();
      _initialized = true;
    } catch (e) {
      log('⚠️ FCM initialization failed: $e');
    }
  }

  static Future<void> _initializeMobile() async {
    log('📱 Initializing FCM for mobile...');

    try {
      // Initialize local notifications
      final FlutterLocalNotificationsPlugin localNotifications =
          FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await localNotifications.initialize(settings);

      // Initialize Firebase Messaging
      final fcm = FirebaseMessaging.instance;
      final NotificationSettings notificationSettings = await fcm
          .requestPermission(alert: true, badge: true, sound: true);

      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        log('✅ User granted notification permission');

        final String? token = await fcm.getToken();
        if (token != null && token.isNotEmpty) {
          log('📱 FCM Token obtained');
        } else {
          log('⚠️ FCM token is empty');
        }
      } else {
        log('⚠️ User denied notification permission');
      }
    } catch (e) {
      log('⚠️ FCM initialization error: $e');
      rethrow;
    }
  }

  /// Save FCM token to backend - SKIP ON WEB
  static Future<void> saveTokenToBackend(String authToken) async {
    if (_isWeb) {
      log('🌐 Web platform - skipping token save');
      return;
    }

    if (!_initialized) {
      log('⚠️ FCM not initialized, attempting to initialize...');
      await initialize();
    }

    try {
      final fcm = FirebaseMessaging.instance;
      final String? fcmToken = await fcm.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        log('❌ No FCM token available');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('fcm_token_saved');

      if (savedToken == fcmToken) {
        log('✅ FCM token already saved');
        return;
      }

      log('📤 Saving FCM token to backend...');

      final response = await http.post(
        Uri.parse('https://full-stack-app-1-4iqk.onrender.com/fcm/token'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
          'deviceType': 'mobile',
          'appType': 'customer',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await prefs.setString('fcm_token_saved', fcmToken);
        log('✅ FCM token saved to backend');
      } else {
        log(
          '❌ Failed to save token: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      log('❌ Error saving token: $e');
    }
  }

  /// Remove FCM token - SKIP ON WEB
  static Future<void> removeTokenFromBackend(String authToken) async {
    if (_isWeb) return;

    try {
      final fcm = FirebaseMessaging.instance;
      final String? fcmToken = await fcm.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      final response = await http.delete(
        Uri.parse('https://full-stack-app-1-4iqk.onrender.com/fcm/token'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('fcm_token_saved');
        log('✅ Token removed from backend');
      }
    } catch (e) {
      log('❌ Error removing token: $e');
    }
  }

  /// Show local notification - SKIP ON WEB
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (_isWeb) {
      log('📢 [WEB] Notification: $title - $body');
      return;
    }

    try {
      final FlutterLocalNotificationsPlugin localNotifications =
          FlutterLocalNotificationsPlugin();

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'customer_orders_channel',
            'Customer Order Notifications',
            channelDescription: 'Notifications for order updates',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await localNotifications.show(
        DateTime.now().millisecondsSinceEpoch,
        title,
        body,
        details,
        payload: payload,
      );

      log('✅ Local notification shown: $title');
    } catch (e) {
      log('❌ Error showing notification: $e');
    }
  }
}

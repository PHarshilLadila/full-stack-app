// lib/services/fcm_notification_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FCMNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _fcmSupported = true;

  /// Initialize FCM and Local Notifications
  static Future<void> initialize() async {
    // Initialize local notifications (always works)
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

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Check if Google Play Services is available
    try {
      await _checkGooglePlayServices();
    } catch (e) {
      log('⚠️ Google Play Services not available: $e');
      _fcmSupported = false;
      return;
    }

    // Try to initialize FCM
    try {
      NotificationSettings notificationSettings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        log('✅ User granted notification permission');

        final String? token = await _fcm.getToken();
        if (token != null) {
          log('📱 FCM Token: $token');
        } else {
          log('⚠️ FCM token is null');
          _fcmSupported = false;
        }

        if (_fcmSupported) {
          FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
          FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler,
          );
          FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
        }
      } else {
        log('⚠️ User denied notification permission');
        _fcmSupported = false;
      }
    } catch (e) {
      log('⚠️ FCM initialization failed: $e');
      _fcmSupported = false;
    }
  }

  /// Check if Google Play Services is available
  static Future<void> _checkGooglePlayServices() async {
    try {
      final String? token = await _fcm.getToken();
      if (token == null) {
        throw Exception('FCM token is null');
      }
    } catch (e) {
      if (e.toString().contains('MISSING_INSTANCEID_SERVICE')) {
        throw Exception('Google Play Services missing');
      }
      rethrow;
    }
  }

  /// Save FCM token to backend
  // Update the saveTokenToBackend method
  static Future<void> saveTokenToBackend(String authToken) async {
    if (!_fcmSupported) {
      log('⚠️ FCM not supported, skipping token save');
      return;
    }

    try {
      final String? fcmToken = await _fcm.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        log('❌ No FCM token available');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('fcm_token_saved');

      if (savedToken == fcmToken) {
        log('✅ Customer FCM token already saved');
        return;
      }

      log('📤 Saving customer token...');

      final response = await http.post(
        Uri.parse('https://full-stack-app-1-4iqk.onrender.com/fcm/token'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
          'deviceType': 'android',
          'appType': 'customer_mobile',
        }),
      );

      log('📤 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        await prefs.setString('fcm_token_saved', fcmToken);
        log('✅ Customer FCM token saved to backend');
      } else {
        log('❌ Failed to save customer token: ${response.body}');
      }
    } catch (e) {
      log('❌ Error saving customer token: $e');
    }
  }

  /// Remove FCM token
  static Future<void> removeTokenFromBackend(String authToken) async {
    if (!_fcmSupported) return;

    try {
      final String? fcmToken = await _fcm.getToken();
      if (fcmToken == null) return;

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
        log('✅ Token removed');
      }
    } catch (e) {
      log('❌ Error removing token: $e');
    }
  }

  /// Show local notification (always works)
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'customer_orders_channel',
          'Customer Order Notifications',
          channelDescription: 'Notifications for order updates',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    log('📨 Message: ${message.notification?.title}');
    showLocalNotification(
      title: message.notification?.title ?? 'New Update',
      body: message.notification?.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    _handleNavigation(message.data);
  }

  static void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      _handleNavigation(jsonDecode(response.payload!));
    }
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    log('Navigate to: ${data['type']} - ${data['orderId']}');
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log('Background message received');
  }
}

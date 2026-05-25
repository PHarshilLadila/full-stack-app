// lib/services/fcm_notification_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FCMNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static String? _cachedToken;

  /// Initialize FCM for Seller (Mobile + Web)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize local notifications for mobile
    if (!kIsWeb) {
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
      await _localNotifications.initialize(settings);
    }

    try {
      // Request permission for mobile
      if (!kIsWeb) {
        NotificationSettings settings = await _fcm.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          log('✅ Seller: Notification permission granted');
        } else {
          log('⚠️ Seller: Notification permission denied');
        }
      }

      // Get and log FCM token
      final String? token = await _fcm.getToken();
      _cachedToken = token;
      log('📱 Seller FCM Token: $token');
      log('📱 Platform: ${kIsWeb ? "Web" : "Mobile"}');

      // Set up message handlers
      if (!kIsWeb) {
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      }
      
      _isInitialized = true;
    } catch (e) {
      log('⚠️ Seller FCM initialization error: $e');
    }
  }

  /// Save FCM token to backend (Called after successful login)
  static Future<void> saveTokenToBackend(String authToken) async {
    try {
      final String? fcmToken = await _fcm.getToken();
      
      if (fcmToken == null || fcmToken.isEmpty) {
        log('❌ No FCM token available for seller');
        return;
      }

      // Check if token already saved
      final prefs = await SharedPreferences.getInstance();
      final savedKey = kIsWeb ? 'seller_web_token_saved' : 'seller_mobile_token_saved';
      final savedToken = prefs.getString(savedKey);
      if (savedToken == fcmToken) {
        log('✅ Seller FCM token already saved');
        return;
      }

      // Determine app type
      final String appType = kIsWeb ? 'seller_web' : 'seller_mobile';

      log('📤 Saving seller token with appType: $appType');

      final response = await http.post(
        Uri.parse('https://full-stack-app-1-4iqk.onrender.com/fcm/token'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
          'deviceType': kIsWeb ? 'web' : (defaultTargetPlatform == TargetPlatform.android ? 'android' : 'ios'),
          'appType': appType,
        }),
      );

      if (response.statusCode == 200) {
        await prefs.setString(savedKey, fcmToken);
        log('✅ Seller FCM token saved to backend successfully (appType: $appType)');
      } else {
        log('❌ Failed to save seller token: ${response.body}');
      }
    } catch (e) {
      log('❌ Error saving seller token: $e');
    }
  }

  /// Remove FCM token from backend (On logout)
  static Future<void> removeTokenFromBackend(String authToken) async {
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
        await prefs.remove(kIsWeb ? 'seller_web_token_saved' : 'seller_mobile_token_saved');
        log('✅ Seller token removed from backend');
      }
    } catch (e) {
      log('❌ Error removing seller token: $e');
    }
  }

  /// Handle foreground messages (App is open)
  static void _handleForegroundMessage(RemoteMessage message) {
    log('📨 Seller foreground message received');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
    
    _showLocalNotification(
      title: message.notification?.title ?? 'New Update',
      body: message.notification?.body ?? '',
    );
  }

  /// Handle when app is opened from notification
  static void _handleMessageOpenedApp(RemoteMessage message) {
    log('📱 Seller app opened from notification');
    // Navigate to order details page
    _handleNavigation(message.data);
  }

  /// Show local notification (Mobile only)
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return; // Web doesn't need local notifications
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'seller_orders_channel',
      'Seller Order Notifications',
      channelDescription: 'Notifications for new orders and updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
    );
  }

  /// Handle navigation based on notification type
  static void _handleNavigation(Map<String, dynamic> data) {
    final String type = data['type'] ?? '';
    final String? orderId = data['orderId'];
    log('Navigate to order details: $orderId, type: $type');
    // Add navigation logic here if needed
  }

  /// Refresh token (call on app start)
  static Future<void> refreshToken(String authToken) async {
    await saveTokenToBackend(authToken);
  }
}
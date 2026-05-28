// lib/services/fcm_notification_service.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
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
  static bool _isWebSupported = false;

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
      // For Web Platform - Use JavaScript interop
      if (kIsWeb) {
        await _initializeWebFCM();
      } else {
        // For Mobile Platform
        NotificationSettings settings = await _fcm.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          log('✅ Seller: Notification permission granted');
          final String? token = await _fcm.getToken();
          _cachedToken = token;
          log('📱 Seller FCM Token: $token');

          // Set up message handlers for mobile
          FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
          FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
        } else {
          log('⚠️ Seller: Notification permission denied');
        }
      }

      _isInitialized = true;
    } catch (e) {
      log('⚠️ Seller FCM initialization error: $e');
    }
  }

  /// Initialize FCM for Web Platform
  static Future<void> _initializeWebFCM() async {
    try {
      log('🌐 Initializing Web FCM...');

      // Check if browser supports notifications
      if (!html.Notification.supported) {
        log('⚠️ Browser does not support notifications');
        _isWebSupported = false;
        return;
      }

      // Request permission
      final permission = await html.Notification.requestPermission();
      log('📱 Web Notification Permission: $permission');

      if (permission == 'granted') {
        _isWebSupported = true;

        // Wait for Firebase to initialize and get token
        await Future.delayed(const Duration(seconds: 2));

        // Get token from JavaScript
        final token = await _getWebFCMToken();
        _cachedToken = token;
        log('✅ Web FCM Token: $token');

        // Set up message listener from JavaScript
        _setupWebMessageListener();
      } else {
        log('⚠️ Web notification permission denied');
        _isWebSupported = false;
      }
    } catch (e) {
      log('❌ Web FCM initialization error: $e');
      _isWebSupported = false;
    }
  }

  /// Get FCM token from web using JavaScript
  /// Get FCM token from web using JavaScript
  static Future<String?> _getWebFCMToken() async {
    try {
      log('🔍 Looking for FCM token...');

      // First try to get from window object (set by index.html)
      for (int i = 0; i < 20; i++) {
        // Try up to 10 seconds
        await Future.delayed(Duration(milliseconds: 500));

        // Check from window object first
        final jsToken = _getTokenFromJS();
        if (jsToken != null &&
            jsToken.isNotEmpty &&
            !jsToken.startsWith('test_') &&
            !jsToken.startsWith('web_session')) {
          log('✅ Got real token from window object');
          // Save to localStorage for persistence
          html.window.localStorage['web_fcm_token'] = jsToken;
          return jsToken;
        }

        // Check from localStorage
        final localToken = html.window.localStorage['web_fcm_token'];
        if (localToken != null &&
            localToken.isNotEmpty &&
            !localToken.startsWith('test_') &&
            !localToken.startsWith('web_session')) {
          log('✅ Got real token from localStorage');
          return localToken;
        }

        if (i == 3) {
          log('⏳ Waiting for Firebase to generate token...');
        }
        if (i == 10) {
          log('⚠️ Still no token. Check if VAPID key is correct in index.html');
        }
      }

      // If we get here, no real token found
      log('❌ No real FCM token available after 10 seconds');
      log('💡 Make sure you have:');
      log('   1. Added correct VAPID key in web/index.html');
      log('   2. Firebase project has Web Push certificate');
      log('   3. Service worker is registered correctly');

      return null;
    } catch (e) {
      log('❌ Error getting web token: $e');
      return null;
    }
  }

  /// Get token from JavaScript window object
  static String? _getTokenFromJS() {
    try {
      // This accesses window._fcmToken set by index.html
      final token = (html.window as dynamic)._fcmToken;
      return token?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Set up listener for web messages from service worker
  static void _setupWebMessageListener() {
    // Listen for messages from service worker
    html.window.addEventListener('message', (event) {
      final data = event.path as Map?;
      if (data != null && data['type'] == 'NAVIGATE_TO_ORDER') {
        final orderId = data['orderId'];
        log('🔔 Navigation requested to order: $orderId');
        _handleNavigation({'orderId': orderId, 'type': 'order_status'});
      }
    });

    // Custom event for FCM messages
    html.window.addEventListener('fcm-message', (event) {
      final detail = (event as dynamic).detail;
      if (detail != null) {
        log('📨 Web message received: ${detail['notification']['title']}');
        _showWebNotification(
          title: detail['notification']['title'],
          body: detail['notification']['body'],
          data: detail['data'],
        );
      }
    });
  }

  /// Show web browser notification
  static void _showWebNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    if (!_isWebSupported) return;

    try {
      final notification = html.Notification(
        title,
        body: body,
        icon: '/favicon.png',
        // silent: false,
      );

      // notification.onclick = (event) {
      //   notification.close();
      //   _handleNavigation(data ?? {});
      // };
    } catch (e) {
      log('❌ Error showing web notification: $e');
    }
  }

  /// Save FCM token to backend (Called after successful login)
  static Future<void> saveTokenToBackend(String authToken) async {
    try {
      String? fcmToken;

      if (kIsWeb) {
        // For web, get token from localStorage or JS
        fcmToken = html.window.localStorage['web_fcm_token'];
        if (fcmToken == null || fcmToken.isEmpty) {
          fcmToken = _getTokenFromJS();
        }
        // Wait a bit if token not available yet
        if (fcmToken == null || fcmToken.isEmpty) {
          await Future.delayed(const Duration(seconds: 2));
          fcmToken = html.window.localStorage['web_fcm_token'];
        }
      } else {
        // For mobile
        fcmToken = await _fcm.getToken();
      }

      if (fcmToken == null || fcmToken.isEmpty) {
        log('❌ No FCM token available for seller');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final savedKey =
          kIsWeb ? 'seller_web_token_saved' : 'seller_mobile_token_saved';
      final savedToken = prefs.getString(savedKey);

      if (savedToken == fcmToken) {
        log('✅ Seller FCM token already saved');
        return;
      }

      final String appType = kIsWeb ? 'seller_web' : 'seller_mobile';
      final String deviceType = kIsWeb ? 'web' : 'android';

      log('📤 Saving seller token - Platform: ${kIsWeb ? "Web" : "Mobile"}');
      log('📤 App Type: $appType');
      log(
        '📤 Token: ${fcmToken.substring(0, fcmToken.length > 30 ? 30 : fcmToken.length)}...',
      );

      final response = await http.post(
        Uri.parse('https://full-stack-app-1-4iqk.onrender.com/fcm/token'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
          'deviceType': deviceType,
          'appType': appType,
        }),
      );

      log('📤 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        await prefs.setString(savedKey, fcmToken);
        log('✅ Seller FCM token saved to backend successfully');

        // Show success message for debugging
        if (kIsWeb) {
          log('🎉 Web notification ready! You will receive order updates.');
        }
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
      String? fcmToken;

      if (kIsWeb) {
        fcmToken = html.window.localStorage['web_fcm_token'];
      } else {
        fcmToken = await _fcm.getToken();
      }

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
        await prefs.remove(
          kIsWeb ? 'seller_web_token_saved' : 'seller_mobile_token_saved',
        );
        log('✅ Seller token removed from backend');
      }
    } catch (e) {
      log('❌ Error removing seller token: $e');
    }
  }

  /// Handle foreground messages (App is open - Mobile only)
  static void _handleForegroundMessage(RemoteMessage message) {
    log('📨 Seller foreground message received');
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');

    _showLocalNotification(
      title: message.notification?.title ?? 'New Update',
      body: message.notification?.body ?? '',
    );
  }

  /// Handle when app is opened from notification (Mobile only)
  static void _handleMessageOpenedApp(RemoteMessage message) {
    log('📱 Seller app opened from notification');
    _handleNavigation(message.data);
  }

  /// Show local notification (Mobile only)
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
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
    log('🔔 Navigate to order details: $orderId, type: $type');

    // You can add navigation logic here using a global navigator key
    // For now, just log
  }

  /// Refresh token (call on app start)
  static Future<void> refreshToken(String authToken) async {
    await saveTokenToBackend(authToken);
  }

  /// Check if FCM is available
  static bool isAvailable() {
    if (kIsWeb) {
      return _isWebSupported;
    }
    return _isInitialized;
  }
}

// app_backend/lib/services/notification_service.dart
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import '../config/firebase.dart';
import '../db/mongo.dart';

class NotificationService {
  /// Send push notification to a device
  static Future<bool> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      return await FirebaseConfig.sendNotification(
        fcmToken: fcmToken,
        title: title,
        body: body,
        data: data,
      );
    } catch (e) {
      print('❌ Error sending push notification: $e');
      return false;
    }
  }

  /// Send notification to seller about new order
  static Future<void> notifySellerNewOrder({
    required String sellerId,
    required String orderId,
    required String customerName,
    required double orderAmount,
    required int itemCount,
  }) async {
    final title = '🛍️ New Order Received!';
    final body = '$customerName placed order #$orderId for ₹$orderAmount';

    final data = {
      'type': 'order_created',
      'orderId': orderId,
      'customerName': customerName,
      'orderAmount': orderAmount.toString(),
      'itemCount': itemCount.toString(),
      'clickAction': 'ORDER_DETAILS',
    };

    // Send to seller mobile
    await _sendToUserOnApp(
      userId: sellerId,
      appType: 'seller_mobile',
      title: title,
      body: body,
      data: data,
    );

    // Also send to seller web
    await _sendToUserOnApp(
      userId: sellerId,
      appType: 'seller_web',
      title: title,
      body: body,
      data: data,
    );
  }

  /// Send notification to customer about order status
  static Future<void> notifyCustomerOrderStatus({
    required String customerId,
    required String orderId,
    required String status,
    required String title,
    required String message,
    String? trackingId,
  }) async {
    final data = {
      'type': status,
      'orderId': orderId,
      'status': status,
      'clickAction': 'ORDER_DETAILS',
    };

    if (trackingId != null) {
      data['trackingId'] = trackingId;
    }

    // Send to customer mobile only
    await _sendToUserOnApp(
      userId: customerId,
      appType: 'customer_mobile',
      title: title,
      body: message,
      data: data,
    );
  }

  /// Internal method to send notification to specific app type
  static Future<void> _sendToUserOnApp({
    required String userId,
    required String appType,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final userObjectId = ObjectId.parse(userId);
      final user = await MongoService.users!.findOne({'_id': userObjectId});

      if (user == null) {
        print('User not found: $userId');
        return;
      }

      final tokens = user['fcmTokens'] as List? ?? [];

      for (var tokenObj in tokens) {
        final token = tokenObj['token'] as String?;
        final tokenAppType = tokenObj['appType'] as String?;

        if (token != null &&
            tokenObj['isActive'] == true &&
            tokenAppType == appType) {
          await sendPushNotification(
            fcmToken: token,
            title: title,
            body: body,
            data: data,
          );
        }
      }
    } catch (e) {
      print('❌ Error sending to user: $e');
    }
  }

  /// Save notification to database history
  static Future<void> saveNotificationHistory({
    required String userId,
    required String userRole,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      final shortId = userId.length > 4 ? userId.substring(0, 4) : userId;
      final notificationId =
          'NOTIF_${DateTime.now().millisecondsSinceEpoch}_$shortId';

      final notificationData = {
        'notificationId': notificationId,
        'userId': userId,
        'userRole': userRole,
        'title': title,
        'body': body,
        'type': type,
        'data': data,
        'isRead': false,
        'createdAt': DateTime.now(),
      };

      await MongoService.notifications!.insertOne(notificationData);
      print('✅ Notification saved to history: $notificationId');
    } catch (e) {
      print('❌ Failed to save notification history: $e');
    }
  }
}

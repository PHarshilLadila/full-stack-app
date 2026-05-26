// app_backend/services/notification_service.dart
import 'package:mongo_dart/mongo_dart.dart';
import '../db/mongo.dart';
import '../config/firebase.dart';

class NotificationService {
  // Save FCM token to database
  static Future<void> saveFCMToken({
    required String userId,
    required String fcmToken,
    required String role,
  }) async {
    try {
      final result = await MongoService.users!.updateOne(
        {'_id': ObjectId.parse(userId)},
        {
          '\$set': {
            'fcmToken': fcmToken,
            'updatedAt': DateTime.now(),
            'role': role, // Ensure role is set
          },
        },
      );

      if (result.isSuccess) {
        print('✅ FCM Token saved for $role: $userId');
      } else {
        print('❌ Failed to save FCM token for $role: $userId');
      }
    } catch (e) {
      print('❌ Failed to save FCM token: $e');
    }
  }

  // Get customer's FCM token
  static Future<String?> getCustomerFCMToken(String userId) async {
    try {
      final user = await MongoService.users!.findOne({
        '_id': ObjectId.parse(userId),
      });
      final token = user?['fcmToken']?.toString();
      print(
        '📱 Customer token for $userId: ${token != null ? 'Found' : 'Not found'}',
      );
      return token;
    } catch (e) {
      print('❌ Failed to get customer token: $e');
      return null;
    }
  }

  // Get seller's FCM token
  static Future<String?> getSellerFCMToken(String sellerId) async {
    try {
      final seller = await MongoService.users!.findOne({
        '_id': ObjectId.parse(sellerId),
        'role': 'seller',
      });
      final token = seller?['fcmToken']?.toString();
      print(
        '📱 Seller token for $sellerId: ${token != null ? 'Found' : 'Not found'}',
      );
      return token;
    } catch (e) {
      print('❌ Failed to get seller token: $e');
      return null;
    }
  }

  // Send notification to customer for order status change
  static Future<void> notifyCustomerOrderStatus({
    required String customerId,
    required String orderId,
    required String status,
    required String title,
    required String message,
    String? trackingId,
  }) async {
    try {
      final fcmToken = await getCustomerFCMToken(customerId);

      if (fcmToken == null || fcmToken.isEmpty) {
        print('⚠️ No FCM token found for customer: $customerId');
        return;
      }

      final success = await FirebaseConfig.sendNotification(
        fcmToken: fcmToken,
        title: title,
        body: message,
        data: {
          'type': 'order_status',
          'orderId': orderId,
          'status': status,
          'trackingId': trackingId ?? '',
        },
      );

      if (success) {
        print('✅ Notification sent to customer: $customerId');
      } else {
        print('❌ Failed to send notification to customer: $customerId');
      }
    } catch (e) {
      print('❌ Failed to send customer notification: $e');
    }
  }

  // Send notification to seller for new order
  static Future<void> notifySellerNewOrder({
    required String sellerId,
    required String orderId,
    required String customerName,
  }) async {
    try {
      final fcmToken = await getSellerFCMToken(sellerId);

      if (fcmToken == null || fcmToken.isEmpty) {
        print('⚠️ No FCM token found for seller: $sellerId');
        return;
      }

      final success = await FirebaseConfig.sendNotification(
        fcmToken: fcmToken,
        title: '🛒 New Order Received!',
        body: 'Order #$orderId from $customerName',
        data: {
          'type': 'new_order',
          'orderId': orderId,
          'customerName': customerName,
        },
      );

      if (success) {
        print('✅ Notification sent to seller: $sellerId');
      } else {
        print('❌ Failed to send notification to seller: $sellerId');
      }
    } catch (e) {
      print('❌ Failed to send seller notification: $e');
    }
  }

  // Send notification to multiple sellers (for bulk orders)
  static Future<void> notifyMultipleSellers({
    required List<String> sellerIds,
    required String orderId,
    required String customerName,
  }) async {
    for (final sellerId in sellerIds) {
      await notifySellerNewOrder(
        sellerId: sellerId,
        orderId: orderId,
        customerName: customerName,
      );
    }
  }

  // Save notification history in database
  static Future<void> saveNotificationHistory({
    required String userId,
    required String userRole,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    try {
      final notification = {
        'userId': userId,
        'userRole': userRole,
        'title': title,
        'body': body,
        'type': type,
        'data': data ?? {},
        'isRead': false,
        'createdAt': DateTime.now(),
      };

      await MongoService.notifications!.insert(notification);
      print('✅ Notification saved to history for $userRole: $userId');
    } catch (e) {
      print('❌ Failed to save notification history: $e');
    }
  }
}

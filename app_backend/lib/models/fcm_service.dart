// // services/fcm_service.dart
// import 'package:firebase_admin/firebase_admin.dart';

// class FCMService {
//   static FirebaseMessaging? messaging;
  
//   static Future<void> initialize() async {
//     // Initialize Firebase Admin SDK
//     messaging = FirebaseMessaging.instance;
//   }
  
//   static Future<void> sendNotification({
//     required String fcmToken,
//     required String title,
//     required String body,
//     Map<String, String>? data,
//   }) async {
//     try {
//       await messaging?.sendToDevice(
//         token: fcmToken,
//         notification: Notification(title: title, body: body),
//         data: data,
//       );
//       print('✅ Notification sent to: $fcmToken');
//     } catch (e) {
//       print('❌ Failed to send: $e');
//     }
//   }
  
//   // Customer ne notification (Order status change)
//   static Future<void> notifyCustomer({
//     required String customerFcmToken,
//     required String orderId,
//     required String newStatus,
//   }) async {
//     await sendNotification(
//       fcmToken: customerFcmToken,
//       title: 'Order Status Updated',
//       body: 'Your order #$orderId is now $newStatus',
//       data: {
//         'type': 'order_status',
//         'orderId': orderId,
//         'status': newStatus,
//       },
//     );
//   }
  
//   // Seller ne notification (New order)
//   static Future<void> notifySeller({
//     required String sellerFcmToken,
//     required String orderId,
//   }) async {
//     await sendNotification(
//       fcmToken: sellerFcmToken,
//       title: 'New Order Received!',
//       body: 'New order #$orderId has been placed',
//       data: {
//         'type': 'new_order',
//         'orderId': orderId,
//       },
//     );
//   }
// }
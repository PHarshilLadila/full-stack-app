// app_backend/lib/models/notification_model.dart
import 'package:mongo_dart/mongo_dart.dart';

/// Model for storing FCM token in user document
class FCMTokenModel {
  final String token;
  final String deviceType; // 'android', 'ios', 'web'
  final String appType;    // 'customer_mobile', 'seller_mobile', 'seller_web'
  final DateTime createdAt;
  bool isActive;

  FCMTokenModel({
    required this.token,
    required this.deviceType,
    required this.appType,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'deviceType': deviceType,
      'appType': appType,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory FCMTokenModel.fromJson(Map<String, dynamic> json) {
    return FCMTokenModel(
      token: json['token'] as String,
      deviceType: json['deviceType'] as String,
      appType: json['appType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

/// Model for storing notification history
class NotificationHistoryModel {
  final ObjectId? id;
  final String notificationId;
  final String userId;
  final String userRole; // 'customer', 'seller', 'admin'
  final String title;
  final String body;
  final String type; // 'order_created', 'order_confirmed', 'order_shipped', etc.
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  NotificationHistoryModel({
    this.id,
    required this.notificationId,
    required this.userId,
    required this.userRole,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'notificationId': notificationId,
      'userId': userId,
      'userRole': userRole,
      'title': title,
      'body': body,
      'type': type,
      'data': data,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  factory NotificationHistoryModel.fromJson(Map<String, dynamic> json) {
    return NotificationHistoryModel(
      id: json['_id'] as ObjectId?,
      notificationId: json['notificationId'] as String,
      userId: json['userId'] as String,
      userRole: json['userRole'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as DateTime,
    );
  }
}
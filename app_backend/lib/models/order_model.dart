// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:mongo_dart/mongo_dart.dart';

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double? discountPrice;
  final int quantity;
  final double totalPrice;
  final String sellerId;
  final String sellerName;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.discountPrice,
    required this.quantity,
    required this.totalPrice,
    required this.sellerId,
    required this.sellerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'discountPrice': discountPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'sellerId': sellerId,
      'sellerName': sellerName,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      productImage: json['productImage']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice:
          json['discountPrice'] != null
              ? (json['discountPrice'] as num).toDouble()
              : null,
      quantity: json['quantity'] as int? ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      sellerId: json['sellerId']?.toString() ?? '',
      sellerName: json['sellerName']?.toString() ?? '',
    );
  }
}

class OrderModel {
  final ObjectId? id;
  final String orderId;
  final String userId;
  final String userName;
  final String userEmail;
  final String userMobile;
  final List<OrderItemModel> items;
  final Map<String, dynamic> shippingAddress;
  final double subtotal;
  final double shippingCharge;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String? trackingId;
  final DateTime orderDate;
  final DateTime? deliveredDate;
  final DateTime? cancelledDate;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    this.id,
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userMobile,
    required this.items,
    required this.shippingAddress,
    required this.subtotal,
    required this.shippingCharge,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.trackingId,
    required this.orderDate,
    this.deliveredDate,
    this.cancelledDate,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userMobile': userMobile,
      'items': items.map((e) => e.toJson()).toList(),
      'shippingAddress': shippingAddress,
      'subtotal': subtotal,
      'shippingCharge': shippingCharge,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'trackingId': trackingId,
      'orderDate': orderDate,
      'deliveredDate': deliveredDate,
      'cancelledDate': cancelledDate,
      'cancellationReason': cancellationReason,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return OrderModel(
      id: json['_id'] as ObjectId?,
      orderId: json['orderId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      userEmail: json['userEmail']?.toString() ?? '',
      userMobile: json['userMobile']?.toString() ?? '',
      items:
          itemsList
              .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      shippingAddress: json['shippingAddress'] as Map<String, dynamic>? ?? {},
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingCharge: (json['shippingCharge'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      orderStatus: json['orderStatus']?.toString() ?? 'pending',
      trackingId: json['trackingId']?.toString(),
      orderDate: json['orderDate'] as DateTime? ?? DateTime.now(),
      deliveredDate: json['deliveredDate'] as DateTime?,
      cancelledDate: json['cancelledDate'] as DateTime?,
      cancellationReason: json['cancellationReason']?.toString(),
      createdAt: json['createdAt'] as DateTime? ?? DateTime.now(),
      updatedAt: json['updatedAt'] as DateTime? ?? DateTime.now(),
    );
  }
}

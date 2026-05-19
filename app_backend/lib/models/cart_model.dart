// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:mongo_dart/mongo_dart.dart';

class CartItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double? discountPrice;
  final int quantity;
  final String sellerId;
  final String sellerName;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.discountPrice,
    required this.quantity,
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
      'sellerId': sellerId,
      'sellerName': sellerName,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      productImage: json['productImage']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice:
          json['discountPrice'] != null
              ? (json['discountPrice'] as num).toDouble()
              : null,
      quantity: json['quantity'] as int? ?? 1,
      sellerId: json['sellerId']?.toString() ?? '',
      sellerName: json['sellerName']?.toString() ?? '',
    );
  }
}

class CartModel {
  final ObjectId? id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final double discountAmount;
  final double finalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'finalAmount': finalAmount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return CartModel(
      id: json['_id'] as ObjectId?,
      userId: json['userId']?.toString() ?? '',
      items:
          itemsList
              .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] as DateTime? ?? DateTime.now(),
      updatedAt: json['updatedAt'] as DateTime? ?? DateTime.now(),
    );
  }
}

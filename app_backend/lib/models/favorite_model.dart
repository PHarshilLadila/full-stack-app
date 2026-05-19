// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:mongo_dart/mongo_dart.dart';

class FavoriteModel {
  final ObjectId? id;
  final String userId;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double? discountPrice;
  final String sellerId;
  final String sellerName;
  final double rating;
  final DateTime createdAt;

  FavoriteModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.discountPrice,
    required this.sellerId,
    required this.sellerName,
    required this.rating,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'discountPrice': discountPrice,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['_id'] as ObjectId?,
      userId: json['userId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      productImage: json['productImage']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice:
          json['discountPrice'] != null
              ? (json['discountPrice'] as num).toDouble()
              : null,
      sellerId: json['sellerId']?.toString() ?? '',
      sellerName: json['sellerName']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] as DateTime? ?? DateTime.now(),
    );
  }
}

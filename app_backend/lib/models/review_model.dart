// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:mongo_dart/mongo_dart.dart';

class ReviewModel {
  final ObjectId? id;
  final String productId;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating; // 1 to 5 stars
  final String comment;
  final List<String> images;
  final bool isVerifiedPurchase;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.rating,
    required this.comment,
    this.images = const [],
    this.isVerifiedPurchase = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'images': images,
      'isVerifiedPurchase': isVerifiedPurchase,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] as ObjectId?,
      productId: json['productId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      userAvatar: json['userAvatar']?.toString() ?? '',
      rating: json['rating'] as int? ?? 0,
      comment: json['comment']?.toString() ?? '',
      images: _parseStringList(json['images']),
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
      createdAt: json['createdAt'] as DateTime? ?? DateTime.now(),
      updatedAt: json['updatedAt'] as DateTime? ?? DateTime.now(),
    );
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}

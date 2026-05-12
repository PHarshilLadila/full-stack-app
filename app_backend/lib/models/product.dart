// ignore_for_file: public_member_api_docs, sort_constructors_first, always_put_required_named_parameters_first, lines_longer_than_80_chars

import 'package:mongo_dart/mongo_dart.dart';

class ProductModel {
  final ObjectId? id;
  final String sellerId;
  final String sellerName;
  final String productName;
  final String mainBannerImage;
  final List<String> multipleImages;
  final double price;
  final double? discountPrice;
  final int stock;
  final bool stockAvailable;
  final String category;
  final String subCategory;
  final List<String> tags; // e.g., ['popular', 'hot', 'best_selling']
  final double rating;
  final int totalReviews;
  final String shortDescription;
  final String detailedDescription;
  final Map<String, dynamic>
  specifications; // e.g., {'brand': 'Nike', 'color': 'Red'}
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  ProductModel({
    this.id,
    required this.sellerId,
    required this.sellerName,
    required this.productName,
    required this.mainBannerImage,
    required this.multipleImages,
    required this.price,
    this.discountPrice,
    required this.stock,
    required this.stockAvailable,
    required this.category,
    required this.subCategory,
    required this.tags,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.shortDescription,
    required this.detailedDescription,
    required this.specifications,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'productName': productName,
      'mainBannerImage': mainBannerImage,
      'multipleImages': multipleImages,
      'price': price,
      'discountPrice': discountPrice,
      'stock': stock,
      'stockAvailable': stockAvailable,
      'category': category,
      'subCategory': subCategory,
      'tags': tags,
      'rating': rating,
      'totalReviews': totalReviews,
      'shortDescription': shortDescription,
      'detailedDescription': detailedDescription,
      'specifications': specifications,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] as ObjectId?,
      sellerId: json['sellerId']?.toString() ?? '',
      sellerName: json['sellerName']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      mainBannerImage: json['mainBannerImage']?.toString() ?? '',
      multipleImages: _parseStringList(json['multipleImages']),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice:
          json['discountPrice'] != null
              ? (json['discountPrice'] as num).toDouble()
              : null,
      stock: json['stock'] as int? ?? 0,
      stockAvailable: json['stockAvailable'] as bool? ?? false,
      category: json['category']?.toString() ?? '',
      subCategory: json['subCategory']?.toString() ?? '',
      tags: _parseStringList(json['tags']),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      shortDescription: json['shortDescription']?.toString() ?? '',
      detailedDescription: json['detailedDescription']?.toString() ?? '',
      specifications: _parseMap(json['specifications']),
      createdAt: json['createdAt'] as DateTime? ?? DateTime.now(),
      updatedAt: json['updatedAt'] as DateTime? ?? DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Helper method to safely parse List<String>
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  // Helper method to safely parse Map<String, dynamic>
  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return {};
  }
}

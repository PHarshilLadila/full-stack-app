// lib/features/customer/customer_web/models/product_details_model.dart
import 'package:equatable/equatable.dart';

class ProductDetailsResponse {
  final bool success;
  final String message;
  final ProductDetailsData data;

  ProductDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ProductDetailsData.fromJson(json['data']),
    );
  }
}

class ProductDetailsData extends Equatable {
  final String id;
  final String sellerId;
  final String sellerName;
  final String productName;
  final String mainBannerImage;
  final List<String> multipleImages;
  final double price;
  final double discountPrice;
  final int stock;
  final bool stockAvailable;
  final String category;
  final String subCategory;
  final List<String> tags;
  final double rating;
  final int totalReviews;
  final String shortDescription;
  final String detailedDescription;
  final Map<String, dynamic> specifications;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const ProductDetailsData({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.productName,
    required this.mainBannerImage,
    required this.multipleImages,
    required this.price,
    required this.discountPrice,
    required this.stock,
    required this.stockAvailable,
    required this.category,
    required this.subCategory,
    required this.tags,
    required this.rating,
    required this.totalReviews,
    required this.shortDescription,
    required this.detailedDescription,
    required this.specifications,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) {
    return ProductDetailsData(
      id: json['_id'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      productName: json['productName'] as String,
      mainBannerImage: json['mainBannerImage'] as String,
      multipleImages: List<String>.from(json['multipleImages'] ?? []),
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
      stock: json['stock'] as int,
      stockAvailable: json['stockAvailable'] as bool,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      shortDescription: json['shortDescription'] as String,
      detailedDescription: json['detailedDescription'] as String,
      specifications: json['specifications'] as Map<String, dynamic>,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  int get discountPercentage {
    if (price > discountPrice) {
      return ((price - discountPrice) / price * 100).round();
    }
    return 0;
  }

  @override
  List<Object?> get props => [id, productName];
}
// lib/features/customer/customer_web/models/product_model.dart
import 'package:equatable/equatable.dart';

class ProductData extends Equatable {
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

  const ProductData({
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
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
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
    );
  }

  // Helper methods
  bool get isFeatured => tags.contains('Featured');
  bool get isTrending => tags.contains('Trending');
  bool get isNew => tags.contains('New');
  bool get isBestSeller =>
      tags.contains('Best Seller') || tags.contains('Bestseller');
  bool get isPopular => tags.contains('Popular');
  bool get isSale => tags.contains('Sale');

  int get discountPercentage {
    if (price > discountPrice) {
      return ((price - discountPrice) / price * 100).round();
    }
    return 0;
  }

  @override
  List<Object?> get props => [id, productName];
}

class ProductListResponse {
  final String message;
  final List<ProductData> data;
  final PaginationInfo? pagination;

  ProductListResponse({
    required this.message,
    required this.data,
    this.pagination,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      message: json['message'] as String,
      data:
          (json['data'] as List)
              .map((item) => ProductData.fromJson(item))
              .toList(),
      pagination:
          json['pagination'] != null
              ? PaginationInfo.fromJson(json['pagination'])
              : null,
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
    );
  }
}

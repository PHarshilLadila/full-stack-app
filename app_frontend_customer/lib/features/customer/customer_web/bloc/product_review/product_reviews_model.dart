// lib/features/customer/customer_web/models/product_reviews_model.dart
import 'package:equatable/equatable.dart';

class ProductReviewsResponse {
  final bool success;
  final String message;
  final ReviewsData data;

  ProductReviewsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ProductReviewsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ReviewsData.fromJson(json['data']),
    );
  }
}

class ReviewsData {
  final String productId;
  final String productName;
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingDistribution;
  final List<ReviewData> reviews;
  final PaginationData pagination;

  ReviewsData({
    required this.productId,
    required this.productName,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.reviews,
    required this.pagination,
  });

  factory ReviewsData.fromJson(Map<String, dynamic> json) {
    return ReviewsData(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      ratingDistribution: Map<String, int>.from(json['ratingDistribution']),
      reviews: (json['reviews'] as List)
          .map((item) => ReviewData.fromJson(item))
          .toList(),
      pagination: PaginationData.fromJson(json['pagination']),
    );
  }
}

class ReviewData extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String comment;
  final List<String> images;
  final bool isVerifiedPurchase;
  final String createdAt;
  final String updatedAt;

  const ReviewData({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.images,
    required this.isVerifiedPurchase,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['_id'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      images: List<String>.from(json['images'] ?? []),
      isVerifiedPurchase: json['isVerifiedPurchase'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  @override
  List<Object?> get props => [id, userName];
}

class PaginationData {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  PaginationData({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
    );
  }
}
// lib/features/customer/review/model/review_model.dart

 
class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String comment;
  final List<String> images;
  final bool isVerifiedPurchase;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
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

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      userAvatar: json['userAvatar']?.toString() ?? '',
      rating: json['rating'] is int ? json['rating'] : (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment']?.toString() ?? '',
      images: json['images'] is List ? List<String>.from(json['images'].map((e) => e.toString())) : [],
      isVerifiedPurchase: json['isVerifiedPurchase'] == true,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ProductReviewsResponse {
  final bool success;
  final String message;
  final ReviewData? data;

  ProductReviewsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProductReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ProductReviewsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? ReviewData.fromJson(json['data']) : null,
    );
  }
}

class ReviewData {
  final String productId;
  final String productName;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;
  final List<ReviewModel> reviews;
  final Pagination pagination;

  ReviewData({
    required this.productId,
    required this.productName,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.reviews,
    required this.pagination,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    // Handle ratingDistribution - it might come as Map<String, dynamic>
    Map<int, int> distribution = {};
    final distData = json['ratingDistribution'];
    if (distData is Map) {
      distData.forEach((key, value) {
        try {
          final intKey = int.tryParse(key.toString()) ?? 0;
          final intValue = value is int ? value : (value as num?)?.toInt() ?? 0;
          distribution[intKey] = intValue;
        } catch (e) {
          // Skip invalid entries
        }
      });
    }

    return ReviewData(
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      ratingDistribution: distribution,
      reviews: (json['reviews'] as List?)
          ?.map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      pagination: json['pagination'] != null 
          ? Pagination.fromJson(json['pagination']) 
          : Pagination(currentPage: 1, totalPages: 1, totalItems: 0, itemsPerPage: 10),
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: json['totalItems'] as int? ?? 0,
      itemsPerPage: json['itemsPerPage'] as int? ?? 10,
    );
  }
}

class AddReviewResponse {
  final bool success;
  final String message;
  final AddReviewData? data;

  AddReviewResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AddReviewResponse.fromJson(Map<String, dynamic> json) {
    return AddReviewResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? AddReviewData.fromJson(json['data']) : null,
    );
  }
}

class AddReviewData {
  final String reviewId;
  final String productId;
  final int rating;
  final List<String> images;

  AddReviewData({
    required this.reviewId,
    required this.productId,
    required this.rating,
    required this.images,
  });

  factory AddReviewData.fromJson(Map<String, dynamic> json) {
    return AddReviewData(
      reviewId: json['reviewId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      rating: json['rating'] as int? ?? 0,
      images: json['images'] is List ? List<String>.from(json['images'].map((e) => e.toString())) : [],
    );
  }
}
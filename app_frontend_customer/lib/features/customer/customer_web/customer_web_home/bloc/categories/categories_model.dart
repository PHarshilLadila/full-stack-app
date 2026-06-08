// lib/features/customer/customer_web/models/category_model.dart
class CategoryResponse {
  final String message;
  final List<CategoryData> data;
  final int totalCategories;

  CategoryResponse({
    required this.message,
    required this.data,
    required this.totalCategories,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => CategoryData.fromJson(item))
          .toList(),
      totalCategories: json['totalCategories'] as int,
    );
  }
}

class CategoryData {
  final String name;
  final List<String> subCategories;
  final int productCount;

  CategoryData({
    required this.name,
    required this.subCategories,
    required this.productCount,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      name: json['name'] as String,
      subCategories: List<String>.from(json['subCategories'] ?? []),
      productCount: json['productCount'] as int? ?? 0,
    );
  }
}

// For product list response
class ProductListResponse {
  final String message;
  final List<ProductData> data;
  final PaginationData pagination;

  ProductListResponse({
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => ProductData.fromJson(item))
          .toList(),
      pagination: PaginationData.fromJson(json['pagination']),
    );
  }
}

class ProductData {
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

  ProductData({
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
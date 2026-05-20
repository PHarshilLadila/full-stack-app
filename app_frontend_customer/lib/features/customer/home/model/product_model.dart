class ProductResponse {
  final String message;
  final List<Product> data;
  final Pagination pagination;

  ProductResponse({
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<Product>.from(json['data'].map((x) => Product.fromJson(x)))
          : [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'pagination': pagination.toJson(),
    };
  }
}

class Product {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Product({
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
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      productName: json['productName'] ?? '',
      mainBannerImage: json['mainBannerImage'] ?? '',
      multipleImages: json['multipleImages'] != null
          ? List<String>.from(json['multipleImages'])
          : [],
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      stockAvailable: json['stockAvailable'] ?? false,
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      shortDescription: json['shortDescription'] ?? '',
      detailedDescription: json['detailedDescription'] ?? '',
      specifications: json['specifications'] != null
          ? Map<String, dynamic>.from(json['specifications'])
          : {},
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? false,
    );
  }

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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  double get discountedPrice => discountPrice > 0 ? discountPrice : price;
  double get discountPercentage => price > 0 
      ? ((price - discountedPrice) / price * 100).roundToDouble()
      : 0.0;
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
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
    };
  }
}

// lib/features/customer/home/model/product_model.dart
// Add this class to your existing product_model.dart

class ProductDetails {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  ProductDetails({
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
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['_id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      productName: json['productName'] ?? '',
      mainBannerImage: json['mainBannerImage'] ?? '',
      multipleImages: json['multipleImages'] != null
          ? List<String>.from(json['multipleImages'])
          : [],
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      stockAvailable: json['stockAvailable'] ?? false,
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      shortDescription: json['shortDescription'] ?? '',
      detailedDescription: json['detailedDescription'] ?? '',
      specifications: json['specifications'] != null
          ? Map<String, dynamic>.from(json['specifications'])
          : {},
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? false,
    );
  }

  double get discountedPrice => discountPrice > 0 ? discountPrice : price;
  
  double get discountPercentage => price > 0 
      ? ((price - discountedPrice) / price * 100).roundToDouble()
      : 0.0;
  
  String get formattedPrice => '₹${discountedPrice.toStringAsFixed(0)}';
  String get formattedOriginalPrice => '₹${price.toStringAsFixed(0)}';
}
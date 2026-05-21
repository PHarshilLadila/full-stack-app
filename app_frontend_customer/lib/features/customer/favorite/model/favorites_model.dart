// lib/features/customer/favorites/model/favorites_model.dart

class FavoriteItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double discountPrice;
  final String sellerId;
  final String sellerName;
  final double rating;
  final DateTime createdAt;

  FavoriteItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.discountPrice,
    required this.sellerId,
    required this.sellerName,
    required this.rating,
    required this.createdAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['_id'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  double get discountedPrice => discountPrice > 0 ? discountPrice : price;
  
  double get discountPercentage => price > 0 
      ? ((price - discountedPrice) / price * 100).roundToDouble()
      : 0.0;
  
  String get formattedPrice => '₹${discountedPrice.toStringAsFixed(0)}';
  String get formattedOriginalPrice => '₹${price.toStringAsFixed(0)}';
}

class FavoritesResponse {
  final bool success;
  final String message;
  final List<FavoriteItem> data;
  final PaginationInfo? pagination;

  FavoritesResponse({
    required this.success,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) {
    return FavoritesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<FavoriteItem>.from(json['data'].map((x) => FavoriteItem.fromJson(x)))
          : [],
      pagination: json['pagination'] != null 
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
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 20,
    );
  }
}

class AddFavoriteResponse {
  final bool success;
  final String message;

  AddFavoriteResponse({
    required this.success,
    required this.message,
  });

  factory AddFavoriteResponse.fromJson(Map<String, dynamic> json) {
    return AddFavoriteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class RemoveFavoriteResponse {
  final bool success;
  final String message;

  RemoveFavoriteResponse({
    required this.success,
    required this.message,
  });

  factory RemoveFavoriteResponse.fromJson(Map<String, dynamic> json) {
    return RemoveFavoriteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
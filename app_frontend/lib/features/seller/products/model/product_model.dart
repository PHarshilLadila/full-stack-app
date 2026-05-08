class ProductModel {
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
  final String createdAt;
  final String updatedAt;
  final bool isActive;

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      productName: json['productName'] ?? '',
      mainBannerImage: json['mainBannerImage'] ?? '',
      multipleImages: List<String>.from(json['multipleImages'] ?? []),
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      stockAvailable: json['stockAvailable'] ?? false,
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      shortDescription: json['shortDescription'] ?? '',
      detailedDescription: json['detailedDescription'] ?? '',
      specifications: Map<String, dynamic>.from(
        json['specifications'] ?? {},
      ),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
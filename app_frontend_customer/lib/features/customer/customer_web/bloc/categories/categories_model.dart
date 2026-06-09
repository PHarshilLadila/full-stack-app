// lib/features/customer/customer_web/customer_web_home/bloc/categories/categories_model.dart
 
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
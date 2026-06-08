// lib/features/customer/customer_web/customer_web_home/bloc/featured_products/featured_products_model.dart
import '../../../models/product_model.dart';

class FeaturedProductsResponse {
  final String message;
  final List<ProductData> data;
  final PaginationInfo? pagination;

  FeaturedProductsResponse({
    required this.message,
    required this.data,
    this.pagination,
  });

  factory FeaturedProductsResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedProductsResponse(
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => ProductData.fromJson(item))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'])
          : null,
    );
  }
}
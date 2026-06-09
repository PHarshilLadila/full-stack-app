// lib/features/customer/customer_web/customer_web_home/bloc/trending_products/trending_products_model.dart
import '../../models/product_model.dart';

class TrendingProductsResponse {
  final String message;
  final List<ProductData> data;
  final PaginationInfo? pagination;

  TrendingProductsResponse({
    required this.message,
    required this.data,
    this.pagination,
  });

  factory TrendingProductsResponse.fromJson(Map<String, dynamic> json) {
    return TrendingProductsResponse(
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
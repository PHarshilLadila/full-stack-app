// lib/features/customer/customer_web/customer_web_home/bloc/flash_deals/flash_deals_model.dart
import '../../models/product_model.dart';

class FlashDealsResponse {
  final String message;
  final List<ProductData> data;
  final PaginationInfo? pagination;

  FlashDealsResponse({
    required this.message,
    required this.data,
    this.pagination,
  });

  factory FlashDealsResponse.fromJson(Map<String, dynamic> json) {
    return FlashDealsResponse(
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
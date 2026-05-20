// lib/features/customer/home/service/product_details_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/customer/home/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsService {
  final ApiClient apiClient = ApiClient();

  Future<String?> _getToken() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString('auth_token');
  }

  Future<ProductDetails> getProductDetails(String productId) async {
    try {
      final token = await _getToken();
      
      log('Fetching product details for ID: $productId');

      final response = await apiClient.get(
        '/product/details',
        queryParams: {'id': productId},
        token: token,
      );

      log('Product Details Response Status: ${response.statusCode}');
      log('Product Details Response Body: ${response.body}');

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        log('Product details fetched successfully');
        return ProductDetails.fromJson(data['data']);
      } else {
        log('Product details error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to fetch product details');
      }
    } catch (e) {
      log('Product details service error: $e');
      throw Exception('Failed to fetch product details: $e');
    }
  }
}
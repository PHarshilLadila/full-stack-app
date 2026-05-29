// lib/features/seller/home/service/product_service.dart
import 'dart:convert';
import 'dart:developer';
import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/seller/home/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final ApiClient apiClient = ApiClient();

  Future<String?> _getToken() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString('auth_token');
  }

  // ONLY METHOD: Get seller products
  Future<SellerProductResponse> getSellerProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final queryParams = {'page': page, 'limit': limit};

      log('Fetching seller products with params: $queryParams');

      final response = await apiClient.get(
        '/product/seller_products',
        queryParams: queryParams,
        token: token,
      );

      log('Seller Products Response Status: ${response.statusCode}');
      log('Seller Products Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        log('Seller products fetched successfully');
        return SellerProductResponse.fromJson(data);
      } else {
        log('Seller products fetch error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to fetch seller products');
      }
    } catch (e) {
      log('Seller products service error: $e');
      throw Exception('Failed to fetch seller products: $e');
    }
  }
}

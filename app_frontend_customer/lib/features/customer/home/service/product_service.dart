import 'dart:convert';
import 'dart:developer'; 
import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/customer/home/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final ApiClient apiClient = ApiClient();

  Future<String?> _getToken() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString('auth_token');
  }

  Future<ProductResponse> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final queryParams = {
        'page': page,
        'limit': limit,
        if (category != null && category.isNotEmpty) 'category': category,
        if (searchQuery != null && searchQuery.isNotEmpty)
          'search': searchQuery,
      };

      log('Fetching products with params: $queryParams');

      final response = await apiClient.get(
        '/product/list',
        queryParams: queryParams,
        token: token,
      );

      log('Products Response Status: ${response.statusCode}');
      log('Products Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log('Products fetched successfully');
        return ProductResponse.fromJson(data);
      } else {
        log('Products fetch error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      log('Products service error: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<ProductResponse> getProductsByCategory(String category) async {
    return await getProducts(category: category);
  }

  Future<ProductResponse> searchProducts(String query) async {
    return await getProducts(searchQuery: query);
  }
}

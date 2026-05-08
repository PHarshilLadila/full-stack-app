import 'dart:convert';
import 'dart:developer';

import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final ApiClient apiClient = ApiClient();

  Future<List<ProductModel>> fetchSellerProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('auth_token');

      final response = await apiClient.get(
        '/product/seller_products',
        token: token,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final List products = data['data'];

        return products.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> addProduct({required Map<String, dynamic> body}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('auth_token');

      final response = await apiClient.postWithParam(
        '/product/add',
        body,
        token: token,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return data['message'] ?? 'Product added successfully';
      } else {
        throw Exception(data['message'] ?? 'Failed to add product');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<ProductModel> fetchProductDetails(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      log("Fetching product details for ID: $productId");
      final response = await apiClient.get(
        '/product/details',
        queryParams: {'id': productId},
        token: token,
      );

      log("Product Details Response Status: ${response.statusCode}");
      log("Product Details Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final productData = data['data'];
        log("Product details fetched successfully");
        return ProductModel.fromJson(productData);
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch product details');
      }
    } catch (e) {
      log("Fetch Product Details Error: $e");
      throw Exception(e.toString());
    }
  }

}

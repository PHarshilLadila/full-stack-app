import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:app_frontend/core/network/api_client.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final ApiClient apiClient = ApiClient();
  final String baseUrl = 'https://full-stack-app-4vxu.onrender.com';

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

  Future<String> addProductWithImages({
    required Map<String, dynamic> body,
    required File mainBannerImage,
    required List<File> multipleImages,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      log('Token: $token');
      log('Main Banner Image Path: ${mainBannerImage.path}');
      log('Multiple Images Count: ${multipleImages.length}');
      for (int i = 0; i < multipleImages.length; i++) {
        log('Multiple Image $i Path: ${multipleImages[i].path}');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/product/add'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add text fields
      body.forEach((key, value) {
        if (value is List) {
          // Handle lists (like tags) - send as comma-separated string
          if (value.isNotEmpty) {
            request.fields[key] = value.join(',');
          }
        } else if (value is Map) {
          // Handle maps (like specifications)
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      log('Request Fields: ${request.fields}');

      // Add main banner image
      request.files.add(
        await http.MultipartFile.fromPath(
          'mainBannerImage',
          mainBannerImage.path,
        ),
      );

      // Add multiple images - IMPORTANT: Use same field name for all
      for (int i = 0; i < multipleImages.length; i++) {
        final imageFile = multipleImages[i];
        request.files.add(
          await http.MultipartFile.fromPath(
            'multipleImages[$i]', // Indexed field names
            imageFile.path,
          ),
        );
      }

      log('Total files being uploaded: ${request.files.length}');
      log('Files: ${request.files.map((f) => f.field)}');

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      log('Response status: ${response.statusCode}');
      log('Response body: $responseBody');

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (data['success'] == true) {
          return data['message'] ?? 'Product added successfully';
        } else {
          throw Exception(data['message'] ?? 'Failed to add product');
        }
      } else {
        throw Exception(
          data['message'] ??
              'Failed to add product (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      log('Add product with images error: $e');
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

// lib/service/customer_web_service.dart
import 'dart:convert';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/flash_deals/flash_deals_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_details/product_details_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_review/product_reviews_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/trending_products/trending_products_model.dart';

import 'package:http/http.dart' as http;
import '../features/customer/customer_web/models/product_model.dart';
import '../features/customer/customer_web/bloc/categories/categories_model.dart';
import '../features/customer/customer_web/bloc/featured_products/featured_products_model.dart';

class CustomerWebService {
  static const String baseUrl = 'http://localhost:8080';
  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhMDQyMDYwMzUwNTM0NzU0N2Y0YTJlNyIsInJvbGUiOiJzZWxsZXIiLCJpYXQiOjE3Nzk5NTQxMjQsImV4cCI6MTc4MDU1ODkyNH0.9rY4AtwkL-u-oLOGjF7JepOQDSrCHF7zvR2NX-SzJMc';

  Map<String, String> getHeaders() {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Get all products
  Future<ProductListResponse> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/list'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return ProductListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get categories by extracting from products
  Future<CategoryResponse> getCategories() async {
    try {
      final productsResponse = await getAllProducts();
      final products = productsResponse.data;

      final Map<String, Set<String>> categoryMap = {};
      final Map<String, int> productCountMap = {};

      for (var product in products) {
        final category = product.category;
        final subCategory = product.subCategory;

        if (!categoryMap.containsKey(category)) {
          categoryMap[category] = {};
          productCountMap[category] = 0;
        }

        categoryMap[category]?.add(subCategory);
        productCountMap[category] = (productCountMap[category] ?? 0) + 1;
      }

      final categoriesList =
          categoryMap.entries.map((entry) {
            return CategoryData(
              name: entry.key,
              subCategories: entry.value.toList(),
              productCount: productCountMap[entry.key] ?? 0,
            );
          }).toList();

      return CategoryResponse(
        message: 'Categories fetched successfully',
        data: categoriesList,
        totalCategories: categoriesList.length,
      );
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  // Get products by category
  Future<ProductListResponse> getProductsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/product/list?category=${Uri.encodeComponent(category)}',
        ),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return ProductListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load products by category');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get products by subcategory
  Future<ProductListResponse> getProductsBySubCategory(
    String subCategory,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/product/list?subCategory=${Uri.encodeComponent(subCategory)}',
        ),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return ProductListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load products by subcategory');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get products by category and subcategory
  Future<ProductListResponse> getProductsByCategoryAndSubCategory(
    String category,
    String subCategory,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/product/list?category=${Uri.encodeComponent(category)}&subCategory=${Uri.encodeComponent(subCategory)}',
        ),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return ProductListResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get featured products
  Future<FeaturedProductsResponse> getFeaturedProducts() async {
    try {
      final allProductsResponse = await getAllProducts();
      final featuredProducts =
          allProductsResponse.data
              .where((product) => product.isFeatured)
              .toList();

      return FeaturedProductsResponse(
        message: 'Featured products fetched successfully',
        data: featuredProducts,
        pagination: allProductsResponse.pagination,
      );
    } catch (e) {
      throw Exception('Failed to load featured products: $e');
    }
  }

  Future<FlashDealsResponse> getFlashDeals() async {
    try {
      final allProductsResponse = await getAllProducts();
      final saleProducts =
          allProductsResponse.data.where((product) => product.isSale).toList();

      return FlashDealsResponse(
        message: 'Flash deals fetched successfully',
        data: saleProducts,
        pagination: allProductsResponse.pagination,
      );
    } catch (e) {
      throw Exception('Failed to load flash deals: $e');
    }
  }

  Future<TrendingProductsResponse> getTrendingProducts() async {
    try {
      final allProductsResponse = await getAllProducts();
      final trendingProducts =
          allProductsResponse.data
              .where((product) => product.isTrending)
              .toList();

      return TrendingProductsResponse(
        message: 'Trending products fetched successfully',
        data: trendingProducts,
        pagination: allProductsResponse.pagination,
      );
    } catch (e) {
      throw Exception('Failed to load trending products: $e');
    }
  }
  // lib/service/customer_web_service.dart - Add these methods

  // Get product details by ID
  Future<ProductDetailsResponse> getProductDetails(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/details?id=$productId'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return ProductDetailsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load product details: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get product reviews by product ID
  Future<ProductReviewsResponse> getProductReviews(String productId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/review/list?productId=$productId'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        return ProductReviewsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load product reviews: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

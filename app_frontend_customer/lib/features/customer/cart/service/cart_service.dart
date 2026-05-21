import 'dart:convert';
import 'dart:developer';
import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/customer/cart/model/cart_model.dart';

class CartService {
  final ApiClient _apiClient = ApiClient();

  // Add item to cart
  Future<AddToCartResponse> addToCart({
    required String productId,
    required int quantity,
    required String token,
  }) async {
    try {
      final response = await _apiClient.postWithParam('/cart/add', {
        'productId': productId,
        'quantity': quantity,
      }, token: token);

      log('Add to cart response status: ${response.statusCode}');
      log('Add to cart response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return AddToCartResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      log('Add to cart error: $e');
      rethrow;
    }
  }

  // Get current cart
  Future<CartSummary> getCart({required String token}) async {
    try {
      final response = await _apiClient.get('/cart/get', token: token);

      log('Get cart response status: ${response.statusCode}');
      log('Get cart response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return CartSummary.fromJson(jsonData['data']);
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to fetch cart');
        }
      } else {
        throw Exception('Failed to fetch cart: ${response.statusCode}');
      }
    } catch (e) {
      log('Get cart error: $e');
      rethrow;
    }
  }

  // Update cart item quantity
  Future<Map<String, dynamic>> updateCartItem({
    required String productId,
    required int quantity,
    required String token,
  }) async {
    try {
      final response = await _apiClient.put('/cart/update', {
        'productId': productId,
        'quantity': quantity,
      }, token: token);

      log('Update cart response status: ${response.statusCode}');
      log('Update cart response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return {
          'success': jsonData['success'] ?? false,
          'message': jsonData['message'] ?? '',
        };
      } else {
        throw Exception('Failed to update cart: ${response.statusCode}');
      }
    } catch (e) {
      log('Update cart error: $e');
      rethrow;
    }
  }

  // Remove item from cart (set quantity to 0)
  Future<Map<String, dynamic>> removeFromCart({
    required String productId,
    required String token,
  }) async {
    return await updateCartItem(
      productId: productId,
      quantity: 0,
      token: token,
    );
  }
}

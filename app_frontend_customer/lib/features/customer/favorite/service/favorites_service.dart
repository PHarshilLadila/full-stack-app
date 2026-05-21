// lib/features/customer/favorites/service/favorites_service.dart

import 'dart:convert';
import 'dart:developer';
import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/customer/favorite/model/favorites_model.dart';
 import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  final ApiClient apiClient = ApiClient();

  Future<String?> _getToken() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString('auth_token');
  }

  Future<FavoritesResponse> getFavorites({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final queryParams = {
        'page': page,
        'limit': limit,
      };

      log('Fetching favorites with params: $queryParams');

      final response = await apiClient.get(
        '/favorites/list',
        queryParams: queryParams,
        token: token,
      );

      log('Favorites Response Status: ${response.statusCode}');
      log('Favorites Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log('Favorites fetched successfully');
        return FavoritesResponse.fromJson(data);
      } else {
        log('Favorites fetch error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to fetch favorites');
      }
    } catch (e) {
      log('Favorites service error: $e');
      throw Exception('Failed to fetch favorites: $e');
    }
  }

  Future<AddFavoriteResponse> addToFavorites(String productId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      log('Adding product $productId to favorites');

      final response = await apiClient.postWithParam(
        '/favorites/add',
        {'productId': productId},
        token: token,
      );

      log('Add Favorite Response Status: ${response.statusCode}');
      log('Add Favorite Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Product added to favorites successfully');
        return AddFavoriteResponse.fromJson(data);
      } else {
        log('Add favorite error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to add to favorites');
      }
    } catch (e) {
      log('Add favorite service error: $e');
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<RemoveFavoriteResponse> removeFromFavorites(String productId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      log('Removing product $productId from favorites');

      final response = await apiClient.delete(
        '/favorites/remove',
        body: {'productId': productId},
        token: token,
      );

      log('Remove Favorite Response Status: ${response.statusCode}');
      log('Remove Favorite Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        log('Product removed from favorites successfully');
        return RemoveFavoriteResponse.fromJson(data);
      } else {
        log('Remove favorite error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to remove from favorites');
      }
    } catch (e) {
      log('Remove favorite service error: $e');
      throw Exception('Failed to remove from favorites: $e');
    }
  }
}
// lib/features/customer/review/service/review_service.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_frontend_customer/core/network/api_client.dart';
import 'package:app_frontend_customer/features/customer/reviews/model/review_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ReviewService {
  final ApiClient _apiClient = ApiClient();

  // Helper method to get content type based on file extension
  MediaType _getContentType(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    switch (extension) {
      case 'webp':
        return MediaType('image', 'webp');
      case 'png':
        return MediaType('image', 'png');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'gif':
        return MediaType('image', 'gif');
      default:
        return MediaType('image', 'jpeg');
    }
  }

  Future<ProductReviewsResponse> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
    int? rating,
  }) async {
    try {
      final queryParams = {
        'productId': productId,
        'page': page.toString(),
        'limit': limit.toString(),
        if (rating != null) 'rating': rating.toString(),
      };

      log('Fetching reviews for product: $productId');
      log('Query params: $queryParams');

      final response = await _apiClient.get(
        '/product/review/list',
        queryParams: queryParams,
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ProductReviewsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load reviews: ${response.body}');
      }
    } catch (e) {
      log('Error in getProductReviews: $e');
      rethrow;
    }
  }

  Future<AddReviewResponse> addReview({
    required String productId,
    required int rating,
    required String comment,
    required String token,
    List<File>? images,
  }) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/product/review/add');

    final request = http.MultipartRequest('POST', uri);

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';

    // Add text fields
    request.fields['productId'] = productId;
    request.fields['rating'] = rating.toString();
    request.fields['comment'] = comment;

    // Add image files if any
    if (images != null && images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final contentType = _getContentType(file);
        final multipartFile = await http.MultipartFile.fromPath(
          'images',
          file.path,
          contentType: contentType,
        );
        request.files.add(multipartFile);
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return AddReviewResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add review: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> deleteReview({
    required String reviewId,
    required String token,
  }) async {
    final response = await _apiClient.delete(
      '/product/review/delete',
      body: {'reviewId': reviewId},
      token: token,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete review: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateReview({
    required String reviewId,
    required int rating,
    required String comment,
    required String token,
    List<String>? existingImages,
    List<File>? newImages,
  }) async {
    // For update, we'll use multipart as well
    final uri = Uri.parse('${ApiClient.baseUrl}/product/review/update');

    final request = http.MultipartRequest('PUT', uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['reviewId'] = reviewId;
    request.fields['rating'] = rating.toString();
    request.fields['comment'] = comment;

    if (existingImages != null && existingImages.isNotEmpty) {
      request.fields['existingImages'] = jsonEncode(existingImages);
    }

    if (newImages != null && newImages.isNotEmpty) {
      for (int i = 0; i < newImages.length; i++) {
        final file = newImages[i];
        final contentType = _getContentType(file);
        final multipartFile = await http.MultipartFile.fromPath(
          'newImages',
          file.path,
          contentType: contentType,
        );
        request.files.add(multipartFile);
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update review: ${response.body}');
    }
  }
}

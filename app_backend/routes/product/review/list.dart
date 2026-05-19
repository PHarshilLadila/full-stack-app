// ignore_for_file: avoid_print, avoid_dynamic_calls, inference_failure_on_collection_literal, lines_longer_than_80_chars, prefer_final_locals

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/db/mongo.dart';

/// API Endpoint: GET /product/review/list?productId=xxx&page=1&limit=10
///
/// Query Parameters:
/// - productId (required): Product ID
/// - page (optional): Page number, default 1
/// - limit (optional): Items per page, default 10
/// - rating (optional): Filter by rating (1-5)
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/review/list API HIT');

  // Only GET method allowed
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  final queryParams = context.request.uri.queryParameters;
  final productId = queryParams['productId'];

  // Validate product ID
  if (productId == null || productId.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'message': 'Product ID is required'},
    );
  }

  try {
    // Check if product exists
    final product = await MongoService.products!.findOne({
      '_id': ObjectId.parse(productId),
    });

    if (product == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Product not found'},
      );
    }

    // Pagination parameters
    final page = int.tryParse(queryParams['page'] ?? '1') ?? 1;
    final limit = int.tryParse(queryParams['limit'] ?? '10') ?? 10;
    final skip = (page - 1) * limit;

    // Filter by rating (optional)
    final ratingFilter = int.tryParse(queryParams['rating'] ?? '');

    // Build filter
    final filter = <String, dynamic>{'productId': productId};

    if (ratingFilter != null && ratingFilter >= 1 && ratingFilter <= 5) {
      filter['rating'] = ratingFilter;
    }

    // Get total count
    final totalCount = await MongoService.reviews!.count(filter);

    // Get all reviews first (since mongo_dart doesn't support sort/skip/limit on stream directly)
    final allReviews = await MongoService.reviews!.find(filter).toList();

    // Sort manually (newest first)
    allReviews.sort((a, b) {
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });

    // Apply pagination
    final reviews = allReviews.skip(skip).take(limit).toList();

    // Transform reviews
    final transformedReviews =
        reviews.map((review) {
          return {
            '_id': (review['_id'] as ObjectId).oid,
            'userId': review['userId']?.toString(),
            'userName': review['userName']?.toString() ?? '',
            'userAvatar': review['userAvatar']?.toString() ?? '',
            'rating': review['rating'] as int? ?? 0,
            'comment': review['comment']?.toString() ?? '',
            'images': review['images'] as List? ?? [],
            'isVerifiedPurchase':
                review['isVerifiedPurchase'] as bool? ?? false,
            'createdAt':
                review['createdAt'] is DateTime
                    ? (review['createdAt'] as DateTime).toIso8601String()
                    : null,
            'updatedAt':
                review['updatedAt'] is DateTime
                    ? (review['updatedAt'] as DateTime).toIso8601String()
                    : null,
          };
        }).toList();

    // Get rating distribution
    final ratingDistribution = await _getRatingDistribution(productId);

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Reviews fetched successfully',
        'data': {
          'productId': productId,
          'productName': product['productName']?.toString(),
          'averageRating': product['rating']?.toDouble() ?? 0.0,
          'totalReviews': totalCount,
          'ratingDistribution': ratingDistribution,
          'reviews': transformedReviews,
          'pagination': {
            'currentPage': page,
            'totalPages': (totalCount / limit).ceil(),
            'totalItems': totalCount,
            'itemsPerPage': limit,
          },
        },
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Failed to fetch reviews: $e'},
    );
  }
}

/// Get rating distribution for a product
Future<Map<int, int>> _getRatingDistribution(String productId) async {
  final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  try {
    for (int i = 1; i <= 5; i++) {
      final count = await MongoService.reviews!.count({
        'productId': productId,
        'rating': i,
      });
      distribution[i] = count;
    }
  } catch (e) {
    print('Error getting rating distribution: $e');
  }

  return distribution;
}

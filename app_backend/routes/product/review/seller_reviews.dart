// ignore_for_file: avoid_print, avoid_dynamic_calls, inference_failure_on_collection_literal, lines_longer_than_80_chars, prefer_final_locals

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// API Endpoint: GET /product/review/seller_reviews?page=1&limit=10
///
/// Returns all reviews for all products of a seller
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/review/seller_reviews API HIT');

  // Only GET method allowed
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  // Auth header validation
  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'success': false, 'message': 'Token missing or invalid'},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    // Verify JWT
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    final userId = jwt.payload['id'].toString();
    final userRole = jwt.payload['role']?.toString() ?? 'customer';

    // Only sellers can view their product reviews
    if (userRole != 'seller') {
      return Response.json(
        statusCode: 403,
        body: {
          'success': false,
          'message': 'Only sellers can view their product reviews',
        },
      );
    }

    // Check if seller exists
    final seller = await MongoService.users!.findOne({
      '_id': ObjectId.parse(userId),
    });

    if (seller == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Seller not found'},
      );
    }

    // Get pagination parameters
    final queryParams = context.request.uri.queryParameters;
    final page = int.tryParse(queryParams['page'] ?? '1') ?? 1;
    final limit = int.tryParse(queryParams['limit'] ?? '20') ?? 20;
    final skip = (page - 1) * limit;

    // Get all products of this seller
    final sellerProducts =
        await MongoService.products!.find({'sellerId': userId}).toList();

    if (sellerProducts.isEmpty) {
      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'No products found for this seller',
          'data': {
            'totalReviews': 0,
            'averageRating': 0,
            'reviews': [],
            'pagination': {
              'currentPage': page,
              'totalPages': 0,
              'totalItems': 0,
              'itemsPerPage': limit,
            },
          },
        },
      );
    }

    final productIds =
        sellerProducts.map((p) => (p['_id'] as ObjectId).oid).toList();

    // Get all reviews for seller's products
    final allReviews =
        await MongoService.reviews!.find({
          'productId': {'\$in': productIds},
        }).toList();

    // Sort manually (newest first)
    allReviews.sort((a, b) {
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });

    final totalCount = allReviews.length;

    // Apply pagination
    final paginatedReviews = allReviews.skip(skip).take(limit).toList();

    // Transform reviews with product information
    final transformedReviews =
        paginatedReviews.map((review) {
          // Find product details
          final product = sellerProducts.firstWhere(
            (p) => (p['_id'] as ObjectId).oid == review['productId'],
            orElse: () => {},
          );

          return {
            '_id': (review['_id'] as ObjectId).oid,
            'productId': review['productId']?.toString(),
            'productName':
                product['productName']?.toString() ?? 'Unknown Product',
            'productMainImage': product['mainBannerImage']?.toString() ?? '',
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
          };
        }).toList();

    // Calculate overall rating for seller
    double totalRating = 0;
    for (final review in allReviews) {
      totalRating += (review['rating'] as int).toDouble();
    }
    final averageRating =
        totalCount > 0
            ? double.parse((totalRating / totalCount).toStringAsFixed(1))
            : 0.0;

    // Get rating distribution for seller
    final ratingDistribution = await _getSellerRatingDistribution(productIds);

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Seller reviews fetched successfully',
        'data': {
          'sellerId': userId,
          'sellerName':
              seller['fullName']?.toString() ??
              seller['name']?.toString() ??
              'Seller',
          'totalProducts': sellerProducts.length,
          'totalReviews': totalCount,
          'averageRating': averageRating,
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
      body: {'success': false, 'message': 'Failed to fetch seller reviews: $e'},
    );
  }
}

/// Get rating distribution for seller's products
Future<Map<int, int>> _getSellerRatingDistribution(
  List<String> productIds,
) async {
  final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  try {
    for (int i = 1; i <= 5; i++) {
      final count = await MongoService.reviews!.count({
        'productId': {'\$in': productIds},
        'rating': i,
      });
      distribution[i] = count;
    }
  } catch (e) {
    print('Error getting seller rating distribution: $e');
  }

  return distribution;
}

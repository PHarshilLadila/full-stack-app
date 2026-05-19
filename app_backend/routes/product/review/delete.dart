// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// API Endpoint: DELETE /product/review/delete
///
/// Request Body:
/// {
///   "reviewId": "review_object_id"
/// }
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/review/delete API HIT');

  // Only DELETE method allowed
  if (context.request.method != HttpMethod.delete) {
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

    // Parse request body
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final reviewId = body['reviewId']?.toString();

    if (reviewId == null || reviewId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Review ID is required'},
      );
    }

    // Find the review
    final review = await MongoService.reviews!.findOne({
      '_id': ObjectId.parse(reviewId),
    });

    if (review == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Review not found'},
      );
    }

    // Check authorization - only review owner or admin can delete
    final reviewUserId = review['userId']?.toString();

    if (reviewUserId != userId && userRole != 'admin') {
      return Response.json(
        statusCode: 403,
        body: {
          'success': false,
          'message': 'You are not authorized to delete this review',
        },
      );
    }

    final productId = review['productId']?.toString();

    // Delete the review
    final result = await MongoService.reviews!.remove({
      '_id': ObjectId.parse(reviewId),
    });

    if (result == null || result['n'] == 0) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to delete review'},
      );
    }

    // Update product rating
    if (productId != null) {
      await _updateProductRatingAfterDelete(productId);
    }

    print('✅ Review deleted successfully: $reviewId');

    return Response.json(
      statusCode: 200,
      body: {'success': true, 'message': 'Review deleted successfully'},
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Failed to delete review: $e'},
    );
  }
}

/// Update product rating after review deletion
Future<void> _updateProductRatingAfterDelete(String productId) async {
  try {
    final reviews =
        await MongoService.reviews!.find({'productId': productId}).toList();

    if (reviews.isEmpty) {
      // No reviews left, reset rating to 0
      await MongoService.products!.updateOne(
        {'_id': ObjectId.parse(productId)},
        {
          r'$set': {
            'rating': 0.0,
            'totalReviews': 0,
            'updatedAt': DateTime.now(),
          },
        },
      );
      return;
    }

    // Calculate new average
    double totalRating = 0;
    for (final review in reviews) {
      totalRating += (review['rating'] as int).toDouble();
    }
    final averageRating = totalRating / reviews.length;
    final roundedRating = double.parse(averageRating.toStringAsFixed(1));

    // Update product
    await MongoService.products!.updateOne(
      {'_id': ObjectId.parse(productId)},
      {
        r'$set': {
          'rating': roundedRating,
          'totalReviews': reviews.length,
          'updatedAt': DateTime.now(),
        },
      },
    );

    print('✅ Product rating updated after delete: $roundedRating');
  } catch (e) {
    print('❌ Error updating product rating after delete: $e');
  }
}

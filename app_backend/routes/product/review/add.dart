// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// API Endpoint: POST /product/review/add
///
/// Request Body:
/// {
///   "productId": "product_object_id",
///   "rating": 5,
///   "comment": "Great product!",
///   "images": ["image_url_1", "image_url_2"]  // optional
/// }
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/review/add API HIT');

  // Check method
  if (context.request.method != HttpMethod.post) {
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

    // Only customers can add reviews
    if (userRole != 'customer') {
      return Response.json(
        statusCode: 403,
        body: {'success': false, 'message': 'Only customers can add reviews'},
      );
    }

    // Parse request body
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;

    final productId = body['productId']?.toString();
    final rating = body['rating'] as int?;
    final comment = body['comment']?.toString();
    final images =
        (body['images'] as List?)?.map((e) => e.toString()).toList() ?? [];

    // Validate required fields
    if (productId == null || productId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product ID is required'},
      );
    }

    if (rating == null || rating < 1 || rating > 5) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Rating must be between 1 and 5'},
      );
    }

    if (comment == null || comment.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Comment is required'},
      );
    }

    // Check if product exists and is active
    final product = await MongoService.products!.findOne({
      '_id': ObjectId.parse(productId),
      'isActive': true,
    });

    if (product == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Product not found'},
      );
    }

    // Check if user has already reviewed this product
    final existingReview = await MongoService.reviews!.findOne({
      'productId': productId,
      'userId': userId,
    });

    if (existingReview != null) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'You have already reviewed this product',
        },
      );
    }

    // Get user details
    final user = await MongoService.users!.findOne({
      '_id': ObjectId.parse(userId),
    });

    if (user == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'User not found'},
      );
    }

    final userName =
        user['fullName']?.toString() ?? user['name']?.toString() ?? 'User';
    final userAvatar = user['avatar']?.toString() ?? '';

    // Check if user has purchased this product (optional - for verified purchase)
    // This depends on your orders collection structure
    bool isVerifiedPurchase = false;
    if (MongoService.orders != null) {
      final order = await MongoService.orders!.findOne({
        'userId': userId,
        'orderStatus': 'delivered',
        'items.productId': productId,
      });
      isVerifiedPurchase = order != null;
    }

    // Create review
    final reviewData = {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'images': images,
      'isVerifiedPurchase': isVerifiedPurchase,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    final result = await MongoService.reviews!.insertOne(reviewData);

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to save review'},
      );
    }

    // Update product rating and total reviews
    await _updateProductRating(productId);

    print(
      '✅ Review added successfully for product: $productId by user: $userId',
    );

    return Response.json(
      statusCode: 201,
      body: {
        'success': true,
        'message': 'Review added successfully',
        'data': {
          'reviewId': (result.document!['_id'] as ObjectId).oid,
          'productId': productId,
          'rating': rating,
        },
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

/// Helper function to update product rating and total reviews
Future<void> _updateProductRating(String productId) async {
  try {
    // Get all reviews for this product
    final reviews =
        await MongoService.reviews!.find({'productId': productId}).toList();

    if (reviews.isEmpty) return;

    // Calculate average rating
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

    print('✅ Product rating updated: $roundedRating ($totalRating total)');
  } catch (e) {
    print('❌ Error updating product rating: $e');
  }
}

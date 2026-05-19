// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// POST /favorites/add
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /favorites/add API HIT');

  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'success': false, 'message': 'Token missing'},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    final userId = jwt.payload['id'].toString();

    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final productId = body['productId']?.toString();

    if (productId == null || productId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product ID required'},
      );
    }

    // Check if already in favorites
    final existing = await MongoService.favorites!.findOne({
      'userId': userId,
      'productId': productId,
    });

    if (existing != null) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product already in favorites'},
      );
    }

    // Get product details
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

    final favoriteData = {
      'userId': userId,
      'productId': productId,
      'productName': product['productName'].toString(),
      'productImage': product['mainBannerImage'].toString(),
      'price': (product['price'] as num).toDouble(),
      'discountPrice':
          product['discountPrice'] != null
              ? (product['discountPrice'] as num).toDouble()
              : null,
      'sellerId': product['sellerId'].toString(),
      'sellerName': product['sellerName'].toString(),
      'rating': (product['rating'] as num?)?.toDouble() ?? 0.0,
      'createdAt': DateTime.now(),
    };

    final result = await MongoService.favorites!.insertOne(favoriteData);

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to add to favorites'},
      );
    }

    return Response.json(
      statusCode: 201,
      body: {'success': true, 'message': 'Product added to favorites'},
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

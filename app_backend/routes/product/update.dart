// ignore_for_file: avoid_print, avoid_dynamic_calls, avoid_redundant_argument_values, lines_longer_than_80_chars

import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/update API HIT');

  /// AUTH HEADER
  final authHeader = context.request.headers['authorization'];

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'success': false, 'message': 'Token missing'},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    /// VERIFY JWT
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));

    final userId = jwt.payload['id'].toString();

    final userRole = jwt.payload['role']?.toString() ?? 'customer';

    /// SELLER CHECK
    if (userRole != 'seller') {
      return Response.json(
        statusCode: 403,
        body: {'success': false, 'message': 'Only sellers can update products'},
      );
    }

    /// BODY
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;

    final productId = body['productId']?.toString();

    if (productId == null || productId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product ID required'},
      );
    }

    /// FIND PRODUCT
    final existingProduct = await MongoService.products!.findOne({
      '_id': ObjectId.parse(productId),
      'sellerId': userId,
    });

    if (existingProduct == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Product not found'},
      );
    }

    /// UPDATE DATA
    final updateData = <String, dynamic>{};

    if (body['productName'] != null) {
      updateData['productName'] = body['productName'].toString();
    }

    if (body['mainBannerImage'] != null) {
      updateData['mainBannerImage'] = body['mainBannerImage'].toString();
    }

    if (body['multipleImages'] != null && body['multipleImages'] is List) {
      updateData['multipleImages'] =
          (body['multipleImages'] as List).map((e) => e.toString()).toList();
    }

    if (body['price'] != null) {
      updateData['price'] = (body['price'] as num).toDouble();
    }

    if (body['discountPrice'] != null) {
      updateData['discountPrice'] = (body['discountPrice'] as num).toDouble();
    }

    if (body['stock'] != null) {
      final stock = (body['stock'] as num).toInt();

      updateData['stock'] = stock;

      updateData['stockAvailable'] = stock > 0;
    }

    if (body['category'] != null) {
      updateData['category'] = body['category'].toString();
    }

    if (body['subCategory'] != null) {
      updateData['subCategory'] = body['subCategory'].toString();
    }

    if (body['tags'] != null && body['tags'] is List) {
      updateData['tags'] =
          (body['tags'] as List).map((e) => e.toString()).toList();
    }

    if (body['shortDescription'] != null) {
      updateData['shortDescription'] = body['shortDescription'].toString();
    }

    if (body['detailedDescription'] != null) {
      updateData['detailedDescription'] =
          body['detailedDescription'].toString();
    }

    if (body['specifications'] != null && body['specifications'] is Map) {
      updateData['specifications'] = Map<String, dynamic>.from(
        body['specifications'] as Map,
      );
    }

    if (body['isActive'] != null) {
      updateData['isActive'] = body['isActive'] as bool;
    }

    /// UPDATED DATE
    updateData['updatedAt'] = DateTime.now();

    /// EMPTY CHECK
    if (updateData.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'No fields to update'},
      );
    }

    /// UPDATE PRODUCT
    final result = await MongoService.products!.updateOne(
      {'_id': ObjectId.parse(productId)},
      {r'$set': updateData},
    );

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to update product'},
      );
    }

    return Response.json(
      statusCode: 200,
      body: {'success': true, 'message': 'Product updated successfully'},
    );
  } catch (e) {
    print('❌ ERROR: $e');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': e.toString()},
    );
  }
}

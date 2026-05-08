// ignore_for_file: avoid_print, avoid_dynamic_calls

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/delete API HIT');

  if (context.request.method != HttpMethod.delete) {
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(statusCode: 401, body: {'error': 'Token missing'});
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    final userId = jwt.payload['id'] as String;
    final userRole = jwt.payload['role'] as String? ?? 'customer';

    if (userRole != 'seller') {
      return Response.json(
        statusCode: 403,
        body: {'error': 'Only sellers can delete products'},
      );
    }

    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final productId = body['productId'];

    if (productId == null) {
      return Response.json(body: {'error': 'Product ID required'});
    }

    // Verify product belongs to this seller
    final existingProduct = await MongoService.products!.findOne({
      '_id': ObjectId.parse(productId.toString()),
      'sellerId': userId,
    });

    if (existingProduct == null) {
      return Response.json(
        statusCode: 404,
        body: {'error': 'Product not found or unauthorized'},
      );
    }

    // HARD DELETE - Permanently remove from database
    final result = await MongoService.products!.remove({
      '_id': ObjectId.parse(productId.toString()),
    });

    if (result == null || result['n'] == 0) {
      return Response.json(body: {'error': 'Delete failed'});
    }

    print('✅ Product permanently deleted: $productId');

    return Response.json(
      body: {'message': 'Product permanently deleted successfully'},
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'error': 'Failed to delete product: $e'},
    );
  }
}

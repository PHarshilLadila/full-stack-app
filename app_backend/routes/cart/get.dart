// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// GET /cart/get
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /cart/get API HIT');

  if (context.request.method != HttpMethod.get) {
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

    var cart = await MongoService.carts!.findOne({'userId': userId});

    if (cart == null) {
      // Return empty cart
      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'Cart is empty',
          'data': {
            'items': [],
            'totalAmount': 0,
            'discountAmount': 0,
            'finalAmount': 0,
            'itemCount': 0,
          },
        },
      );
    }

    final items = (cart['items'] as List?) ?? [];

    // Transform items and check stock availability
    final transformedItems = [];
    int itemCount = 0;

    for (final item in items) {
      // Get productId as String
      final productId = item['productId']?.toString();

      if (productId == null || productId.isEmpty) {
        continue;
      }

      // Check if product still exists and has stock
      dynamic product;
      try {
        product = await MongoService.products!.findOne({
          '_id': ObjectId.parse(productId),
        });
      } catch (e) {
        print('Error parsing productId: $productId, Error: $e');
        product = null;
      }

      final isAvailable =
          product != null && (product['stock'] as int? ?? 0) > 0;
      final availableStock =
          product != null ? (product['stock'] as int? ?? 0) : 0;

      // Calculate total price safely
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final discountPrice =
          item['discountPrice'] != null
              ? (item['discountPrice'] as num).toDouble()
              : null;
      final quantity = (item['quantity'] as int?) ?? 1;
      final effectivePrice = discountPrice ?? price;

      transformedItems.add({
        'productId': productId,
        'productName': item['productName']?.toString() ?? '',
        'productImage': item['productImage']?.toString() ?? '',
        'price': price,
        'discountPrice': discountPrice,
        'quantity': quantity,
        'sellerId': item['sellerId']?.toString() ?? '',
        'sellerName': item['sellerName']?.toString() ?? '',
        'isAvailable': isAvailable,
        'availableStock': availableStock,
        'totalPrice': effectivePrice * quantity,
      });

      itemCount += quantity;
    }

    // Get totals safely
    final totalAmount = (cart['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final discountAmount = (cart['discountAmount'] as num?)?.toDouble() ?? 0.0;
    final finalAmount = (cart['finalAmount'] as num?)?.toDouble() ?? 0.0;

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Cart fetched successfully',
        'data': {
          'items': transformedItems,
          'totalAmount': totalAmount,
          'discountAmount': discountAmount,
          'finalAmount': finalAmount,
          'itemCount': itemCount,
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

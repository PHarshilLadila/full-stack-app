// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// POST /cart/add
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /cart/add API HIT');

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
    final quantity = body['quantity'] as int? ?? 1;

    if (productId == null || productId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product ID required'},
      );
    }

    if (quantity < 1) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Quantity must be at least 1'},
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

    // Check stock
    final stock = product['stock'] as int? ?? 0;
    if (stock < quantity) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Insufficient stock available'},
      );
    }

    // Get or create cart
    var cart = await MongoService.carts!.findOne({'userId': userId});

    if (cart == null) {
      // Create new cart
      cart = {
        'userId': userId,
        'items': [],
        'totalAmount': 0.0,
        'discountAmount': 0.0,
        'finalAmount': 0.0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };
      await MongoService.carts!.insertOne(cart);
      cart = await MongoService.carts!.findOne({'userId': userId});
    }

    final items = (cart!['items'] as List?) ?? [];

    // Check if product already in cart
    int existingIndex = -1;
    for (int i = 0; i < items.length; i++) {
      if (items[i]['productId'] == productId) {
        existingIndex = i;
        break;
      }
    }

    final price = (product['price'] as num).toDouble();
    final discountPrice =
        product['discountPrice'] != null
            ? (product['discountPrice'] as num).toDouble()
            : null;
    final effectivePrice = discountPrice ?? price;

    if (existingIndex != -1) {
      // Update quantity
      final newQuantity = (items[existingIndex]['quantity'] as int) + quantity;
      if (stock < newQuantity) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': 'Insufficient stock available'},
        );
      }
      items[existingIndex]['quantity'] = newQuantity;
    } else {
      // Add new item
      items.add({
        'productId': productId,
        'productName': product['productName'].toString(),
        'productImage': product['mainBannerImage'].toString(),
        'price': price,
        'discountPrice': discountPrice,
        'quantity': quantity,
        'sellerId': product['sellerId'].toString(),
        'sellerName': product['sellerName'].toString(),
      });
    }

    // Calculate totals
    double totalAmount = 0;
    double discountAmount = 0;
    for (final item in items) {
      final itemPrice = (item['price'] as num).toDouble();
      final itemDiscount =
          item['discountPrice'] != null
              ? (item['discountPrice'] as num).toDouble()
              : null;
      final itemEffectivePrice = itemDiscount ?? itemPrice;
      final itemQuantity = (item['quantity'] as int);
      totalAmount += itemPrice * itemQuantity;
      discountAmount += (itemPrice - itemEffectivePrice) * itemQuantity;
    }
    final finalAmount = totalAmount - discountAmount;

    // Update cart
    final result = await MongoService.carts!.updateOne(
      {'userId': userId},
      {
        '\$set': {
          'items': items,
          'totalAmount': totalAmount,
          'discountAmount': discountAmount,
          'finalAmount': finalAmount,
          'updatedAt': DateTime.now(),
        },
      },
    );

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to update cart'},
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Product added to cart successfully',
        'data': {
          'productId': productId,
          'quantity': quantity,
          'cartTotal': finalAmount,
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

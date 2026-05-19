// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// PUT /cart/update
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /cart/update API HIT');

  if (context.request.method != HttpMethod.put) {
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
    final quantity = body['quantity'] as int?;

    if (productId == null || productId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product ID required'},
      );
    }

    if (quantity == null || quantity < 0) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Valid quantity required'},
      );
    }

    final cart = await MongoService.carts!.findOne({'userId': userId});
    if (cart == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Cart not found'},
      );
    }

    final items = (cart['items'] as List?) ?? [];

    int itemIndex = -1;
    for (int i = 0; i < items.length; i++) {
      if (items[i]['productId'] == productId) {
        itemIndex = i;
        break;
      }
    }

    if (itemIndex == -1) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Product not found in cart'},
      );
    }

    if (quantity == 0) {
      // Remove item
      items.removeAt(itemIndex);
    } else {
      // Check stock
      final product = await MongoService.products!.findOne({
        '_id': ObjectId.parse(productId),
      });

      if (product != null) {
        final stock = product['stock'] as int? ?? 0;
        if (stock < quantity) {
          return Response.json(
            statusCode: 400,
            body: {'success': false, 'message': 'Insufficient stock available'},
          );
        }
      }

      items[itemIndex]['quantity'] = quantity;
    }

    // Recalculate totals
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
        'message':
            quantity == 0
                ? 'Product removed from cart'
                : 'Cart updated successfully',
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

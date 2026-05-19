// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// PUT /order/update_status
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /order/update_status API HIT');

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
    final userRole = jwt.payload['role']?.toString() ?? 'customer';

    if (userRole != 'seller' && userRole != 'admin') {
      return Response.json(
        statusCode: 403,
        body: {
          'success': false,
          'message': 'Only sellers can update order status',
        },
      );
    }

    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final orderId = body['orderId']?.toString();
    final orderStatus = body['orderStatus']?.toString();
    final trackingId = body['trackingId']?.toString();

    if (orderId == null || orderId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Order ID required'},
      );
    }

    if (orderStatus == null || orderStatus.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Order status required'},
      );
    }

    final validStatuses = [
      'pending',
      'confirmed',
      'shipped',
      'out_for_delivery',
      'delivered',
      'cancelled',
    ];
    if (!validStatuses.contains(orderStatus)) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid order status'},
      );
    }

    final order = await MongoService.orders!.findOne({'orderId': orderId});

    if (order == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Order not found'},
      );
    }

    // Verify seller has permission (if seller, check if order contains their product)
    if (userRole == 'seller') {
      final items = order['items'] as List? ?? [];
      bool hasSellerProduct = false;

      for (final item in items) {
        final itemSellerId = item['sellerId']?.toString();
        if (itemSellerId == userId) {
          hasSellerProduct = true;
          break;
        }
      }

      if (!hasSellerProduct) {
        return Response.json(
          statusCode: 403,
          body: {
            'success': false,
            'message': 'Unauthorized to update this order',
          },
        );
      }
    }

    final updateData = {
      'orderStatus': orderStatus,
      'updatedAt': DateTime.now(),
    };

    if (trackingId != null && trackingId.isNotEmpty) {
      updateData['trackingId'] = trackingId;
    }

    if (orderStatus == 'delivered') {
      updateData['deliveredDate'] = DateTime.now();
      updateData['paymentStatus'] = 'completed';
    }

    if (orderStatus == 'cancelled') {
      updateData['cancelledDate'] = DateTime.now();

      // Restore stock for cancelled order
      final items = order['items'] as List? ?? [];
      for (final item in items) {
        final productIdStr = item['productId']?.toString();
        if (productIdStr == null || productIdStr.isEmpty) {
          print('Warning: Invalid product ID in order $orderId');
          continue;
        }

        try {
          final productObjectId = ObjectId.parse(productIdStr);
          final quantity = item['quantity'] as int? ?? 1;

          await MongoService.products!.updateOne(
            {'_id': productObjectId},
            {
              '\$inc': {'stock': quantity},
            },
          );
        } catch (e) {
          print('Error restoring stock for product $productIdStr: $e');
        }
      }
    }

    final result = await MongoService.orders!.updateOne(
      {'orderId': orderId},
      {'\$set': updateData},
    );

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to update order status'},
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Order status updated successfully',
        'data': {'orderId': orderId, 'orderStatus': orderStatus},
      },
    );
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: ${e.toString()}'},
    );
  }
}

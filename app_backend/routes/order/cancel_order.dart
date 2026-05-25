// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// POST /order/cancel
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /order/cancel API HIT');

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
    final orderId = body['orderId']?.toString();
    final reason = body['reason']?.toString() ?? 'Cancelled by customer';

    if (orderId == null || orderId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Order ID required'},
      );
    }

    final order = await MongoService.orders!.findOne({'orderId': orderId});

    if (order == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Order not found'},
      );
    }

    // Verify order belongs to user
    if (order['userId'] != userId) {
      return Response.json(
        statusCode: 403,
        body: {'success': false, 'message': 'Unauthorized'},
      );
    }

    final currentStatus = order['orderStatus']?.toString();

    // Check if order can be cancelled
    final cancellableStatuses = ['pending', 'awaiting_payment'];
    if (!cancellableStatuses.contains(currentStatus)) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message':
              'Order cannot be cancelled at this stage. Current status: $currentStatus',
        },
      );
    }

    // Restore stock
    final items = order['items'] as List? ?? [];
    for (final item in items) {
      final productIdStr = item['productId']?.toString();
      if (productIdStr == null || productIdStr.isEmpty) {
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

    // Update order status
    final updateData = {
      'orderStatus': 'cancelled',
      'cancelledDate': DateTime.now(),
      'cancellationReason': reason,
      'cancelledBy': 'customer',
      'updatedAt': DateTime.now(),
    };

    final result = await MongoService.orders!.updateOne(
      {'orderId': orderId},
      {'\$set': updateData},
    );

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to cancel order'},
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Order cancelled successfully',
        'data': {'orderId': orderId, 'orderStatus': 'cancelled'},
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

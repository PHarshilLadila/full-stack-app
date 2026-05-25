// app_backend/lib/routes/order/update_status.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/notification_service.dart';

/// Generate tracking ID
String generateTrackingId(String orderId) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = DateTime.now().microsecond % 10000;
  return 'TRK${timestamp}${random.toString().padLeft(4, '0')}';
}

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

    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final orderId = body['orderId']?.toString();
    final orderStatus = body['orderStatus']?.toString();

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

    // Customer can only cancel their own orders
    if (userRole == 'customer') {
      if (order['userId'] != userId) {
        return Response.json(
          statusCode: 403,
          body: {'success': false, 'message': 'Unauthorized'},
        );
      }

      // Customers can only cancel pending orders
      if (orderStatus != 'cancelled') {
        return Response.json(
          statusCode: 403,
          body: {
            'success': false,
            'message': 'Customers can only cancel orders',
          },
        );
      }

      final currentStatus = order['orderStatus']?.toString();
      if (currentStatus != 'pending' && currentStatus != 'awaiting_payment') {
        return Response.json(
          statusCode: 400,
          body: {
            'success': false,
            'message': 'Order cannot be cancelled at this stage',
          },
        );
      }
    }

    // Seller/Admin permissions
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

    // Fix: Explicitly type as Map<String, dynamic>
    final Map<String, dynamic> updateData = {
      'orderStatus': orderStatus,
      'updatedAt': DateTime.now(),
    };

    // Auto-generate tracking ID when status changes to 'shipped'
    if (orderStatus == 'shipped') {
      final trackingId = generateTrackingId(orderId);
      updateData['trackingId'] = trackingId;
      updateData['shippedDate'] = DateTime.now();
    }

    if (orderStatus == 'out_for_delivery') {
      updateData['outForDeliveryDate'] = DateTime.now();
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

    // ============================================================
    // ========== SEND NOTIFICATIONS FOR STATUS CHANGE ============
    // ============================================================

    final customerId = order['userId']?.toString();
    final orderIdStr = orderId;
    final trackingIdValue = updateData['trackingId'] as String?;

    if (customerId != null && customerId.isNotEmpty) {
      String title = '';
      String message = '';
      String statusType = '';

      switch (orderStatus) {
        case 'confirmed':
          title = '✅ Order Confirmed!';
          message = 'Your order #$orderIdStr has been confirmed by the seller.';
          statusType = 'order_confirmed';
          break;

        case 'shipped':
          title = '📦 Order Shipped!';
          if (trackingIdValue != null && trackingIdValue.isNotEmpty) {
            message =
                'Your order #$orderIdStr has been shipped. Tracking ID: $trackingIdValue';
          } else {
            message =
                'Your order #$orderIdStr has been shipped and is on the way!';
          }
          statusType = 'order_shipped';
          break;

        case 'out_for_delivery':
          title = '🚚 Out for Delivery!';
          message =
              'Your order #$orderIdStr is out for delivery and will reach you soon.';
          statusType = 'order_out_for_delivery';
          break;

        case 'delivered':
          title = '🎉 Order Delivered!';
          message =
              'Your order #$orderIdStr has been delivered successfully. Thank you for shopping with us!';
          statusType = 'order_delivered';
          break;

        case 'cancelled':
          title = '❌ Order Cancelled';
          message = 'Your order #$orderIdStr has been cancelled.';
          statusType = 'order_cancelled';
          break;

        default:
          title = '📝 Order Updated';
          message =
              'Your order #$orderIdStr status has been updated to: $orderStatus';
          statusType = 'order_updated';
      }

      if (title.isNotEmpty) {
        // Send push notification to customer
        await NotificationService.notifyCustomerOrderStatus(
          customerId: customerId,
          orderId: orderIdStr,
          status: statusType,
          title: title,
          message: message,
          trackingId: trackingIdValue,
        );

        // Save notification to database for customer
        await NotificationService.saveNotificationHistory(
          userId: customerId,
          userRole: 'customer',
          title: title,
          body: message,
          type: statusType,
          data: {'orderId': orderIdStr, 'status': orderStatus},
        );

        print(
          '✅ Notification sent to customer: $customerId for status: $orderStatus',
        );
      }
    }

    // ============================================================
    // ========== END NOTIFICATIONS ===============================
    // ============================================================

    final Map<String, dynamic> responseData = {
      'orderId': orderId,
      'orderStatus': orderStatus,
    };

    if (updateData.containsKey('trackingId')) {
      responseData['trackingId'] = updateData['trackingId'] as String;
    }

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Order status updated successfully',
        'data': responseData,
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

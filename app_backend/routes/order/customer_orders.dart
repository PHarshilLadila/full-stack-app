// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// GET /order/customer_orders?page=1&limit=10&status=pending
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /order/customer_orders API HIT');

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
    final userRole = jwt.payload['role']?.toString() ?? 'customer';

    final queryParams = context.request.uri.queryParameters;
    final page = int.tryParse(queryParams['page'] ?? '1') ?? 1;
    final limit = int.tryParse(queryParams['limit'] ?? '10') ?? 10;
    final skip = (page - 1) * limit;
    final status = queryParams['status'];

    final filter = <String, dynamic>{'userId': userId};
    if (status != null && status.isNotEmpty) {
      filter['orderStatus'] = status;
    }

    final totalCount = await MongoService.orders!.count(filter);

    // Get all orders first
    final allOrders = await MongoService.orders!.find(filter).toList();

    // Sort manually (newest first)
    allOrders.sort((a, b) {
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });

    // Apply pagination
    final orders = allOrders.skip(skip).take(limit).toList();

    final transformedOrders =
        orders.map((order) {
          // Safely convert items
          final items = order['items'] as List? ?? [];
          final shippingAddress =
              order['shippingAddress'] as Map<String, dynamic>? ?? {};

          return {
            '_id': (order['_id'] as ObjectId).oid,
            'orderId': order['orderId']?.toString() ?? '',
            'items':
                items.map((item) {
                  return {
                    'productId': item['productId']?.toString() ?? '',
                    'productName': item['productName']?.toString() ?? '',
                    'productImage': item['productImage']?.toString() ?? '',
                    'price': (item['price'] as num?)?.toDouble() ?? 0.0,
                    'discountPrice':
                        item['discountPrice'] != null
                            ? (item['discountPrice'] as num).toDouble()
                            : null,
                    'quantity': item['quantity'] as int? ?? 1,
                    'totalPrice':
                        (item['totalPrice'] as num?)?.toDouble() ?? 0.0,
                    'sellerId': item['sellerId']?.toString() ?? '',
                    'sellerName': item['sellerName']?.toString() ?? '',
                  };
                }).toList(),
            'shippingAddress': {
              'fullName': shippingAddress['fullName']?.toString() ?? '',
              'mobileNumber': shippingAddress['mobileNumber']?.toString() ?? '',
              'pincode': shippingAddress['pincode']?.toString() ?? '',
              'addressLine1': shippingAddress['addressLine1']?.toString() ?? '',
              'addressLine2': shippingAddress['addressLine2']?.toString() ?? '',
              'landmark': shippingAddress['landmark']?.toString() ?? '',
              'city': shippingAddress['city']?.toString() ?? '',
              'state': shippingAddress['state']?.toString() ?? '',
              'country': shippingAddress['country']?.toString() ?? 'India',
            },
            'subtotal': (order['subtotal'] as num?)?.toDouble() ?? 0.0,
            'shippingCharge':
                (order['shippingCharge'] as num?)?.toDouble() ?? 0.0,
            'discountAmount':
                (order['discountAmount'] as num?)?.toDouble() ?? 0.0,
            'taxAmount': (order['taxAmount'] as num?)?.toDouble() ?? 0.0,
            'totalAmount': (order['totalAmount'] as num?)?.toDouble() ?? 0.0,
            'paymentMethod': order['paymentMethod']?.toString() ?? '',
            'paymentStatus': order['paymentStatus']?.toString() ?? '',
            'orderStatus': order['orderStatus']?.toString() ?? '',
            'trackingId': order['trackingId']?.toString(),
            'orderDate':
                order['orderDate'] is DateTime
                    ? (order['orderDate'] as DateTime).toIso8601String()
                    : null,
            'deliveredDate':
                order['deliveredDate'] is DateTime
                    ? (order['deliveredDate'] as DateTime).toIso8601String()
                    : null,
            'createdAt':
                order['createdAt'] is DateTime
                    ? (order['createdAt'] as DateTime).toIso8601String()
                    : null,
          };
        }).toList();

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Orders fetched successfully',
        'data': transformedOrders,
        'pagination': {
          'currentPage': page,
          'totalPages': totalCount > 0 ? (totalCount / limit).ceil() : 0,
          'totalItems': totalCount,
          'itemsPerPage': limit,
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

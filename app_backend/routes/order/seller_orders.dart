// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// GET /order/seller_orders?page=1&limit=10&status=pending
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /order/seller_orders API HIT');

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

    if (userRole != 'seller') {
      return Response.json(
        statusCode: 403,
        body: {
          'success': false,
          'message': 'Only sellers can view seller orders',
        },
      );
    }

    final queryParams = context.request.uri.queryParameters;
    final page = int.tryParse(queryParams['page'] ?? '1') ?? 1;
    final limit = int.tryParse(queryParams['limit'] ?? '10') ?? 10;
    final skip = (page - 1) * limit;
    final status = queryParams['status'];

    // Get all orders - Remove .sort() from Stream
    final allOrdersStream = await MongoService.orders!.find({}).toList();

    // Sort manually (newest first)
    allOrdersStream.sort((a, b) {
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });

    // Filter orders that contain seller's products
    final sellerOrders = [];
    for (final order in allOrdersStream) {
      final items = order['items'] as List? ?? [];

      // Safely filter items by sellerId
      final sellerItems =
          items.where((item) {
            final itemSellerId = item['sellerId']?.toString();
            return itemSellerId == userId;
          }).toList();

      if (sellerItems.isNotEmpty) {
        // Calculate seller total safely
        double sellerTotal = 0.0;
        for (final item in sellerItems) {
          sellerTotal += (item['totalPrice'] as num?)?.toDouble() ?? 0.0;
        }

        sellerOrders.add({
          ...order,
          'sellerItems': sellerItems,
          'sellerTotal': sellerTotal,
        });
      }
    }

    final totalCount = sellerOrders.length;

    // Apply status filter first
    var filteredOrders = sellerOrders;
    if (status != null && status.isNotEmpty) {
      filteredOrders =
          sellerOrders.where((order) {
            final orderStatus = order['orderStatus']?.toString();
            return orderStatus == status;
          }).toList();
    }

    // Apply pagination after filtering
    final paginatedOrders = filteredOrders.skip(skip).take(limit).toList();

    final transformedOrders =
        paginatedOrders.map((order) {
          final sellerItems = order['sellerItems'] as List? ?? [];
          final shippingAddress =
              order['shippingAddress'] as Map<String, dynamic>? ?? {};

          return {
            '_id': (order['_id'] as ObjectId).oid,
            'orderId': order['orderId']?.toString() ?? '',
            'customerName': order['userName']?.toString() ?? '',
            'customerMobile': order['userMobile']?.toString() ?? '',
            'customerEmail': order['userEmail']?.toString() ?? '',
            'items':
                sellerItems.map((item) {
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
            'totalAmount': (order['sellerTotal'] as num?)?.toDouble() ?? 0.0,
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
        'message': 'Seller orders fetched successfully',
        'data': transformedOrders,
        'pagination': {
          'currentPage': page,
          'totalPages':
              filteredOrders.isNotEmpty
                  ? (filteredOrders.length / limit).ceil()
                  : 0,
          'totalItems': filteredOrders.length,
          'itemsPerPage': limit,
        },
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

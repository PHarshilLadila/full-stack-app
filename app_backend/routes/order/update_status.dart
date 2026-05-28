// // // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

// // import 'dart:convert';
// // import 'package:dart_frog/dart_frog.dart';
// // import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// // import 'package:mongo_dart/mongo_dart.dart';

// // import 'package:my_backend/config/env.dart';
// // import 'package:my_backend/db/mongo.dart';

// // /// PUT /order/update_status
// // Future<Response> onRequest(RequestContext context) async {
// //   print('🔥 /order/update_status API HIT');

// //   if (context.request.method != HttpMethod.put) {
// //     return Response.json(
// //       statusCode: 405,
// //       body: {'success': false, 'message': 'Method not allowed'},
// //     );
// //   }

// //   final authHeader = context.request.headers['authorization'];
// //   if (authHeader == null || !authHeader.startsWith('Bearer ')) {
// //     return Response.json(
// //       statusCode: 401,
// //       body: {'success': false, 'message': 'Token missing'},
// //     );
// //   }

// //   final token = authHeader.split(' ')[1];

// //   try {
// //     final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
// //     final userId = jwt.payload['id'].toString();
// //     final userRole = jwt.payload['role']?.toString() ?? 'customer';

// //     if (userRole != 'seller' && userRole != 'admin') {
// //       return Response.json(
// //         statusCode: 403,
// //         body: {
// //           'success': false,
// //           'message': 'Only sellers can update order status',
// //         },
// //       );
// //     }

// //     final body =
// //         jsonDecode(await context.request.body()) as Map<String, dynamic>;
// //     final orderId = body['orderId']?.toString();
// //     final orderStatus = body['orderStatus']?.toString();
// //     final trackingId = body['trackingId']?.toString();

// //     if (orderId == null || orderId.isEmpty) {
// //       return Response.json(
// //         statusCode: 400,
// //         body: {'success': false, 'message': 'Order ID required'},
// //       );
// //     }

// //     if (orderStatus == null || orderStatus.isEmpty) {
// //       return Response.json(
// //         statusCode: 400,
// //         body: {'success': false, 'message': 'Order status required'},
// //       );
// //     }

// //     final validStatuses = [
// //       'pending',
// //       'confirmed',
// //       'shipped',
// //       'out_for_delivery',
// //       'delivered',
// //       'cancelled',
// //     ];
// //     if (!validStatuses.contains(orderStatus)) {
// //       return Response.json(
// //         statusCode: 400,
// //         body: {'success': false, 'message': 'Invalid order status'},
// //       );
// //     }

// //     final order = await MongoService.orders!.findOne({'orderId': orderId});

// //     if (order == null) {
// //       return Response.json(
// //         statusCode: 404,
// //         body: {'success': false, 'message': 'Order not found'},
// //       );
// //     }

// //     // Verify seller has permission (if seller, check if order contains their product)
// //     // Add this inside the seller verification block
// //     if (userRole == 'seller') {
// //       final items = order['items'] as List? ?? [];
// //       bool hasSellerProduct = false;

// //       print('🔍 Debug - Seller ID from token: $userId');
// //       print('🔍 Debug - Total items in order: ${items.length}');

// //       for (final item in items) {
// //         final itemSellerId = item['sellerId']?.toString();
// //         print(
// //           '🔍 Debug - Item: ${item['productName']}, SellerId: $itemSellerId',
// //         );

// //         if (itemSellerId == userId) {
// //           hasSellerProduct = true;
// //           print('✅ Match found for product: ${item['productName']}');
// //           break;
// //         }
// //       }

// //       print('🔍 Debug - Has seller product: $hasSellerProduct');

// //       if (!hasSellerProduct) {
// //         return Response.json(
// //           statusCode: 403,
// //           body: {
// //             'success': false,
// //             'message': 'Unauthorized to update this order',
// //             'debug': {
// //               'yourSellerId': userId,
// //               'sellersInOrder':
// //                   items.map((i) => i['sellerId']?.toString()).toList(),
// //             },
// //           },
// //         );
// //       }
// //     }

// //     final updateData = {
// //       'orderStatus': orderStatus,
// //       'updatedAt': DateTime.now(),
// //     };

// //     if (trackingId != null && trackingId.isNotEmpty) {
// //       updateData['trackingId'] = trackingId;
// //     }

// //     if (orderStatus == 'delivered') {
// //       updateData['deliveredDate'] = DateTime.now();
// //       updateData['paymentStatus'] = 'completed';
// //     }

// //     if (orderStatus == 'cancelled') {
// //       updateData['cancelledDate'] = DateTime.now();

// //       // Restore stock for cancelled order
// //       final items = order['items'] as List? ?? [];
// //       for (final item in items) {
// //         final productIdStr = item['productId']?.toString();
// //         if (productIdStr == null || productIdStr.isEmpty) {
// //           print('Warning: Invalid product ID in order $orderId');
// //           continue;
// //         }

// //         try {
// //           final productObjectId = ObjectId.parse(productIdStr);
// //           final quantity = item['quantity'] as int? ?? 1;

// //           await MongoService.products!.updateOne(
// //             {'_id': productObjectId},
// //             {
// //               '\$inc': {'stock': quantity},
// //             },
// //           );
// //         } catch (e) {
// //           print('Error restoring stock for product $productIdStr: $e');
// //         }
// //       }
// //     }

// //     final result = await MongoService.orders!.updateOne(
// //       {'orderId': orderId},
// //       {'\$set': updateData},
// //     );

// //     if (!result.isSuccess) {
// //       return Response.json(
// //         statusCode: 500,
// //         body: {'success': false, 'message': 'Failed to update order status'},
// //       );
// //     }

// //     return Response.json(
// //       statusCode: 200,
// //       body: {
// //         'success': true,
// //         'message': 'Order status updated successfully',
// //         'data': {'orderId': orderId, 'orderStatus': orderStatus},
// //       },
// //     );
// //   } catch (e, stackTrace) {
// //     print('❌ ERROR: $e');
// //     print('Stack trace: $stackTrace');
// //     return Response.json(
// //       statusCode: 500,
// //       body: {'success': false, 'message': 'Server error: ${e.toString()}'},
// //     );
// //   }
// // }

// // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars
// // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:mongo_dart/mongo_dart.dart';

// import 'package:my_backend/config/env.dart';
// import 'package:my_backend/db/mongo.dart';

// /// Generate tracking ID
// String generateTrackingId(String orderId) {
//   final timestamp = DateTime.now().millisecondsSinceEpoch;
//   final random = DateTime.now().microsecond % 10000;
//   return 'TRK${timestamp}${random.toString().padLeft(4, '0')}';
// }

// /// PUT /order/update_status
// Future<Response> onRequest(RequestContext context) async {
//   print('🔥 /order/update_status API HIT');

//   if (context.request.method != HttpMethod.put) {
//     return Response.json(
//       statusCode: 405,
//       body: {'success': false, 'message': 'Method not allowed'},
//     );
//   }

//   final authHeader = context.request.headers['authorization'];
//   if (authHeader == null || !authHeader.startsWith('Bearer ')) {
//     return Response.json(
//       statusCode: 401,
//       body: {'success': false, 'message': 'Token missing'},
//     );
//   }

//   final token = authHeader.split(' ')[1];

//   try {
//     final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
//     final userId = jwt.payload['id'].toString();
//     final userRole = jwt.payload['role']?.toString() ?? 'customer';

//     final body =
//         jsonDecode(await context.request.body()) as Map<String, dynamic>;
//     final orderId = body['orderId']?.toString();
//     final orderStatus = body['orderStatus']?.toString();

//     if (orderId == null || orderId.isEmpty) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Order ID required'},
//       );
//     }

//     if (orderStatus == null || orderStatus.isEmpty) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Order status required'},
//       );
//     }

//     final validStatuses = [
//       'pending',
//       'confirmed',
//       'shipped',
//       'out_for_delivery',
//       'delivered',
//       'cancelled',
//     ];
//     if (!validStatuses.contains(orderStatus)) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Invalid order status'},
//       );
//     }

//     final order = await MongoService.orders!.findOne({'orderId': orderId});

//     if (order == null) {
//       return Response.json(
//         statusCode: 404,
//         body: {'success': false, 'message': 'Order not found'},
//       );
//     }

//     // Customer can only cancel their own orders
//     if (userRole == 'customer') {
//       if (order['userId'] != userId) {
//         return Response.json(
//           statusCode: 403,
//           body: {'success': false, 'message': 'Unauthorized'},
//         );
//       }

//       // Customers can only cancel pending orders
//       if (orderStatus != 'cancelled') {
//         return Response.json(
//           statusCode: 403,
//           body: {
//             'success': false,
//             'message': 'Customers can only cancel orders',
//           },
//         );
//       }

//       final currentStatus = order['orderStatus']?.toString();
//       if (currentStatus != 'pending' && currentStatus != 'awaiting_payment') {
//         return Response.json(
//           statusCode: 400,
//           body: {
//             'success': false,
//             'message': 'Order cannot be cancelled at this stage',
//           },
//         );
//       }
//     }

//     // Seller/Admin permissions
//     if (userRole == 'seller') {
//       final items = order['items'] as List? ?? [];
//       bool hasSellerProduct = false;

//       for (final item in items) {
//         final itemSellerId = item['sellerId']?.toString();
//         if (itemSellerId == userId) {
//           hasSellerProduct = true;
//           break;
//         }
//       }

//       if (!hasSellerProduct) {
//         return Response.json(
//           statusCode: 403,
//           body: {
//             'success': false,
//             'message': 'Unauthorized to update this order',
//           },
//         );
//       }
//     }

//     // Fix: Explicitly type as Map<String, dynamic>
//     final Map<String, dynamic> updateData = {
//       'orderStatus': orderStatus,
//       'updatedAt': DateTime.now(),
//     };

//     // Auto-generate tracking ID when status changes to 'shipped'
//     if (orderStatus == 'shipped') {
//       final trackingId = generateTrackingId(orderId);
//       updateData['trackingId'] = trackingId;
//       updateData['shippedDate'] = DateTime.now();
//     }

//     if (orderStatus == 'out_for_delivery') {
//       updateData['outForDeliveryDate'] = DateTime.now();
//     }

//     if (orderStatus == 'delivered') {
//       updateData['deliveredDate'] = DateTime.now();
//       updateData['paymentStatus'] = 'completed';
//     }

//     if (orderStatus == 'cancelled') {
//       updateData['cancelledDate'] = DateTime.now();

//       // Restore stock for cancelled order
//       final items = order['items'] as List? ?? [];
//       for (final item in items) {
//         final productIdStr = item['productId']?.toString();
//         if (productIdStr == null || productIdStr.isEmpty) {
//           continue;
//         }

//         try {
//           final productObjectId = ObjectId.parse(productIdStr);
//           final quantity = item['quantity'] as int? ?? 1;

//           await MongoService.products!.updateOne(
//             {'_id': productObjectId},
//             {
//               '\$inc': {'stock': quantity},
//             },
//           );
//         } catch (e) {
//           print('Error restoring stock for product $productIdStr: $e');
//         }
//       }
//     }

//     final result = await MongoService.orders!.updateOne(
//       {'orderId': orderId},
//       {'\$set': updateData},
//     );

//     if (!result.isSuccess) {
//       return Response.json(
//         statusCode: 500,
//         body: {'success': false, 'message': 'Failed to update order status'},
//       );
//     }

//     final Map<String, dynamic> responseData = {
//       'orderId': orderId,
//       'orderStatus': orderStatus,
//     };

//     if (updateData.containsKey('trackingId')) {
//       responseData['trackingId'] = updateData['trackingId'] as String;
//     }

//     return Response.json(
//       statusCode: 200,
//       body: {
//         'success': true,
//         'message': 'Order status updated successfully',
//         'data': responseData,
//       },
//     );
//   } catch (e, stackTrace) {
//     print('❌ ERROR: $e');
//     print('Stack trace: $stackTrace');
//     return Response.json(
//       statusCode: 500,
//       body: {'success': false, 'message': 'Server error: ${e.toString()}'},
//     );
//   }
// }

// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

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

      // If COD, update payment to completed when delivered
      final paymentMethod = order['paymentMethod']?.toString();
      if (paymentMethod == 'cod') {
        // Update payment record to completed
        await MongoService.payments!.updateOne(
          {'orderId': orderId},
          {
            '\$set': {
              'paymentStatus': 'completed',
              'completedAt': DateTime.now(),
            },
          },
        );
      }
    }

    if (orderStatus == 'cancelled') {
      updateData['cancelledDate'] = DateTime.now();

      // Update payment status to refunded if payment was made
      final paymentStatus = order['paymentStatus']?.toString();
      if (paymentStatus == 'completed') {
        updateData['paymentStatus'] = 'refunded';

        // Update payment record
        await MongoService.payments!.updateOne(
          {'orderId': orderId},
          {
            '\$set': {
              'paymentStatus': 'refunded',
              'refundedAt': DateTime.now(),
            },
          },
        );
      }

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

    final Map<String, dynamic> responseData = {
      'orderId': orderId,
      'orderStatus': orderStatus,
    };

    if (updateData.containsKey('trackingId')) {
      responseData['trackingId'] = updateData['trackingId'] as String;
    }

    if (updateData.containsKey('paymentStatus')) {
      responseData['paymentStatus'] = updateData['paymentStatus'] as String;
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

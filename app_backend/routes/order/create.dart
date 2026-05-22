// // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars, inference_failure_on_collection_literal

// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:mongo_dart/mongo_dart.dart';

// import 'package:my_backend/config/env.dart';
// import 'package:my_backend/db/mongo.dart';

// /// POST /order/create
// Future<Response> onRequest(RequestContext context) async {
//   print('🔥 /order/create API HIT');

//   if (context.request.method != HttpMethod.post) {
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

//     final body =
//         jsonDecode(await context.request.body()) as Map<String, dynamic>;

//     final addressId = body['addressId']?.toString();
//     final paymentMethod = body['paymentMethod']?.toString() ?? 'cod';

//     if (addressId == null || addressId.isEmpty) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Address ID required'},
//       );
//     }

//     // Get cart
//     final cart = await MongoService.carts!.findOne({'userId': userId});
//     if (cart == null || (cart['items'] as List?)?.isEmpty == true) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Cart is empty'},
//       );
//     }

//     // Get address
//     ObjectId? addressObjectId;
//     try {
//       addressObjectId = ObjectId.parse(addressId);
//     } catch (e) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Invalid address ID format'},
//       );
//     }

//     final address = await MongoService.addresses!.findOne({
//       '_id': addressObjectId,
//       'userId': userId,
//     });

//     if (address == null) {
//       return Response.json(
//         statusCode: 404,
//         body: {'success': false, 'message': 'Address not found'},
//       );
//     }

//     // Get user details
//     ObjectId? userObjectId;
//     try {
//       userObjectId = ObjectId.parse(userId);
//     } catch (e) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Invalid user ID format'},
//       );
//     }

//     final user = await MongoService.users!.findOne({'_id': userObjectId});

//     if (user == null) {
//       return Response.json(
//         statusCode: 404,
//         body: {'success': false, 'message': 'User not found'},
//       );
//     }

//     final items = cart['items'] as List? ?? [];

//     if (items.isEmpty) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Cart is empty'},
//       );
//     }

//     // Verify stock for all items
//     for (final item in items) {
//       final productIdStr = item['productId']?.toString();
//       if (productIdStr == null || productIdStr.isEmpty) {
//         return Response.json(
//           statusCode: 400,
//           body: {'success': false, 'message': 'Invalid product ID in cart'},
//         );
//       }

//       ObjectId? productObjectId;
//       try {
//         productObjectId = ObjectId.parse(productIdStr);
//       } catch (e) {
//         return Response.json(
//           statusCode: 400,
//           body: {
//             'success': false,
//             'message': 'Invalid product ID format: $productIdStr',
//           },
//         );
//       }

//       final product = await MongoService.products!.findOne({
//         '_id': productObjectId,
//       });

//       if (product == null) {
//         return Response.json(
//           statusCode: 404,
//           body: {
//             'success': false,
//             'message': 'Product ${item['productName']} not found',
//           },
//         );
//       }

//       final stock = product['stock'] as int? ?? 0;
//       final quantity = item['quantity'] as int? ?? 1;

//       if (stock < quantity) {
//         return Response.json(
//           statusCode: 400,
//           body: {
//             'success': false,
//             'message':
//                 'Insufficient stock for ${item['productName']}. Available: $stock',
//           },
//         );
//       }
//     }

//     // Generate order ID
//     final shortUserId = userId.length > 4 ? userId.substring(0, 4) : userId;
//     final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}${shortUserId}';

//     // Prepare order items
//     final orderItems = [];
//     for (final item in items) {
//       final productIdStr = item['productId'].toString();
//       final productObjectId = ObjectId.parse(productIdStr);

//       final product = await MongoService.products!.findOne({
//         '_id': productObjectId,
//       });

//       final price = (item['price'] as num?)?.toDouble() ?? 0.0;
//       final discountPrice =
//           item['discountPrice'] != null
//               ? (item['discountPrice'] as num).toDouble()
//               : null;
//       final effectivePrice = discountPrice ?? price;
//       final quantity = item['quantity'] as int? ?? 1;

//       orderItems.add({
//         'productId': productIdStr,
//         'productName': item['productName']?.toString() ?? '',
//         'productImage': item['productImage']?.toString() ?? '',
//         'price': price,
//         'discountPrice': discountPrice,
//         'quantity': quantity,
//         'totalPrice': effectivePrice * quantity,
//         'sellerId': item['sellerId']?.toString() ?? '',
//         'sellerName': item['sellerName']?.toString() ?? '',
//       });

//       // Update stock
//       final currentStock = product?['stock'] as int? ?? 0;
//       await MongoService.products!.updateOne(
//         {'_id': productObjectId},
//         {
//           '\$inc': {'stock': -quantity},
//           '\$set': {'stockAvailable': (currentStock - quantity) > 0},
//         },
//       );
//     }

//     // Calculate totals
//     final subtotal = (cart['totalAmount'] as num?)?.toDouble() ?? 0.0;
//     final discountAmount = (cart['discountAmount'] as num?)?.toDouble() ?? 0.0;
//     final shippingCharge = 50.0; // Fixed shipping charge
//     final taxAmount = (subtotal - discountAmount) * 0.05; // 5% tax
//     final totalAmount =
//         (subtotal - discountAmount) + shippingCharge + taxAmount;

//     // Prepare shipping address
//     final shippingAddress = {
//       'fullName': address['fullName']?.toString() ?? '',
//       'mobileNumber': address['mobileNumber']?.toString() ?? '',
//       'pincode': address['pincode']?.toString() ?? '',
//       'addressLine1': address['addressLine1']?.toString() ?? '',
//       'addressLine2': address['addressLine2']?.toString() ?? '',
//       'landmark': address['landmark']?.toString() ?? '',
//       'city': address['city']?.toString() ?? '',
//       'state': address['state']?.toString() ?? '',
//       'country': address['country']?.toString() ?? 'India',
//     };

//     // Create order
//     final orderData = {
//       'orderId': orderId,
//       'userId': userId,
//       'userName':
//           user['fullName']?.toString() ?? user['name']?.toString() ?? 'User',
//       'userEmail': user['email']?.toString() ?? '',
//       'userMobile': user['mobile']?.toString() ?? '',
//       'items': orderItems,
//       'shippingAddress': shippingAddress,
//       'subtotal': subtotal,
//       'shippingCharge': shippingCharge,
//       'discountAmount': discountAmount,
//       'taxAmount': taxAmount,
//       'totalAmount': totalAmount,
//       'paymentMethod': paymentMethod,
//       'paymentStatus': paymentMethod == 'cod' ? 'pending' : 'pending',
//       'orderStatus': 'pending',
//       'orderDate': DateTime.now(),
//       'createdAt': DateTime.now(),
//       'updatedAt': DateTime.now(),
//     };

//     final result = await MongoService.orders!.insertOne(orderData);

//     if (!result.isSuccess) {
//       // Rollback stock updates if order creation fails
//       for (final item in items) {
//         final productIdStr = item['productId'].toString();
//         final productObjectId = ObjectId.parse(productIdStr);
//         final quantity = item['quantity'] as int? ?? 1;

//         await MongoService.products!.updateOne(
//           {'_id': productObjectId},
//           {
//             '\$inc': {'stock': quantity},
//           },
//         );
//       }
//       return Response.json(
//         statusCode: 500,
//         body: {'success': false, 'message': 'Failed to create order'},
//       );
//     }

//     // Clear cart
//     await MongoService.carts!.updateOne(
//       {'userId': userId},
//       {
//         '\$set': {
//           'items': [],
//           'totalAmount': 0.0,
//           'discountAmount': 0.0,
//           'finalAmount': 0.0,
//           'updatedAt': DateTime.now(),
//         },
//       },
//     );

//     return Response.json(
//       statusCode: 201,
//       body: {
//         'success': true,
//         'message': 'Order placed successfully',
//         'data': {
//           'orderId': orderId,
//           'totalAmount': totalAmount,
//           'paymentMethod': paymentMethod,
//         },
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
import 'package:my_backend/config/stripe.dart';
import 'package:my_backend/db/mongo.dart';

/// POST /order/create
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /order/create API HIT');

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

    final addressId = body['addressId']?.toString();
    final paymentMethod = body['paymentMethod']?.toString() ?? 'cod';

    // Fix: Properly cast isDirectOrder to bool
    final isDirectOrder = body['isDirectOrder'] == true;
    final directProduct = body['directProduct'] as Map<String, dynamic>?;

    if (addressId == null || addressId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Address ID required'},
      );
    }

    // Get cart or direct product
    List<dynamic> items = [];
    double subtotal = 0.0;
    double discountAmount = 0.0;

    if (isDirectOrder && directProduct != null) {
      // Direct order (single product)
      final productId = directProduct['productId']?.toString();
      final quantity = directProduct['quantity'] as int? ?? 1;

      if (productId == null || productId.isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {
            'success': false,
            'message': 'Product ID required for direct order',
          },
        );
      }

      ObjectId? productObjectId;
      try {
        productObjectId = ObjectId.parse(productId);
      } catch (e) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': 'Invalid product ID format'},
        );
      }

      final product = await MongoService.products!.findOne({
        '_id': productObjectId,
      });

      if (product == null) {
        return Response.json(
          statusCode: 404,
          body: {'success': false, 'message': 'Product not found'},
        );
      }

      final stock = product['stock'] as int? ?? 0;
      if (stock < quantity) {
        return Response.json(
          statusCode: 400,
          body: {
            'success': false,
            'message': 'Insufficient stock. Available: $stock',
          },
        );
      }

      final price = (product['price'] as num?)?.toDouble() ?? 0.0;
      final discountPrice =
          product['discountPrice'] != null
              ? (product['discountPrice'] as num).toDouble()
              : null;
      final effectivePrice = discountPrice ?? price;

      items = [
        {
          'productId': productId,
          'productName': product['name']?.toString() ?? '',
          'productImage':
              product['images'] != null &&
                      (product['images'] as List).isNotEmpty
                  ? (product['images'] as List)[0].toString()
                  : '',
          'price': price,
          'discountPrice': discountPrice,
          'quantity': quantity,
          'totalPrice': effectivePrice * quantity,
          'sellerId': product['sellerId']?.toString() ?? '',
          'sellerName': product['sellerName']?.toString() ?? '',
        },
      ];

      subtotal = effectivePrice * quantity;
    } else {
      // Cart order
      final cart = await MongoService.carts!.findOne({'userId': userId});
      if (cart == null || (cart['items'] as List?)?.isEmpty == true) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': 'Cart is empty'},
        );
      }

      items = cart['items'] as List? ?? [];
      subtotal = (cart['totalAmount'] as num?)?.toDouble() ?? 0.0;
      discountAmount = (cart['discountAmount'] as num?)?.toDouble() ?? 0.0;
    }

    if (items.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'No items to order'},
      );
    }

    // Get address
    ObjectId? addressObjectId;
    try {
      addressObjectId = ObjectId.parse(addressId);
    } catch (e) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid address ID format'},
      );
    }

    final address = await MongoService.addresses!.findOne({
      '_id': addressObjectId,
      'userId': userId,
    });

    if (address == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Address not found'},
      );
    }

    // Get user details
    ObjectId? userObjectId;
    try {
      userObjectId = ObjectId.parse(userId);
    } catch (e) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid user ID format'},
      );
    }

    final user = await MongoService.users!.findOne({'_id': userObjectId});

    if (user == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'User not found'},
      );
    }

    // Verify stock for all items
    for (final item in items) {
      final productIdStr = item['productId']?.toString();
      if (productIdStr == null || productIdStr.isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': 'Invalid product ID in order'},
        );
      }

      ObjectId? productObjectId;
      try {
        productObjectId = ObjectId.parse(productIdStr);
      } catch (e) {
        return Response.json(
          statusCode: 400,
          body: {
            'success': false,
            'message': 'Invalid product ID format: $productIdStr',
          },
        );
      }

      final product = await MongoService.products!.findOne({
        '_id': productObjectId,
      });

      if (product == null) {
        return Response.json(
          statusCode: 404,
          body: {
            'success': false,
            'message': 'Product ${item['productName']} not found',
          },
        );
      }

      final stock = product['stock'] as int? ?? 0;
      final quantity = item['quantity'] as int? ?? 1;

      if (stock < quantity) {
        return Response.json(
          statusCode: 400,
          body: {
            'success': false,
            'message':
                'Insufficient stock for ${item['productName']}. Available: $stock',
          },
        );
      }
    }

    // Generate order ID
    final shortUserId = userId.length > 4 ? userId.substring(0, 4) : userId;
    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}${shortUserId}';

    // Prepare order items and update stock
    final List<Map<String, dynamic>> orderItems = [];
    for (final item in items) {
      final productIdStr = item['productId'].toString();
      final productObjectId = ObjectId.parse(productIdStr);

      final product = await MongoService.products!.findOne({
        '_id': productObjectId,
      });

      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final discountPrice =
          item['discountPrice'] != null
              ? (item['discountPrice'] as num).toDouble()
              : null;
      final effectivePrice = discountPrice ?? price;
      final quantity = item['quantity'] as int? ?? 1;

      orderItems.add({
        'productId': productIdStr,
        'productName': item['productName']?.toString() ?? '',
        'productImage': item['productImage']?.toString() ?? '',
        'price': price,
        'discountPrice': discountPrice,
        'quantity': quantity,
        'totalPrice': effectivePrice * quantity,
        'sellerId': item['sellerId']?.toString() ?? '',
        'sellerName': item['sellerName']?.toString() ?? '',
      });

      // Update stock
      final currentStock = product?['stock'] as int? ?? 0;
      await MongoService.products!.updateOne(
        {'_id': productObjectId},
        {
          '\$inc': {'stock': -quantity},
          '\$set': {'stockAvailable': (currentStock - quantity) > 0},
        },
      );
    }

    // Calculate totals
    final shippingCharge = 50.0;
    final taxAmount = (subtotal - discountAmount) * 0.05;
    final totalAmount =
        (subtotal - discountAmount) + shippingCharge + taxAmount;

    // Prepare shipping address
    final shippingAddress = {
      'fullName': address['fullName']?.toString() ?? '',
      'mobileNumber': address['mobileNumber']?.toString() ?? '',
      'pincode': address['pincode']?.toString() ?? '',
      'addressLine1': address['addressLine1']?.toString() ?? '',
      'addressLine2': address['addressLine2']?.toString() ?? '',
      'landmark': address['landmark']?.toString() ?? '',
      'city': address['city']?.toString() ?? '',
      'state': address['state']?.toString() ?? '',
      'country': address['country']?.toString() ?? 'India',
    };

    // Initialize Stripe
    StripeConfig.init(Env.stripeSecretKey);

    // Handle payment based on method
    String paymentStatus = 'pending';
    String? paymentIntentId;
    String? clientSecret;

    if (paymentMethod == 'online') {
      try {
        // Create Payment Intent using direct HTTP
        final Map<String, dynamic> paymentIntent =
            await StripeConfig.createPaymentIntent(totalAmount, 'inr');

        // Fix: Properly cast the values to String?
        paymentIntentId = paymentIntent['id']?.toString();
        clientSecret = paymentIntent['client_secret']?.toString();
        paymentStatus = 'pending';

        if (paymentIntentId == null || clientSecret == null) {
          throw Exception('Invalid payment intent response');
        }
      } catch (e) {
        print('Stripe payment intent creation failed: $e');
        // Rollback stock updates
        for (final item in items) {
          final productIdStr = item['productId'].toString();
          final productObjectId = ObjectId.parse(productIdStr);
          final quantity = item['quantity'] as int? ?? 1;
          await MongoService.products!.updateOne(
            {'_id': productObjectId},
            {
              '\$inc': {'stock': quantity},
            },
          );
        }
        return Response.json(
          statusCode: 400,
          body: {
            'success': false,
            'message': 'Payment initialization failed: $e',
          },
        );
      }
    }

    // Create order
    final Map<String, dynamic> orderData = {
      'orderId': orderId,
      'userId': userId,
      'userName':
          user['fullName']?.toString() ?? user['name']?.toString() ?? 'User',
      'userEmail': user['email']?.toString() ?? '',
      'userMobile': user['mobile']?.toString() ?? '',
      'items': orderItems,
      'shippingAddress': shippingAddress,
      'subtotal': subtotal,
      'shippingCharge': shippingCharge,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentIntentId': paymentIntentId,
      'orderStatus': paymentMethod == 'cod' ? 'pending' : 'awaiting_payment',
      'orderDate': DateTime.now(),
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    final result = await MongoService.orders!.insertOne(orderData);

    if (!result.isSuccess) {
      // Rollback stock updates if order creation fails
      for (final item in items) {
        final productIdStr = item['productId'].toString();
        final productObjectId = ObjectId.parse(productIdStr);
        final quantity = item['quantity'] as int? ?? 1;
        await MongoService.products!.updateOne(
          {'_id': productObjectId},
          {
            '\$inc': {'stock': quantity},
          },
        );
      }
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to create order'},
      );
    }

    // Clear cart only if it's a cart order
    if (!isDirectOrder) {
      await MongoService.carts!.updateOne(
        {'userId': userId},
        {
          '\$set': {
            'items': [],
            'totalAmount': 0.0,
            'discountAmount': 0.0,
            'finalAmount': 0.0,
            'updatedAt': DateTime.now(),
          },
        },
      );
    }

    // For online payments, return payment intent details
    if (paymentMethod == 'online' &&
        paymentIntentId != null &&
        clientSecret != null) {
      return Response.json(
        statusCode: 201,
        body: {
          'success': true,
          'message': 'Order created. Please complete payment.',
          'data': {
            'orderId': orderId,
            'totalAmount': totalAmount,
            'paymentMethod': paymentMethod,
            'paymentIntentId': paymentIntentId,
            'clientSecret': clientSecret,
          },
        },
      );
    }

    return Response.json(
      statusCode: 201,
      body: {
        'success': true,
        'message': 'Order placed successfully',
        'data': {
          'orderId': orderId,
          'totalAmount': totalAmount,
          'paymentMethod': paymentMethod,
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

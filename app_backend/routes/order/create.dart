// // // // app_backend/lib/routes/order/create.dart
// // // import 'dart:convert';
// // // import 'package:dart_frog/dart_frog.dart';
// // // import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// // // import 'package:mongo_dart/mongo_dart.dart';
// // // import 'package:my_backend/config/env.dart';
// // // import 'package:my_backend/db/mongo.dart';

// // // /// Generate unique order ID
// // // String generateOrderId() {
// // //   final timestamp = DateTime.now().millisecondsSinceEpoch;
// // //   final random = DateTime.now().microsecond % 10000;
// // //   return 'ORD${timestamp}${random.toString().padLeft(4, '0')}';
// // // }

// // // /// POST /order/create
// // // Future<Response> onRequest(RequestContext context) async {
// // //   print('🔥 POST /order/create API HIT');
// // //   print('📍 Method: ${context.request.method}');
// // //   print('📍 Path: ${context.request.uri.path}');

// // //   // Allow only POST method
// // //   if (context.request.method != HttpMethod.post) {
// // //     print('❌ Method not allowed: ${context.request.method}');
// // //     return Response.json(
// // //       statusCode: 405,
// // //       headers: {
// // //         'Allow': 'POST',
// // //         'Access-Control-Allow-Origin': '*',
// // //         'Access-Control-Allow-Methods': 'POST, OPTIONS',
// // //         'Access-Control-Allow-Headers': 'Content-Type, Authorization',
// // //       },
// // //       body: {'success': false, 'message': 'Method not allowed. Use POST'},
// // //     );
// // //   }

// // //   // Handle OPTIONS preflight (CORS)
// // //   if (context.request.method == HttpMethod.options) {
// // //     return Response.json(
// // //       statusCode: 200,
// // //       headers: {
// // //         'Access-Control-Allow-Origin': '*',
// // //         'Access-Control-Allow-Methods': 'POST, OPTIONS',
// // //         'Access-Control-Allow-Headers': 'Content-Type, Authorization',
// // //       },
// // //       body: {},
// // //     );
// // //   }

// // //   // Get token from header
// // //   final authHeader = context.request.headers['authorization'];
// // //   print('📝 Auth Header present: ${authHeader != null}');

// // //   if (authHeader == null || !authHeader.startsWith('Bearer ')) {
// // //     return Response.json(
// // //       statusCode: 401,
// // //       body: {'success': false, 'message': 'Token missing or invalid'},
// // //     );
// // //   }

// // //   final token = authHeader.split(' ')[1];

// // //   try {
// // //     // Verify JWT token
// // //     final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
// // //     final userId = jwt.payload['id'].toString();
// // //     print('✅ User ID from token: $userId');

// // //     // Parse request body
// // //     final body = await context.request.json() as Map<String, dynamic>;
// // //     print('📦 Request body: $body');

// // //     final addressId = body['addressId']?.toString();
// // //     final paymentMethod = body['paymentMethod']?.toString();
// // //     final bool isDirectOrder = (body['isDirectOrder'] as bool?) ?? false;

// // //     print('📝 Create Order Request:');
// // //     print('  - User ID: $userId');
// // //     print('  - Address ID: $addressId');
// // //     print('  - Payment Method: $paymentMethod');
// // //     print('  - Is Direct Order: $isDirectOrder');

// // //     if (addressId == null || addressId.isEmpty) {
// // //       return Response.json(
// // //         statusCode: 400,
// // //         body: {'success': false, 'message': 'Address ID required'},
// // //       );
// // //     }

// // //     if (paymentMethod == null || paymentMethod.isEmpty) {
// // //       return Response.json(
// // //         statusCode: 400,
// // //         body: {'success': false, 'message': 'Payment method required'},
// // //       );
// // //     }

// // //     // Validate payment method
// // //     if (!['cod', 'online'].contains(paymentMethod)) {
// // //       return Response.json(
// // //         statusCode: 400,
// // //         body: {'success': false, 'message': 'Invalid payment method'},
// // //       );
// // //     }

// // //     // Get user's address
// // //     late ObjectId addressObjectId;
// // //     try {
// // //       addressObjectId = ObjectId.parse(addressId);
// // //     } catch (e) {
// // //       return Response.json(
// // //         statusCode: 400,
// // //         body: {'success': false, 'message': 'Invalid address ID format'},
// // //       );
// // //     }

// // //     final address = await MongoService.addresses?.findOne({
// // //       '_id': addressObjectId,
// // //       'userId': userId,
// // //     });

// // //     if (address == null) {
// // //       return Response.json(
// // //         statusCode: 404,
// // //         body: {'success': false, 'message': 'Address not found'},
// // //       );
// // //     }

// // //     List<Map<String, dynamic>> orderItems = [];
// // //     double totalAmount = 0.0;
// // //     double discountAmount = 0.0;
// // //     double finalAmount = 0.0;

// // //     if (isDirectOrder) {
// // //       // Direct order from product page
// // //       final directProduct = body['directProduct'] as Map<String, dynamic>?;
// // //       if (directProduct == null) {
// // //         return Response.json(
// // //           statusCode: 400,
// // //           body: {
// // //             'success': false,
// // //             'message': 'Direct product details required',
// // //           },
// // //         );
// // //       }

// // //       final productId = directProduct['productId']?.toString();
// // //       final quantity = directProduct['quantity'] as int? ?? 1;

// // //       if (productId == null || productId.isEmpty) {
// // //         return Response.json(
// // //           statusCode: 400,
// // //           body: {'success': false, 'message': 'Product ID required'},
// // //         );
// // //       }

// // //       late ObjectId productObjectId;
// // //       try {
// // //         productObjectId = ObjectId.parse(productId);
// // //       } catch (e) {
// // //         return Response.json(
// // //           statusCode: 400,
// // //           body: {'success': false, 'message': 'Invalid product ID format'},
// // //         );
// // //       }

// // //       final product = await MongoService.products?.findOne({
// // //         '_id': productObjectId,
// // //       });

// // //       if (product == null) {
// // //         return Response.json(
// // //           statusCode: 404,
// // //           body: {'success': false, 'message': 'Product not found'},
// // //         );
// // //       }

// // //       final originalPrice = (product['price'] as num).toDouble();
// // //       final discountedPrice =
// // //           (product['discountPrice'] as num?)?.toDouble() ?? originalPrice;
// // //       final price = discountedPrice;
// // //       final itemTotal = price * quantity;

// // //       orderItems.add({
// // //         'productId': productId,
// // //         'productName': product['productName'],
// // //         'productImage': product['mainBannerImage'],
// // //         'originalPrice': originalPrice,
// // //         'price': price,
// // //         'quantity': quantity,
// // //         'sellerId': product['sellerId']?.toString() ?? '',
// // //         'sellerName': product['sellerName'] ?? '',
// // //         'totalPrice': itemTotal,
// // //       });

// // //       totalAmount = originalPrice * quantity;
// // //       discountAmount = (originalPrice - price) * quantity;
// // //       finalAmount = itemTotal;
// // //     } else {
// // //       // Order from cart
// // //       final cart = await MongoService.carts?.findOne({'userId': userId});

// // //       if (cart == null) {
// // //         return Response.json(
// // //           statusCode: 400,
// // //           body: {'success': false, 'message': 'Cart is empty'},
// // //         );
// // //       }

// // //       final cartItems = cart['items'] as List? ?? [];

// // //       if (cartItems.isEmpty) {
// // //         return Response.json(
// // //           statusCode: 400,
// // //           body: {'success': false, 'message': 'Cart is empty'},
// // //         );
// // //       }

// // //       for (final item in cartItems) {
// // //         final productId = item['productId']?.toString();
// // //         if (productId == null) continue;

// // //         late ObjectId productObjectId;
// // //         try {
// // //           productObjectId = ObjectId.parse(productId);
// // //         } catch (e) {
// // //           print('Invalid product ID: $productId');
// // //           continue;
// // //         }

// // //         final product = await MongoService.products?.findOne({
// // //           '_id': productObjectId,
// // //         });

// // //         if (product != null) {
// // //           final originalPrice = (product['price'] as num).toDouble();
// // //           final discountedPrice =
// // //               (product['discountPrice'] as num?)?.toDouble() ?? originalPrice;
// // //           final price = discountedPrice;
// // //           final quantity = item['quantity'] as int? ?? 1;
// // //           final itemTotal = price * quantity;

// // //           orderItems.add({
// // //             'productId': productId,
// // //             'productName': product['productName'],
// // //             'productImage': product['mainBannerImage'],
// // //             'originalPrice': originalPrice,
// // //             'price': price,
// // //             'quantity': quantity,
// // //             'sellerId': product['sellerId']?.toString() ?? '',
// // //             'sellerName': product['sellerName'] ?? '',
// // //             'totalPrice': itemTotal,
// // //           });

// // //           totalAmount += originalPrice * quantity;
// // //           discountAmount += (originalPrice - price) * quantity;
// // //           finalAmount += itemTotal;
// // //         }
// // //       }

// // //       // Clear cart after order
// // //       await MongoService.carts?.updateOne(
// // //         {'userId': userId},
// // //         {
// // //           '\$set': {'items': [], 'totalItems': 0},
// // //         },
// // //       );
// // //     }

// // //     if (orderItems.isEmpty) {
// // //       return Response.json(
// // //         statusCode: 400,
// // //         body: {'success': false, 'message': 'No items to order'},
// // //       );
// // //     }

// // //     // Create order
// // //     final orderId = generateOrderId();
// // //     final orderData = {
// // //       'orderId': orderId,
// // //       'userId': userId,
// // //       'shippingAddress': {
// // //         'fullName': address['fullName'],
// // //         'addressLine1': address['addressLine1'],
// // //         'addressLine2': address['addressLine2'],
// // //         'city': address['city'],
// // //         'state': address['state'],
// // //         'pincode': address['pincode'],
// // //         'mobileNumber': address['mobileNumber'],
// // //       },
// // //       'items': orderItems,
// // //       'subtotal': totalAmount,
// // //       'discountAmount': discountAmount,
// // //       'shippingCharge': 0.0,
// // //       'taxAmount': 0.0,
// // //       'totalAmount': finalAmount,
// // //       'paymentMethod': paymentMethod,
// // //       'paymentStatus': paymentMethod == 'cod' ? 'pending' : 'awaiting',
// // //       'orderStatus': 'pending',
// // //       'orderDate': DateTime.now(),
// // //       'createdAt': DateTime.now(),
// // //       'updatedAt': DateTime.now(),
// // //     };

// // //     await MongoService.orders!.insert(orderData);
// // //     print('✅ Order created successfully: $orderId');

// // //     // Prepare response
// // //     Map<String, dynamic> responseData = {
// // //       'orderId': orderId,
// // //       'totalAmount': finalAmount,
// // //       'paymentMethod': paymentMethod,
// // //     };

// // //     // For online payments, add dummy payment intent
// // //     if (paymentMethod == 'online') {
// // //       responseData['paymentIntentId'] =
// // //           'pi_${DateTime.now().millisecondsSinceEpoch}';
// // //       responseData['clientSecret'] =
// // //           'secret_${DateTime.now().millisecondsSinceEpoch}';
// // //     }

// // //     return Response.json(
// // //       statusCode: 200,
// // //       headers: {'Access-Control-Allow-Origin': '*'},
// // //       body: {
// // //         'success': true,
// // //         'message': 'Order created successfully',
// // //         'data': responseData,
// // //       },
// // //     );
// // //   } catch (e, stackTrace) {
// // //     print('❌ ERROR in /order/create: $e');
// // //     print('Stack trace: $stackTrace');
// // //     return Response.json(
// // //       statusCode: 500,
// // //       body: {'success': false, 'message': 'Server error: ${e.toString()}'},
// // //     );
// // //   }
// // // }

// // // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

// // import 'dart:convert';

// // import 'package:dart_frog/dart_frog.dart';
// // import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// // import 'package:mongo_dart/mongo_dart.dart';

// // import 'package:my_backend/config/env.dart';
// // import 'package:my_backend/db/mongo.dart';

// // /// POST /order/create
// // Future<Response> onRequest(RequestContext context) async {
// //   print('🔥 /order/create API HIT');

// //   if (context.request.method != HttpMethod.post) {
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

// //     final body =
// //         jsonDecode(await context.request.body()) as Map<String, dynamic>;

// //     final addressId = body['addressId']?.toString();
// //     final paymentMethod = body['paymentMethod']?.toString() ?? 'cod';

// //     if (addressId == null || addressId.isEmpty) {
// //       return Response.json(
// //         statusCode: 400,
// //         body: {'success': false, 'message': 'Address ID required'},
// //       );
// //     }

// //     // Get cart
// //     final cart = await MongoService.carts!.findOne({'userId': userId});
// //     if (cart == null || (cart['items'] as List?)?.isEmpty == true) {
// //       return Response.json(
// //         statusCode: 400,
// //         body: {'success': false, 'message': 'Cart is empty'},
// //       );
// //     }

// //     // Get address
// //     ObjectId? addressObjectId;
// //     try {
// //       addressObjectId = ObjectId.parse(addressId);
// //     } catch (e) {
// //       return Response.json(
// //         statusCode: 400,
// //         body: {'success': false, 'message': 'Invalid address ID format'},
// //       );
// //     }

// //     final address = await MongoService.addresses!.findOne({
// //       '_id': addressObjectId,
// //       'userId': userId,
// //     });

// //     if (address == null) {
// //       return Response.json(
// //         statusCode: 404,
// //         body: {'success': false, 'message': 'Address not found'},
// //       );
// //     }

// //     // Get user details
// //     ObjectId? userObjectId;
// //     try {
// //       userObjectId = ObjectId.parse(userId);
// //     } catch (e) {
// //       return Response.json(
// //         statusCode: 400,
// //         body: {'success': false, 'message': 'Invalid user ID format'},
// //       );
// //     }

// //     final user = await MongoService.users!.findOne({'_id': userObjectId});

// //     if (user == null) {
// //       return Response.json(
// //         statusCode: 404,
// //         body: {'success': false, 'message': 'User not found'},
// //       );
// //     }

// //     final items = cart['items'] as List? ?? [];

// //     if (items.isEmpty) {
// //       return Response.json(
// //         statusCode: 400,
// //         body: {'success': false, 'message': 'Cart is empty'},
// //       );
// //     }

// //     // Verify stock for all items
// //     for (final item in items) {
// //       final productIdStr = item['productId']?.toString();
// //       if (productIdStr == null || productIdStr.isEmpty) {
// //         return Response.json(
// //           statusCode: 400,
// //           body: {'success': false, 'message': 'Invalid product ID in cart'},
// //         );
// //       }

// //       ObjectId? productObjectId;
// //       try {
// //         productObjectId = ObjectId.parse(productIdStr);
// //       } catch (e) {
// //         return Response.json(
// //           statusCode: 400,
// //           body: {
// //             'success': false,
// //             'message': 'Invalid product ID format: $productIdStr',
// //           },
// //         );
// //       }

// //       final product = await MongoService.products!.findOne({
// //         '_id': productObjectId,
// //       });

// //       if (product == null) {
// //         return Response.json(
// //           statusCode: 404,
// //           body: {
// //             'success': false,
// //             'message': 'Product ${item['productName']} not found',
// //           },
// //         );
// //       }

// //       final stock = product['stock'] as int? ?? 0;
// //       final quantity = item['quantity'] as int? ?? 1;

// //       if (stock < quantity) {
// //         return Response.json(
// //           statusCode: 400,
// //           body: {
// //             'success': false,
// //             'message':
// //                 'Insufficient stock for ${item['productName']}. Available: $stock',
// //           },
// //         );
// //       }
// //     }

// //     // Generate order ID
// //     final shortUserId = userId.length > 4 ? userId.substring(0, 4) : userId;
// //     final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}${shortUserId}';

// //     // Prepare order items
// //     final orderItems = [];
// //     for (final item in items) {
// //       final productIdStr = item['productId'].toString();
// //       final productObjectId = ObjectId.parse(productIdStr);

// //       final product = await MongoService.products!.findOne({
// //         '_id': productObjectId,
// //       });

// //       final price = (item['price'] as num?)?.toDouble() ?? 0.0;
// //       final discountPrice =
// //           item['discountPrice'] != null
// //               ? (item['discountPrice'] as num).toDouble()
// //               : null;
// //       final effectivePrice = discountPrice ?? price;
// //       final quantity = item['quantity'] as int? ?? 1;

// //       orderItems.add({
// //         'productId': productIdStr,
// //         'productName': item['productName']?.toString() ?? '',
// //         'productImage': item['productImage']?.toString() ?? '',
// //         'price': price,
// //         'discountPrice': discountPrice,
// //         'quantity': quantity,
// //         'totalPrice': effectivePrice * quantity,
// //         'sellerId': item['sellerId']?.toString() ?? '',
// //         'sellerName': item['sellerName']?.toString() ?? '',
// //       });

// //       // Update stock
// //       final currentStock = product?['stock'] as int? ?? 0;
// //       await MongoService.products!.updateOne(
// //         {'_id': productObjectId},
// //         {
// //           '\$inc': {'stock': -quantity},
// //           '\$set': {'stockAvailable': (currentStock - quantity) > 0},
// //         },
// //       );
// //     }

// //     // Calculate totals
// //     final subtotal = (cart['totalAmount'] as num?)?.toDouble() ?? 0.0;
// //     final discountAmount = (cart['discountAmount'] as num?)?.toDouble() ?? 0.0;
// //     final shippingCharge = 50.0; // Fixed shipping charge
// //     final taxAmount = (subtotal - discountAmount) * 0.05; // 5% tax
// //     final totalAmount =
// //         (subtotal - discountAmount) + shippingCharge + taxAmount;

// //     // Prepare shipping address
// //     final shippingAddress = {
// //       'fullName': address['fullName']?.toString() ?? '',
// //       'mobileNumber': address['mobileNumber']?.toString() ?? '',
// //       'pincode': address['pincode']?.toString() ?? '',
// //       'addressLine1': address['addressLine1']?.toString() ?? '',
// //       'addressLine2': address['addressLine2']?.toString() ?? '',
// //       'landmark': address['landmark']?.toString() ?? '',
// //       'city': address['city']?.toString() ?? '',
// //       'state': address['state']?.toString() ?? '',
// //       'country': address['country']?.toString() ?? 'India',
// //     };

// //     // Create order
// //     final orderData = {
// //       'orderId': orderId,
// //       'userId': userId,
// //       'userName':
// //           user['fullName']?.toString() ?? user['name']?.toString() ?? 'User',
// //       'userEmail': user['email']?.toString() ?? '',
// //       'userMobile': user['mobile']?.toString() ?? '',
// //       'items': orderItems,
// //       'shippingAddress': shippingAddress,
// //       'subtotal': subtotal,
// //       'shippingCharge': shippingCharge,
// //       'discountAmount': discountAmount,
// //       'taxAmount': taxAmount,
// //       'totalAmount': totalAmount,
// //       'paymentMethod': paymentMethod,
// //       'paymentStatus': paymentMethod == 'cod' ? 'pending' : 'pending',
// //       'orderStatus': 'pending',
// //       'orderDate': DateTime.now(),
// //       'createdAt': DateTime.now(),
// //       'updatedAt': DateTime.now(),
// //     };

// //     final result = await MongoService.orders!.insertOne(orderData);

// //     if (!result.isSuccess) {
// //       // Rollback stock updates if order creation fails
// //       for (final item in items) {
// //         final productIdStr = item['productId'].toString();
// //         final productObjectId = ObjectId.parse(productIdStr);
// //         final quantity = item['quantity'] as int? ?? 1;

// //         await MongoService.products!.updateOne(
// //           {'_id': productObjectId},
// //           {
// //             '\$inc': {'stock': quantity},
// //           },
// //         );
// //       }
// //       return Response.json(
// //         statusCode: 500,
// //         body: {'success': false, 'message': 'Failed to create order'},
// //       );
// //     }

// //     // Clear cart
// //     await MongoService.carts!.updateOne(
// //       {'userId': userId},
// //       {
// //         '\$set': {
// //           'items': [],
// //           'totalAmount': 0.0,
// //           'discountAmount': 0.0,
// //           'finalAmount': 0.0,
// //           'updatedAt': DateTime.now(),
// //         },
// //       },
// //     );

// //     return Response.json(
// //       statusCode: 201,
// //       body: {
// //         'success': true,
// //         'message': 'Order placed successfully',
// //         'data': {
// //           'orderId': orderId,
// //           'totalAmount': totalAmount,
// //           'paymentMethod': paymentMethod,
// //         },
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
// // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars, inference_failure_on_collection_literal, use_if_null_to_convert_nulls_to_bools

// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:my_backend/config/env.dart';
// import 'package:my_backend/db/mongo.dart';

// /// Generate unique order ID
// String generateOrderId() {
//   final timestamp = DateTime.now().millisecondsSinceEpoch;
//   final random = DateTime.now().microsecond % 10000;
//   return 'ORD$timestamp${random.toString().padLeft(4, '0')}';
// }

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
//     final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}$shortUserId';

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
//           r'$inc': {'stock': -quantity},
//           r'$set': {'stockAvailable': (currentStock - quantity) > 0},
//         },
//       );
//     }

//     // Calculate totals
//     final subtotal = (cart['totalAmount'] as num?)?.toDouble() ?? 0.0;
//     final discountAmount = (cart['discountAmount'] as num?)?.toDouble() ?? 0.0;
//     const shippingCharge = 50.0; // Fixed shipping charge
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

//     // Set order status and payment status based on payment method
//     const orderStatus = 'pending';
//     final paymentStatus =
//         paymentMethod == 'cod' ? 'pending' : 'awaiting_payment';

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
//       'paymentStatus': paymentStatus,
//       'orderStatus': orderStatus,
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
//             r'$inc': {'stock': quantity},
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
//         r'$set': {
//           'items': [],
//           'totalAmount': 0.0,
//           'discountAmount': 0.0,
//           'finalAmount': 0.0,
//           'updatedAt': DateTime.now(),
//         },
//       },
//     );

//     // Return response based on payment method
//     final responseData = {
//       'orderId': orderId,
//       'totalAmount': totalAmount,
//       'paymentMethod': paymentMethod,
//       'paymentStatus': paymentStatus,
//       'orderStatus': orderStatus,
//     };

//     // For COD, order is ready
//     // For online, frontend should call /payment/initiate
//     return Response.json(
//       statusCode: 201,
//       body: {
//         'success': true,
//         'message':
//             paymentMethod == 'cod'
//                 ? 'Order placed successfully with COD'
//                 : 'Order created. Please complete payment.',
//         'data': responseData,
//       },
//     );
//   } catch (e, stackTrace) {
//     print('❌ ERROR: $e');
//     print('Stack trace: $stackTrace');
//     return Response.json(
//       statusCode: 500,
//       body: {'success': false, 'message': 'Server error: $e'},
//     );
//   }
// }

// ignore_for_file: inference_failure_on_collection_literal

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// Generate unique order ID
String generateOrderId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = DateTime.now().microsecond % 10000;
  return 'ORD$timestamp${random.toString().padLeft(4, '0')}';
}

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

    // Check if this is a direct order request
    final isDirectOrder = body['isDirectOrder'] == true;

    if (isDirectOrder) {
      // Handle direct order (Buy Now)
      return await _handleDirectOrder(context, userId, body);
    } else {
      // Handle cart-based order
      return await _handleCartOrder(context, userId, body);
    }
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

/// Handle cart-based order (Your existing code)
Future<Response> _handleCartOrder(
  RequestContext context,
  String userId,
  Map<String, dynamic> body,
) async {
  final addressId = body['addressId']?.toString();
  final paymentMethod = body['paymentMethod']?.toString() ?? 'cod';

  if (addressId == null || addressId.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'message': 'Address ID required'},
    );
  }

  // Get cart
  final cart = await MongoService.carts!.findOne({'userId': userId});
  if (cart == null || (cart['items'] as List?)?.isEmpty == true) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'message': 'Cart is empty'},
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

  final items = cart['items'] as List? ?? [];

  if (items.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'message': 'Cart is empty'},
    );
  }

  // Verify stock for all items
  for (final item in items) {
    final productIdStr = item['productId']?.toString();
    if (productIdStr == null || productIdStr.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid product ID in cart'},
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
  final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}$shortUserId';

  // Prepare order items
  final orderItems = [];
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
        r'$inc': {'stock': -quantity},
        r'$set': {'stockAvailable': (currentStock - quantity) > 0},
      },
    );
  }

  // Calculate totals
  final subtotal = (cart['totalAmount'] as num?)?.toDouble() ?? 0.0;
  final discountAmount = (cart['discountAmount'] as num?)?.toDouble() ?? 0.0;
  const shippingCharge = 50.0; // Fixed shipping charge
  final taxAmount = (subtotal - discountAmount) * 0.05; // 5% tax
  final totalAmount = (subtotal - discountAmount) + shippingCharge + taxAmount;

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

  // Set order status and payment status based on payment method
  const orderStatus = 'pending';
  final paymentStatus = paymentMethod == 'cod' ? 'pending' : 'awaiting_payment';

  // Create order
  final orderData = {
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
    'orderStatus': orderStatus,
    'orderType': 'cart',
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
          r'$inc': {'stock': quantity},
        },
      );
    }
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Failed to create order'},
    );
  }

  // Clear cart
  await MongoService.carts!.updateOne(
    {'userId': userId},
    {
      r'$set': {
        'items': [],
        'totalAmount': 0.0,
        'discountAmount': 0.0,
        'finalAmount': 0.0,
        'updatedAt': DateTime.now(),
      },
    },
  );

  // Return response based on payment method
  final responseData = {
    'orderId': orderId,
    'totalAmount': totalAmount,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'orderStatus': orderStatus,
  };

  // For COD, order is ready
  // For online, frontend should call /payment/initiate
  return Response.json(
    statusCode: 201,
    body: {
      'success': true,
      'message':
          paymentMethod == 'cod'
              ? 'Order placed successfully with COD'
              : 'Order created. Please complete payment.',
      'data': responseData,
    },
  );
}

/// Handle direct order (Buy Now without cart)
Future<Response> _handleDirectOrder(
  RequestContext context,
  String userId,
  Map<String, dynamic> body,
) async {
  // Required fields for direct purchase
  final productId = body['productId']?.toString();
  final quantity = (body['quantity'] as int?) ?? 1;
  final addressId = body['addressId']?.toString();
  final paymentMethod = body['paymentMethod']?.toString() ?? 'cod';

  // Validations
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

  if (addressId == null || addressId.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'success': false, 'message': 'Address ID required'},
    );
  }

  // Get product details
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

  // Check stock
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

  // Calculate pricing
  final price = (product['price'] as num?)?.toDouble() ?? 0.0;
  final discountPrice =
      product['discountPrice'] != null
          ? (product['discountPrice'] as num).toDouble()
          : null;
  final effectivePrice = discountPrice ?? price;
  final totalPrice = effectivePrice * quantity;

  // Calculate shipping and tax
  const shippingCharge = 50.0;
  final taxAmount = totalPrice * 0.05; // 5% tax
  final grandTotal = totalPrice + shippingCharge + taxAmount;

  // Get product image
  String productImage = '';
  if (product['images'] != null && (product['images'] as List).isNotEmpty) {
    productImage = (product['images'] as List)[0].toString();
  } else if (product['image'] != null) {
    productImage = product['image'].toString();
  }

  // Prepare order items (single item for direct purchase)
  final orderItems = [
    {
      'productId': productId,
      'productName':
          product['name']?.toString() ?? product['title']?.toString() ?? '',
      'productImage': productImage,
      'price': price,
      'discountPrice': discountPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'sellerId': product['sellerId']?.toString() ?? '',
      'sellerName': product['sellerName']?.toString() ?? '',
    },
  ];

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

  // Generate order ID
  final shortUserId = userId.length > 4 ? userId.substring(0, 4) : userId;
  final orderId = 'DIR$shortUserId${DateTime.now().millisecondsSinceEpoch}';

  // Set order status based on payment method
  const orderStatus = 'pending';
  final paymentStatus = paymentMethod == 'cod' ? 'pending' : 'awaiting_payment';

  // Create order directly (without cart)
  final orderData = {
    'orderId': orderId,
    'userId': userId,
    'userName':
        user['fullName']?.toString() ?? user['name']?.toString() ?? 'User',
    'userEmail': user['email']?.toString() ?? '',
    'userMobile': user['mobile']?.toString() ?? '',
    'items': orderItems,
    'shippingAddress': shippingAddress,
    'subtotal': totalPrice,
    'shippingCharge': shippingCharge,
    'discountAmount': 0.0, // No cart discount for direct purchase
    'taxAmount': taxAmount,
    'totalAmount': grandTotal,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'orderStatus': orderStatus,
    'orderType': 'direct', // New field to identify direct orders
    'orderDate': DateTime.now(),
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  };

  // Update product stock
  await MongoService.products!.updateOne(
    {'_id': productObjectId},
    {
      r'$inc': {'stock': -quantity},
      r'$set': {'stockAvailable': (stock - quantity) > 0},
    },
  );

  // Insert order
  final result = await MongoService.orders!.insertOne(orderData);

  if (!result.isSuccess) {
    // Rollback stock if order fails
    await MongoService.products!.updateOne(
      {'_id': productObjectId},
      {
        r'$inc': {'stock': quantity},
      },
    );
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Failed to create order'},
    );
  }

  // Prepare response
  final responseData = {
    'orderId': orderId,
    'productName': orderItems[0]['productName'],
    'quantity': quantity,
    'totalAmount': grandTotal,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'orderStatus': orderStatus,
  };

  return Response.json(
    statusCode: 201,
    body: {
      'success': true,
      'message':
          paymentMethod == 'cod'
              ? 'Order placed successfully with COD'
              : 'Order created. Please complete payment.',
      'data': responseData,
    },
  );
}

// ignore_for_file: avoid_print, avoid_dynamic_calls

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/utils/payment_helper.dart';

/// POST /payment/initiate
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /payment/initiate API HIT');

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
    final paymentMethod = body['paymentMethod']?.toString() ?? 'online';

    if (orderId == null || orderId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Order ID required'},
      );
    }

    // Get order details
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

    final totalAmount = (order['totalAmount'] as num?)?.toDouble() ?? 0.0;

    if (paymentMethod == 'cod') {
      // For COD, just create a pending payment record
      final paymentRecord = {
        'paymentId': PaymentHelper.generatePaymentId(),
        'orderId': orderId,
        'userId': userId,
        'amount': totalAmount,
        'currency': 'INR',
        'paymentMethod': 'cod',
        'paymentStatus': 'pending',
        'createdAt': DateTime.now(),
      };

      await MongoService.payments!.insertOne(paymentRecord);

      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'COD order placed successfully',
          'data': {
            'orderId': orderId,
            'paymentMethod': 'cod',
            'paymentStatus': 'pending',
            'amount': totalAmount,
          },
        },
      );
    } else if (paymentMethod == 'online') {
      // For online payment, create a Razorpay order
      final receipt = 'receipt_${DateTime.now().millisecondsSinceEpoch}';
      final razorpayOrder = PaymentHelper.createRazorpayOrder(
        amount: totalAmount,
        currency: 'INR',
        receipt: receipt,
      );

      // Create payment record with Razorpay order ID
      final paymentRecord = {
        'paymentId': PaymentHelper.generatePaymentId(),
        'orderId': orderId,
        'userId': userId,
        'amount': totalAmount,
        'currency': 'INR',
        'paymentMethod': 'online',
        'paymentStatus': 'pending',
        'razorpayOrderId': razorpayOrder['id'],
        'createdAt': DateTime.now(),
      };

      await MongoService.payments!.insertOne(paymentRecord);

      // Update order with Razorpay order ID
      await MongoService.orders!.updateOne(
        {'orderId': orderId},
        {
          '\$set': {
            'razorpayOrderId': razorpayOrder['id'],
            'paymentStatus': 'pending',
            'updatedAt': DateTime.now(),
          },
        },
      );

      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'Payment initiated successfully',
          'data': {
            'orderId': orderId,
            'razorpayOrderId': razorpayOrder['id'],
            'amount': totalAmount,
            'currency': 'INR',
            'razorpayKey': PaymentHelper.RAZORPAY_KEY,
          },
        },
      );
    } else {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid payment method'},
      );
    }
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: ${e.toString()}'},
    );
  }
}

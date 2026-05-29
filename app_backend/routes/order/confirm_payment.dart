// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars, unused_local_variable, avoid_redundant_argument_values

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
 
import 'package:my_backend/config/env.dart';
 import 'package:my_backend/db/mongo.dart';

/// POST /order/confirm_payment
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /order/confirm_payment API HIT');

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
    final paymentIntentId = body['paymentIntentId']?.toString();

    if (orderId == null || orderId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Order ID required'},
      );
    }

    // Find order
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

    // Verify payment method is online
    if (order['paymentMethod'] != 'online') {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'Invalid payment method for this order',
        },
      );
    }

    // For demo purposes, we'll simulate successful payment
    // In production, you would verify with Stripe:
    // final paymentIntent = await Stripe.instance.retrievePaymentIntent(paymentIntentId);
    // if (paymentIntent.status == 'succeeded') {

    // Simulate payment success
    final updateData = {
      'paymentStatus': 'completed',
      'orderStatus': 'pending', // Now pending confirmation from seller
      'paymentConfirmedAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    final result = await MongoService.orders!.updateOne(
      {'orderId': orderId},
      {r'$set': updateData},
    );

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to update payment status'},
      );
    }

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Payment confirmed successfully',
        'data': {
          'orderId': orderId,
          'orderStatus': 'pending',
          'paymentStatus': 'completed',
        },
      },
    );

    // } else {
    //   return Response.json(
    //     statusCode: 400,
    //     body: {'success': false, 'message': 'Payment not successful'},
    //   );
    // }
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

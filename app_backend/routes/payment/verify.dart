// ignore_for_file: avoid_print, avoid_dynamic_calls, unused_local_variable, avoid_redundant_argument_values, lines_longer_than_80_chars

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/utils/payment_helper.dart';

/// POST /payment/verify
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /payment/verify API HIT');

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
    final razorpayPaymentId = body['razorpayPaymentId']?.toString();
    final razorpayOrderId = body['razorpayOrderId']?.toString();
    final razorpaySignature = body['razorpaySignature']?.toString();

    if (orderId == null || orderId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Order ID required'},
      );
    }

    if (razorpayPaymentId == null || razorpayPaymentId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Payment ID required'},
      );
    }

    // Get payment record
    final payment = await MongoService.payments!.findOne({'orderId': orderId});

    if (payment == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Payment record not found'},
      );
    }

    // Verify payment signature
    final isValid = PaymentHelper.verifyPaymentSignature(
      orderId: razorpayOrderId ?? payment['razorpayOrderId']?.toString() ?? '',
      paymentId: razorpayPaymentId,
      signature: razorpaySignature ?? '',
    );

    if (!isValid) {
      // Update payment status to failed
      await MongoService.payments!.updateOne(
        {'orderId': orderId},
        {
          r'$set': {
            'paymentStatus': 'failed',
            'failureReason': 'Signature verification failed',
            'razorpayPaymentId': razorpayPaymentId,
            'updatedAt': DateTime.now(),
          },
        },
      );

      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Payment verification failed'},
      );
    }

    // Update payment record as completed
    await MongoService.payments!.updateOne(
      {'orderId': orderId},
      {
        r'$set': {
          'paymentStatus': 'completed',
          'razorpayPaymentId': razorpayPaymentId,
          'razorpaySignature': razorpaySignature,
          'completedAt': DateTime.now(),
          'paymentDetails': {
            'paymentId': razorpayPaymentId,
            'verifiedAt': DateTime.now().toIso8601String(),
          },
          'updatedAt': DateTime.now(),
        },
      },
    );

    // Update order payment status
    await MongoService.orders!.updateOne(
      {'orderId': orderId},
      {
        r'$set': {
          'paymentStatus': 'completed',
          'orderStatus': 'pending', // Now pending seller confirmation
          'razorpayPaymentId': razorpayPaymentId,
          'updatedAt': DateTime.now(),
        },
      },
    );

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Payment verified successfully',
        'data': {
          'orderId': orderId,
          'paymentStatus': 'completed',
          'orderStatus': 'pending',
        },
      },
    );
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

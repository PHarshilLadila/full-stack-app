// ignore_for_file: avoid_print, avoid_dynamic_calls

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// GET /payment/status?orderId=xxx
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /payment/status API HIT');

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

    final queryParams = context.request.uri.queryParameters;
    final orderId = queryParams['orderId'];

    if (orderId == null || orderId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Order ID required'},
      );
    }

    // Get payment record
    final payment = await MongoService.payments!.findOne({
      'orderId': orderId,
      'userId': userId,
    });

    if (payment == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Payment record not found'},
      );
    }

    // Get order status
    final order = await MongoService.orders!.findOne({'orderId': orderId});

    // Convert DateTime to string to avoid serialization issues
    final responseData = {
      'paymentId': payment['paymentId']?.toString() ?? '',
      'orderId': payment['orderId']?.toString() ?? '',
      'amount': (payment['amount'] as num?)?.toDouble() ?? 0.0,
      'paymentMethod': payment['paymentMethod']?.toString() ?? '',
      'paymentStatus': payment['paymentStatus']?.toString() ?? '',
      'orderStatus': order?['orderStatus']?.toString() ?? 'pending',
      'completedAt':
          payment['completedAt'] != null
              ? (payment['completedAt'] as DateTime).toIso8601String()
              : null,
      'razorpayPaymentId': payment['razorpayPaymentId']?.toString(),
      'createdAt':
          payment['createdAt'] != null
              ? (payment['createdAt'] as DateTime).toIso8601String()
              : null,
    };

    return Response.json(
      statusCode: 200,
      body: {'success': true, 'data': responseData},
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

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:uuid/uuid.dart';

class PaymentHelper {
  static const String RAZORPAY_KEY = "rzp_test_fake_key_12345";
  static const String RAZORPAY_SECRET = "fake_secret_12345";

  /// Generate a unique payment ID
  static String generatePaymentId() {
    final uuid = Uuid();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'PAY_${timestamp}_${uuid.v4().substring(0, 8)}';
  }

  /// Generate a fake Razorpay order ID
  static String generateRazorpayOrderId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(999999);
    return 'order_${timestamp}_$randomNum';
  }

  /// Create a fake Razorpay order (simulates creating order on Razorpay)
  static Map<String, dynamic> createRazorpayOrder({
    required double amount,
    required String currency,
    required String receipt,
  }) {
    final orderId = generateRazorpayOrderId();
    
    return {
      'id': orderId,
      'entity': 'order',
      'amount': (amount * 100).toInt(), // Amount in paise
      'amount_paid': 0,
      'amount_due': (amount * 100).toInt(),
      'currency': currency,
      'receipt': receipt,
      'status': 'created',
      'attempts': 0,
      'notes': [],
      'created_at': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
  }

  /// Generate fake payment signature
  static String generateFakeSignature(String orderId, String paymentId) {
    // This is a fake signature generator for testing
    final data = '$orderId|$paymentId|${RAZORPAY_SECRET}';
    return _fakeHash(data);
  }

  static String _fakeHash(String input) {
    // Simple fake hash for demo purposes
    final bytes = utf8.encode(input);
    final hash = bytes.fold<int>(0, (prev, byte) => prev ^ byte);
    return 'sig_${DateTime.now().millisecondsSinceEpoch}_$hash';
  }

  /// Verify payment signature (fake verification for testing)
  static bool verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) {
    // In production, this would verify with actual Razorpay secret
    // For demo, we accept any non-empty signature
    return signature.isNotEmpty && signature.startsWith('sig_');
  }

  /// Create a payment record
  static Map<String, dynamic> createPaymentRecord({
    required String orderId,
    required String userId,
    required double amount,
    required String paymentMethod,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
  }) {
    return {
      'paymentId': generatePaymentId(),
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'currency': 'INR',
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentMethod == 'cod' ? 'pending' : 'pending',
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
      'createdAt': DateTime.now(),
    };
  }
}
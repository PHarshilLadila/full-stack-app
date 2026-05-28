// ignore_for_file: public_member_api_docs

import 'package:mongo_dart/mongo_dart.dart';

class PaymentModel {
  final ObjectId? id;
  final String paymentId;
  final String orderId;
  final String userId;
  final double amount;
  final String currency;
  final String paymentMethod; // 'cod', 'online'
  final String paymentStatus; // 'pending', 'completed', 'failed', 'refunded'
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpaySignature;
  final Map<String, dynamic>? paymentDetails;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  PaymentModel({
    this.id,
    required this.paymentId,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.paymentStatus,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
    this.paymentDetails,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'paymentId': paymentId,
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
      'paymentDetails': paymentDetails,
      'createdAt': createdAt,
      'completedAt': completedAt,
      'failureReason': failureReason,
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'] as ObjectId?,
      paymentId: json['paymentId']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'INR',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      razorpayOrderId: json['razorpayOrderId']?.toString(),
      razorpayPaymentId: json['razorpayPaymentId']?.toString(),
      razorpaySignature: json['razorpaySignature']?.toString(),
      paymentDetails: json['paymentDetails'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as DateTime? ?? DateTime.now(),
      completedAt: json['completedAt'] as DateTime?,
      failureReason: json['failureReason']?.toString(),
    );
  }
}
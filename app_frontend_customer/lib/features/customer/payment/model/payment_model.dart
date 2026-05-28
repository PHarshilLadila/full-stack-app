import 'package:equatable/equatable.dart';

class PaymentInitiateResponse extends Equatable {
  final bool success;
  final String message;
  final PaymentInitiateData? data;

  const PaymentInitiateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PaymentInitiateResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInitiateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? PaymentInitiateData.fromJson(json['data'])
          : null,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

class PaymentInitiateData extends Equatable {
  final String orderId;
  final String? razorpayOrderId;
  final double amount;
  final String currency;
  final String? razorpayKey;

  const PaymentInitiateData({
    required this.orderId,
    this.razorpayOrderId,
    required this.amount,
    required this.currency,
    this.razorpayKey,
  });

  factory PaymentInitiateData.fromJson(Map<String, dynamic> json) {
    return PaymentInitiateData(
      orderId: json['orderId'] ?? '',
      razorpayOrderId: json['razorpayOrderId'],
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'INR',
      razorpayKey: json['razorpayKey'],
    );
  }

  @override
  List<Object?> get props => [orderId, razorpayOrderId, amount, currency, razorpayKey];
}

class PaymentVerifyResponse extends Equatable {
  final bool success;
  final String message;
  final PaymentVerifyData? data;

  const PaymentVerifyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PaymentVerifyResponse.fromJson(Map<String, dynamic> json) {
    return PaymentVerifyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? PaymentVerifyData.fromJson(json['data'])
          : null,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

class PaymentVerifyData extends Equatable {
  final String orderId;
  final String paymentStatus;
  final String orderStatus;

  const PaymentVerifyData({
    required this.orderId,
    required this.paymentStatus,
    required this.orderStatus,
  });

  factory PaymentVerifyData.fromJson(Map<String, dynamic> json) {
    return PaymentVerifyData(
      orderId: json['orderId'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
    );
  }

  @override
  List<Object?> get props => [orderId, paymentStatus, orderStatus];
}

class PaymentStatusResponse extends Equatable {
  final bool success;
  final PaymentStatusData? data;

  const PaymentStatusResponse({
    required this.success,
    this.data,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? PaymentStatusData.fromJson(json['data'])
          : null,
    );
  }

  @override
  List<Object?> get props => [success, data];
}

class PaymentStatusData extends Equatable {
  final String paymentId;
  final String orderId;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String? completedAt;
  final String? razorpayPaymentId;
  final String? createdAt;

  const PaymentStatusData({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.completedAt,
    this.razorpayPaymentId,
    this.createdAt,
  });

  factory PaymentStatusData.fromJson(Map<String, dynamic> json) {
    return PaymentStatusData(
      paymentId: json['paymentId'] ?? '',
      orderId: json['orderId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      completedAt: json['completedAt'],
      razorpayPaymentId: json['razorpayPaymentId'],
      createdAt: json['createdAt'],
    );
  }

  @override
  List<Object?> get props => [
    paymentId,
    orderId,
    amount,
    paymentMethod,
    paymentStatus,
    orderStatus,
    completedAt,
    razorpayPaymentId,
    createdAt,
  ];
}
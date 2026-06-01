// lib/features/customer/checkout/model/checkout_model.dart

import 'package:equatable/equatable.dart';

// Add this class if not already present
class DirectProductInfo extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double discountPrice;
  final int quantity;
  final double finalPrice;
  final String sellerName;

  const DirectProductInfo({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.discountPrice,
    required this.quantity,
    required this.finalPrice,
    required this.sellerName,
  });

  factory DirectProductInfo.fromJson(Map<String, dynamic> json) {
    return DirectProductInfo(
      productId: json['_id'] ?? json['id'] ?? '',
      productName: json['productName'] ?? json['name'] ?? '',
      productImage: json['mainBannerImage'] ?? json['productImage'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: 1,
      finalPrice:
          (json['discountedPrice'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      sellerName: json['sellerName'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    productImage,
    price,
    discountPrice,
    quantity,
    finalPrice,
    sellerName,
  ];
}

// Rest of your existing model classes (CreateOrderRequest, DirectProduct, OrderResponse, OrderData, ConfirmPaymentRequest)
class CreateOrderRequest extends Equatable {
  final String addressId;
  final String paymentMethod;
  final bool isDirectOrder;
  final DirectProduct? directProduct;

  const CreateOrderRequest({
    required this.addressId,
    required this.paymentMethod,
    this.isDirectOrder = false,
    this.directProduct,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'addressId': addressId,
      'paymentMethod': paymentMethod,
    };

    if (isDirectOrder) {
      data['isDirectOrder'] = true;
      data['directProduct'] = directProduct?.toJson();
    }

    return data;
  }

  @override
  List<Object?> get props => [
    addressId,
    paymentMethod,
    isDirectOrder,
    directProduct,
  ];
}

class DirectProduct extends Equatable {
  final String productId;
  final int quantity;

  const DirectProduct({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }

  @override
  List<Object?> get props => [productId, quantity];
}

class OrderResponse extends Equatable {
  final bool success;
  final String message;
  final OrderData? data;

  const OrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

class OrderData extends Equatable {
  final String orderId;
  final double totalAmount;
  final String paymentMethod;
  final String? paymentIntentId;
  final String? clientSecret;

  const OrderData({
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
    this.paymentIntentId,
    this.clientSecret,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderId: json['orderId'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      paymentIntentId: json['paymentIntentId'],
      clientSecret: json['clientSecret'],
    );
  }

  @override
  List<Object?> get props => [
    orderId,
    totalAmount,
    paymentMethod,
    paymentIntentId,
    clientSecret,
  ];
}

class ConfirmPaymentRequest extends Equatable {
  final String orderId;
  final String paymentIntentId;

  const ConfirmPaymentRequest({
    required this.orderId,
    required this.paymentIntentId,
  });

  Map<String, dynamic> toJson() {
    return {'orderId': orderId, 'paymentIntentId': paymentIntentId};
  }

  @override
  List<Object?> get props => [orderId, paymentIntentId];
}

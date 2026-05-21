import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double discountPrice;
  final int quantity;
  final String sellerId;
  final String sellerName;
  final bool isAvailable;
  final int availableStock;
  final double totalPrice;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.discountPrice,
    required this.quantity,
    required this.sellerId,
    required this.sellerName,
    required this.isAvailable,
    required this.availableStock,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      availableStock: json['availableStock'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'discountPrice': discountPrice,
      'quantity': quantity,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'isAvailable': isAvailable,
      'availableStock': availableStock,
      'totalPrice': totalPrice,
    };
  }

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    double? discountPrice,
    int? quantity,
    String? sellerId,
    String? sellerName,
    bool? isAvailable,
    int? availableStock,
    double? totalPrice,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      quantity: quantity ?? this.quantity,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      isAvailable: isAvailable ?? this.isAvailable,
      availableStock: availableStock ?? this.availableStock,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  double get finalPrice => discountPrice > 0 ? discountPrice : price;
  double get itemTotal => finalPrice * quantity;
  double get savedAmount => (price - finalPrice) * quantity;

  @override
  List<Object?> get props => [
    productId,
    productName,
    productImage,
    price,
    discountPrice,
    quantity,
    sellerId,
    sellerName,
    isAvailable,
    availableStock,
    totalPrice,
  ];
}

class CartSummary extends Equatable {
  final List<CartItem> items;
  final double totalAmount;
  final double discountAmount;
  final double finalAmount;
  final int itemCount;

  const CartSummary({
    required this.items,
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.itemCount,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return CartSummary(
      items: itemsList.map((item) => CartItem.fromJson(item)).toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      finalAmount: (json['finalAmount'] ?? 0).toDouble(),
      itemCount: json['itemCount'] ?? 0,
    );
  }

  CartSummary copyWith({
    List<CartItem>? items,
    double? totalAmount,
    double? discountAmount,
    double? finalAmount,
    int? itemCount,
  }) {
    return CartSummary(
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  List<Object?> get props => [items, totalAmount, discountAmount, finalAmount, itemCount];
}

class AddToCartResponse extends Equatable {
  final bool success;
  final String message;
  final AddToCartData? data;

  const AddToCartResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AddToCartData.fromJson(json['data']) : null,
    );
  }

  @override
  List<Object?> get props => [success, message, data];
}

class AddToCartData extends Equatable {
  final String productId;
  final int quantity;
  final double cartTotal;

  const AddToCartData({
    required this.productId,
    required this.quantity,
    required this.cartTotal,
  });

  factory AddToCartData.fromJson(Map<String, dynamic> json) {
    return AddToCartData(
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
      cartTotal: (json['cartTotal'] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [productId, quantity, cartTotal];
}
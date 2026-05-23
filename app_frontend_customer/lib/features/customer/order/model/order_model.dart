import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final String orderId;
  final List<OrderItem> items;
  final ShippingAddress shippingAddress;
  final double subtotal;
  final double shippingCharge;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String? trackingId;
  final DateTime orderDate;
  final DateTime? deliveredDate;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.orderId,
    required this.items,
    required this.shippingAddress,
    required this.subtotal,
    required this.shippingCharge,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.trackingId,
    required this.orderDate,
    this.deliveredDate,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle different response structures
    List<OrderItem> itemsList = [];
    
    if (json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList();
    } else if (json['product'] != null) {
      // Handle single product direct order response
      itemsList = [OrderItem.fromJson(json['product'])];
    }

    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      orderId: json['orderId'] ?? json['order_id'] ?? '',
      items: itemsList,
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(json['shippingAddress'])
          : ShippingAddress(
              fullName: '',
              mobileNumber: '',
              pincode: '',
              addressLine1: '',
              addressLine2: '',
              landmark: '',
              city: '',
              state: '',
              country: '',
            ),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingCharge: (json['shippingCharge'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? json['payment_method'] ?? '',
      paymentStatus: json['paymentStatus'] ?? json['payment_status'] ?? '',
      orderStatus: json['orderStatus'] ?? json['order_status'] ?? '',
      trackingId: json['trackingId'] ?? json['tracking_id'],
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      deliveredDate: json['deliveredDate'] != null
          ? DateTime.parse(json['deliveredDate'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderId': orderId,
      'items': items.map((item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'subtotal': subtotal,
      'shippingCharge': shippingCharge,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'trackingId': trackingId,
      'orderDate': orderDate.toIso8601String(),
      'deliveredDate': deliveredDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        items,
        shippingAddress,
        subtotal,
        shippingCharge,
        discountAmount,
        taxAmount,
        totalAmount,
        paymentMethod,
        paymentStatus,
        orderStatus,
        trackingId,
        orderDate,
        deliveredDate,
        createdAt,
      ];
}

class OrderItem extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double discountPrice;
  final int quantity;
  final double totalPrice;
  final String sellerId;
  final String sellerName;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.discountPrice,
    required this.quantity,
    required this.totalPrice,
    required this.sellerId,
    required this.sellerName,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Handle different key names that might come from API
    return OrderItem(
      productId: json['productId'] ?? json['product_id'] ?? json['_id'] ?? '',
      productName: json['productName'] ?? json['product_name'] ?? json['name'] ?? 'Product',
      productImage: json['productImage'] ?? json['product_image'] ?? json['mainBannerImage'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble() ?? (json['discount_price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? json['qty'] ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? (json['total_price'] as num?)?.toDouble() ?? 0.0,
      sellerId: json['sellerId'] ?? json['seller_id'] ?? '',
      sellerName: json['sellerName'] ?? json['seller_name'] ?? 'Seller',
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
      'totalPrice': totalPrice,
      'sellerId': sellerId,
      'sellerName': sellerName,
    };
  }

  @override
  List<Object?> get props => [
        productId,
        productName,
        productImage,
        price,
        discountPrice,
        quantity,
        totalPrice,
        sellerId,
        sellerName,
      ];
}

class ShippingAddress extends Equatable {
  final String fullName;
  final String mobileNumber;
  final String pincode;
  final String addressLine1;
  final String addressLine2;
  final String landmark;
  final String city;
  final String state;
  final String country;

  const ShippingAddress({
    required this.fullName,
    required this.mobileNumber,
    required this.pincode,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      mobileNumber: json['mobileNumber'] ?? json['mobile_number'] ?? '',
      pincode: json['pincode'] ?? '',
      addressLine1: json['addressLine1'] ?? json['address_line1'] ?? '',
      addressLine2: json['addressLine2'] ?? json['address_line2'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'pincode': pincode,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'landmark': landmark,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  @override
  List<Object?> get props => [
        fullName,
        mobileNumber,
        pincode,
        addressLine1,
        addressLine2,
        landmark,
        city,
        state,
        country,
      ];
}

class PaginationInfo extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  const PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] ?? json['current_page'] ?? 1,
      totalPages: json['totalPages'] ?? json['total_pages'] ?? 1,
      totalItems: json['totalItems'] ?? json['total_items'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? json['items_per_page'] ?? 10,
    );
  }

  @override
  List<Object?> get props => [currentPage, totalPages, totalItems, itemsPerPage];
}
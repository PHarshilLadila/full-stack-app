import 'package:equatable/equatable.dart';

class SellerOrderModel extends Equatable {
  final String id;
  final String orderId;
  final List<SellerOrderItem> items;
  final CustomerInfo customer;
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

  const SellerOrderModel({
    required this.id,
    required this.orderId,
    required this.items,
    required this.customer,
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

  factory SellerOrderModel.fromJson(Map<String, dynamic> json) {
    return SellerOrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      orderId: json['orderId'] ?? json['order_id'] ?? '',
      items:
          (json['items'] as List?)
              ?.map((item) => SellerOrderItem.fromJson(item))
              .toList() ??
          [],
      customer: CustomerInfo.fromJson(json['customer'] ?? {}),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress'] ?? {}),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingCharge: (json['shippingCharge'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      trackingId: json['trackingId'],
      orderDate:
          json['orderDate'] != null
              ? DateTime.parse(json['orderDate'])
              : DateTime.now(),
      deliveredDate:
          json['deliveredDate'] != null
              ? DateTime.parse(json['deliveredDate'])
              : null,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    items,
    customer,
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

class SellerOrderItem extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double discountPrice;
  final int quantity;
  final double totalPrice;
  final String sellerId;
  final String sellerName;

  const SellerOrderItem({
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

  factory SellerOrderItem.fromJson(Map<String, dynamic> json) {
    return SellerOrderItem(
      productId: json['productId'] ?? json['product_id'] ?? '',
      productName: json['productName'] ?? json['product_name'] ?? '',
      productImage: json['productImage'] ?? json['product_image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      sellerId: json['sellerId'] ?? json['seller_id'] ?? '',
      sellerName: json['sellerName'] ?? json['seller_name'] ?? '',
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
    totalPrice,
    sellerId,
    sellerName,
  ];
}

class CustomerInfo extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;

  const CustomerInfo({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? json['mobile_number'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, mobileNumber];
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
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 10,
    );
  }

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    totalItems,
    itemsPerPage,
  ];
}

class OrderStatusUpdateRequest extends Equatable {
  final String orderId;
  final String orderStatus;
  final String? trackingId;

  const OrderStatusUpdateRequest({
    required this.orderId,
    required this.orderStatus,
    this.trackingId,
  });

  Map<String, dynamic> toJson() {
    final data = {'orderId': orderId, 'orderStatus': orderStatus};
    if (trackingId != null) {
      data['trackingId'] = trackingId ?? "";
    }
    return data;
  }

  @override
  List<Object?> get props => [orderId, orderStatus, trackingId];
}

class OrderStats extends Equatable {
  final int totalOrders;
  final int pendingOrders;
  final int confirmedOrders;
  final int shippedOrders;
  final int outForDeliveryOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final double totalRevenue;

  const OrderStats({
    required this.totalOrders,
    required this.pendingOrders,
    required this.confirmedOrders,
    required this.shippedOrders,
    required this.outForDeliveryOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.totalRevenue,
  });

  factory OrderStats.fromOrders(List<SellerOrderModel> orders) {
    int total = orders.length;
    int pending = orders.where((o) => o.orderStatus == 'pending').length;
    int confirmed = orders.where((o) => o.orderStatus == 'confirmed').length;
    int shipped = orders.where((o) => o.orderStatus == 'shipped').length;
    int outForDelivery =
        orders.where((o) => o.orderStatus == 'out_for_delivery').length;
    int delivered = orders.where((o) => o.orderStatus == 'delivered').length;
    int cancelled = orders.where((o) => o.orderStatus == 'cancelled').length;
    double revenue = orders
        .where((o) => o.orderStatus == 'delivered')
        .fold(0.0, (sum, o) => sum + o.totalAmount);

    return OrderStats(
      totalOrders: total,
      pendingOrders: pending,
      confirmedOrders: confirmed,
      shippedOrders: shipped,
      outForDeliveryOrders: outForDelivery,
      deliveredOrders: delivered,
      cancelledOrders: cancelled,
      totalRevenue: revenue,
    );
  }

  @override
  List<Object?> get props => [
    totalOrders,
    pendingOrders,
    confirmedOrders,
    shippedOrders,
    outForDeliveryOrders,
    deliveredOrders,
    cancelledOrders,
    totalRevenue,
  ];
}

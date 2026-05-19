// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:mongo_dart/mongo_dart.dart';

class SalesAnalytics {
  final double totalRevenue;
  final double totalProfit;
  final int totalOrders;
  final int totalProducts;
  final int totalCustomers;
  final double averageOrderValue;
  final double conversionRate;
  final Map<String, dynamic> periodData;

  SalesAnalytics({
    required this.totalRevenue,
    required this.totalProfit,
    required this.totalOrders,
    required this.totalProducts,
    required this.totalCustomers,
    required this.averageOrderValue,
    required this.conversionRate,
    required this.periodData,
  });

  Map<String, dynamic> toJson() => {
    'totalRevenue': totalRevenue,
    'totalProfit': totalProfit,
    'totalOrders': totalOrders,
    'totalProducts': totalProducts,
    'totalCustomers': totalCustomers,
    'averageOrderValue': averageOrderValue,
    'conversionRate': conversionRate,
    'periodData': periodData,
  };
}

class ProductPerformance {
  final String productId;
  final String productName;
  final String productImage;
  final int totalSold;
  final double totalRevenue;
  final int totalViews;
  final int totalOrders;
  final double rating;
  final int reviews;
  final double conversionRate;
  final double stockAvailable;
  final bool isLowStock;

  ProductPerformance({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.totalSold,
    required this.totalRevenue,
    required this.totalViews,
    required this.totalOrders,
    required this.rating,
    required this.reviews,
    required this.conversionRate,
    required this.stockAvailable,
    required this.isLowStock,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'totalSold': totalSold,
    'totalRevenue': totalRevenue,
    'totalViews': totalViews,
    'totalOrders': totalOrders,
    'rating': rating,
    'reviews': reviews,
    'conversionRate': conversionRate,
    'stockAvailable': stockAvailable,
    'isLowStock': isLowStock,
  };
}

class OrderStatusAnalytics {
  final int pending;
  final int confirmed;
  final int shipped;
  final int outForDelivery;
  final int delivered;
  final int cancelled;
  final int returned;

  OrderStatusAnalytics({
    required this.pending,
    required this.confirmed,
    required this.shipped,
    required this.outForDelivery,
    required this.delivered,
    required this.cancelled,
    required this.returned,
  });

  Map<String, dynamic> toJson() => {
    'pending': pending,
    'confirmed': confirmed,
    'shipped': shipped,
    'outForDelivery': outForDelivery,
    'delivered': delivered,
    'cancelled': cancelled,
    'returned': returned,
  };
}

class RevenueAnalytics {
  final double daily;
  final double weekly;
  final double monthly;
  final double yearly;
  final Map<String, double> breakdown;

  RevenueAnalytics({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.yearly,
    required this.breakdown,
  });

  Map<String, dynamic> toJson() => {
    'daily': daily,
    'weekly': weekly,
    'monthly': monthly,
    'yearly': yearly,
    'breakdown': breakdown,
  };
}

class TopProductsAnalytics {
  final List<ProductPerformance> bestSelling;
  final List<ProductPerformance> topRated;
  final List<ProductPerformance> mostViewed;
  final List<ProductPerformance> lowStock;
  final List<ProductPerformance> outOfStock;

  TopProductsAnalytics({
    required this.bestSelling,
    required this.topRated,
    required this.mostViewed,
    required this.lowStock,
    required this.outOfStock,
  });

  Map<String, dynamic> toJson() => {
    'bestSelling': bestSelling.map((e) => e.toJson()).toList(),
    'topRated': topRated.map((e) => e.toJson()).toList(),
    'mostViewed': mostViewed.map((e) => e.toJson()).toList(),
    'lowStock': lowStock.map((e) => e.toJson()).toList(),
    'outOfStock': outOfStock.map((e) => e.toJson()).toList(),
  };
}

class CustomerAnalytics {
  final int totalCustomers;
  final int newCustomers;
  final int repeatCustomers;
  final double customerRetentionRate;
  final double averageOrderPerCustomer;
  final double lifetimeValue;

  CustomerAnalytics({
    required this.totalCustomers,
    required this.newCustomers,
    required this.repeatCustomers,
    required this.customerRetentionRate,
    required this.averageOrderPerCustomer,
    required this.lifetimeValue,
  });

  Map<String, dynamic> toJson() => {
    'totalCustomers': totalCustomers,
    'newCustomers': newCustomers,
    'repeatCustomers': repeatCustomers,
    'customerRetentionRate': customerRetentionRate,
    'averageOrderPerCustomer': averageOrderPerCustomer,
    'lifetimeValue': lifetimeValue,
  };
}

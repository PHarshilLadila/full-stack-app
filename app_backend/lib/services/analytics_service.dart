// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/db/mongo.dart';

class AnalyticsService {
  final String sellerId;

  AnalyticsService({required this.sellerId});

  /// Get all product IDs for this seller
  Future<List<String>> _getSellerProductIds() async {
    final products =
        await MongoService.products!.find({'sellerId': sellerId}).toList();

    return products.map((p) => (p['_id'] as ObjectId).oid).toList();
  }

  /// Get orders for seller's products
  Future<List<Map<String, dynamic>>> _getSellerOrders() async {
    final productIds = await _getSellerProductIds();

    if (productIds.isEmpty) {
      return [];
    }

    /// FIXED HERE
    /// DO NOT USE find({})
    final allOrders = await MongoService.orders!.find().toList();

    final List<Map<String, dynamic>> sellerOrders = [];

    for (final order in allOrders) {
      final items = order['items'] as List? ?? [];

      final sellerItems =
          items.where((item) {
            final itemSellerId = item['sellerId']?.toString();
            return itemSellerId == sellerId;
          }).toList();

      if (sellerItems.isNotEmpty) {
        double sellerTotal = 0;

        for (final item in sellerItems) {
          sellerTotal += (item['totalPrice'] as num?)?.toDouble() ?? 0;
        }

        final Map<String, dynamic> newOrder = {
          ...order,
          'sellerItems': sellerItems,
          'sellerTotal': sellerTotal,
        };

        sellerOrders.add(newOrder);
      }
    }

    return sellerOrders;
  }

  /// Get date range filter
  Map<String, DateTime> _getDateRange(
    String period, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final now = DateTime.now();

    DateTime start;
    DateTime end = endDate ?? now;

    if (startDate != null && endDate != null) {
      return {'start': startDate, 'end': endDate};
    }

    switch (period) {
      case 'today':
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;

      case 'yesterday':
        start = DateTime(now.year, now.month, now.day - 1);

        end = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
        break;

      case 'week':
        start = DateTime(now.year, now.month, now.day - 7);
        break;

      case 'month':
        start = DateTime(now.year, now.month - 1, now.day);
        break;

      case 'year':
        start = DateTime(now.year - 1, now.month, now.day);
        break;

      default:
        start = DateTime(now.year, now.month, now.day - 30);
    }

    return {'start': start, 'end': end};
  }

  /// Filter orders by date range
  List<Map<String, dynamic>> _filterOrdersByDate(
    List<Map<String, dynamic>> orders,
    DateTime start,
    DateTime end,
  ) {
    return orders.where((order) {
      final orderDate =
          order['createdAt'] is DateTime
              ? order['createdAt'] as DateTime
              : DateTime.tryParse(order['createdAt'].toString()) ??
                  DateTime.now();

      return orderDate.isAfter(start) && orderDate.isBefore(end);
    }).toList();
  }

  /// Get sales analytics
  Future<Map<String, dynamic>> getSalesAnalytics({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final orders = await _getSellerOrders();

    final dateRange = _getDateRange(
      period,
      startDate: startDate,
      endDate: endDate,
    );

    final filteredOrders = _filterOrdersByDate(
      orders,
      dateRange['start']!,
      dateRange['end']!,
    );

    double totalRevenue = 0;

    int totalOrders = filteredOrders.length;

    final uniqueCustomers = <String>{};

    for (final order in filteredOrders) {
      totalRevenue += (order['sellerTotal'] as num?)?.toDouble() ?? 0;

      uniqueCustomers.add(order['userId']?.toString() ?? '');
    }

    final averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;

    final totalProducts = (await _getSellerProductIds()).length;

    return {
      'totalRevenue': totalRevenue,
      'totalProfit': totalRevenue * 0.7,
      'totalOrders': totalOrders,
      'totalProducts': totalProducts,
      'totalCustomers': uniqueCustomers.length,
      'averageOrderValue': averageOrderValue,
      'conversionRate': 0.0,
      'periodData': {
        'startDate': dateRange['start']!.toIso8601String(),
        'endDate': dateRange['end']!.toIso8601String(),
        'period': period,
      },
    };
  }

  /// Get product performance
  Future<List<Map<String, dynamic>>> getProductPerformance() async {
    final products =
        await MongoService.products!.find({'sellerId': sellerId}).toList();

    final orders = await _getSellerOrders();

    final productPerformance = <String, Map<String, dynamic>>{};

    /// Initialize product data
    for (final product in products) {
      final productId = (product['_id'] as ObjectId).oid;

      productPerformance[productId] = {
        'productId': productId,
        'productName': product['productName']?.toString() ?? '',
        'productImage': product['mainBannerImage']?.toString() ?? '',
        'totalSold': 0,
        'totalRevenue': 0.0,
        'totalOrders': 0,
        'rating': (product['rating'] as num?)?.toDouble() ?? 0,
        'reviews': product['totalReviews'] as int? ?? 0,
        'stockAvailable': product['stock'] as int? ?? 0,
        'isLowStock': (product['stock'] as int? ?? 0) < 10,
      };
    }

    /// Calculate sales data
    for (final order in orders) {
      final items = order['sellerItems'] as List? ?? [];

      for (final item in items) {
        final productId = item['productId']?.toString();

        if (productId != null && productPerformance.containsKey(productId)) {
          final quantity = item['quantity'] as int? ?? 1;

          final price = (item['totalPrice'] as num?)?.toDouble() ?? 0;

          productPerformance[productId]!['totalSold'] =
              (productPerformance[productId]!['totalSold'] as int) + quantity;

          productPerformance[productId]!['totalRevenue'] =
              (productPerformance[productId]!['totalRevenue'] as double) +
              price;

          productPerformance[productId]!['totalOrders'] =
              (productPerformance[productId]!['totalOrders'] as int) + 1;
        }
      }
    }

    /// Calculate conversion rate
    for (final productId in productPerformance.keys) {
      final views = await _getProductViews(productId);

      final totalOrders = productPerformance[productId]!['totalOrders'] as int;

      final conversionRate = views > 0 ? (totalOrders / views) * 100 : 0.0;

      productPerformance[productId]!['conversionRate'] = conversionRate;

      productPerformance[productId]!['totalViews'] = views;
    }

    return productPerformance.values.toList();
  }

  Future<int> _getProductViews(String productId) async {
    return 0;
  }

  /// Get order status analytics
  Future<Map<String, int>> getOrderStatusAnalytics() async {
    final orders = await _getSellerOrders();

    final statusCount = <String, int>{
      'pending': 0,
      'confirmed': 0,
      'shipped': 0,
      'outForDelivery': 0,
      'delivered': 0,
      'cancelled': 0,
      'returned': 0,
    };

    for (final order in orders) {
      final status = order['orderStatus']?.toString() ?? 'pending';

      if (statusCount.containsKey(status)) {
        statusCount[status] = (statusCount[status] ?? 0) + 1;
      }
    }

    return statusCount;
  }

  /// Get revenue analytics by period
  Future<Map<String, dynamic>> getRevenueAnalytics() async {
    final orders = await _getSellerOrders();

    final daily = await _getRevenueForPeriod(orders, 'today');

    final weekly = await _getRevenueForPeriod(orders, 'week');

    final monthly = await _getRevenueForPeriod(orders, 'month');

    final yearly = await _getRevenueForPeriod(orders, 'year');

    final breakdown = await _getRevenueBreakdown(orders);

    return {
      'daily': daily,
      'weekly': weekly,
      'monthly': monthly,
      'yearly': yearly,
      'breakdown': breakdown,
    };
  }

  Future<double> _getRevenueForPeriod(
    List<Map<String, dynamic>> orders,
    String period,
  ) async {
    final dateRange = _getDateRange(period);

    final filteredOrders = _filterOrdersByDate(
      orders,
      dateRange['start']!,
      dateRange['end']!,
    );

    double revenue = 0;

    for (final order in filteredOrders) {
      revenue += (order['sellerTotal'] as num?)?.toDouble() ?? 0;
    }

    return revenue;
  }

  Future<Map<String, double>> _getRevenueBreakdown(
    List<Map<String, dynamic>> orders,
  ) async {
    final breakdown = <String, double>{};

    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));

      final key = '${date.day}/${date.month}';

      breakdown[key] = 0.0;
    }

    for (final order in orders) {
      final orderDate = order['createdAt'] as DateTime;

      final key = '${orderDate.day}/${orderDate.month}';

      if (breakdown.containsKey(key)) {
        final sellerTotal = order['sellerTotal'];

        double addAmount = 0.0;

        if (sellerTotal is num) {
          addAmount = sellerTotal.toDouble();
        } else if (sellerTotal is double) {
          addAmount = sellerTotal;
        } else if (sellerTotal is int) {
          addAmount = sellerTotal.toDouble();
        }

        breakdown[key] = (breakdown[key] ?? 0) + addAmount;
      }
    }

    return breakdown;
  }

  /// Get top products
  Future<Map<String, List<Map<String, dynamic>>>> getTopProducts() async {
    final performance = await getProductPerformance();

    final bestSelling = List<Map<String, dynamic>>.from(
      performance,
    )..sort((a, b) => (b['totalSold'] as int).compareTo(a['totalSold'] as int));

    final topRated = List<Map<String, dynamic>>.from(
      performance,
    )..sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));

    final mostViewed = List<Map<String, dynamic>>.from(performance)..sort(
      (a, b) => (b['totalViews'] as int).compareTo(a['totalViews'] as int),
    );

    final lowStock =
        performance
            .where(
              (p) =>
                  (p['isLowStock'] as bool) && (p['stockAvailable'] as int) > 0,
            )
            .toList()
          ..sort(
            (a, b) => (a['stockAvailable'] as int).compareTo(
              b['stockAvailable'] as int,
            ),
          );

    final outOfStock =
        performance.where((p) => (p['stockAvailable'] as int) == 0).toList();

    return {
      'bestSelling': bestSelling.take(10).toList(),
      'topRated': topRated.take(10).toList(),
      'mostViewed': mostViewed.take(10).toList(),
      'lowStock': lowStock,
      'outOfStock': outOfStock,
    };
  }

  /// Get customer analytics
  Future<Map<String, dynamic>> getCustomerAnalytics() async {
    final orders = await _getSellerOrders();

    final customerOrders = <String, List<Map<String, dynamic>>>{};

    for (final order in orders) {
      final userId = order['userId']?.toString();

      if (userId != null && userId.isNotEmpty) {
        customerOrders.putIfAbsent(userId, () => []);

        customerOrders[userId]!.add(order);
      }
    }

    final totalCustomers = customerOrders.length;

    final repeatCustomers =
        customerOrders.values.where((orders) => orders.length > 1).length;

    double totalRevenue = 0;

    for (final orders in customerOrders.values) {
      for (final order in orders) {
        final sellerTotal = order['sellerTotal'];

        if (sellerTotal is num) {
          totalRevenue += sellerTotal.toDouble();
        }
      }
    }

    final lifetimeValue =
        totalCustomers > 0 ? totalRevenue / totalCustomers : 0;

    final averageOrderPerCustomer =
        totalCustomers > 0 ? orders.length / totalCustomers : 0;

    final customerRetentionRate =
        totalCustomers > 0 ? (repeatCustomers / totalCustomers) * 100 : 0;

    return {
      'totalCustomers': totalCustomers,
      'newCustomers': 0,
      'repeatCustomers': repeatCustomers,
      'customerRetentionRate': customerRetentionRate,
      'averageOrderPerCustomer': averageOrderPerCustomer,
      'lifetimeValue': lifetimeValue,
    };
  }
}

// lib/features/analytics/models/analytics_models.dart

class DashboardAnalytics {
  final SalesOverview salesOverview;
  final OrderStatus orderStatus;
  final RevenueAnalytics revenueAnalytics;
  final TopProducts topProducts;
  final CustomerAnalytics customerAnalytics;
  final List<ProductPerformance> productPerformance;
  final Summary summary;

  DashboardAnalytics({
    required this.salesOverview,
    required this.orderStatus,
    required this.revenueAnalytics,
    required this.topProducts,
    required this.customerAnalytics,
    required this.productPerformance,
    required this.summary,
  });

  factory DashboardAnalytics.fromJson(Map<String, dynamic> json) {
    return DashboardAnalytics(
      salesOverview: SalesOverview.fromJson(json['salesOverview']),
      orderStatus: OrderStatus.fromJson(json['orderStatus']),
      revenueAnalytics: RevenueAnalytics.fromJson(json['revenueAnalytics']),
      topProducts: TopProducts.fromJson(json['topProducts']),
      customerAnalytics: CustomerAnalytics.fromJson(json['customerAnalytics']),
      productPerformance:
          (json['productPerformance'] as List)
              .map((e) => ProductPerformance.fromJson(e))
              .toList(),
      summary: Summary.fromJson(json['summary']),
    );
  }
}

class SalesOverview {
  final double totalRevenue;
  final double totalProfit;
  final int totalOrders;
  final int totalProducts;
  final int totalCustomers;
  final double averageOrderValue;
  final double conversionRate;
  final PeriodData periodData;

  SalesOverview({
    required this.totalRevenue,
    required this.totalProfit,
    required this.totalOrders,
    required this.totalProducts,
    required this.totalCustomers,
    required this.averageOrderValue,
    required this.conversionRate,
    required this.periodData,
  });

  factory SalesOverview.fromJson(Map<String, dynamic> json) {
    return SalesOverview(
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalProfit: (json['totalProfit'] ?? 0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      totalCustomers: json['totalCustomers'] ?? 0,
      averageOrderValue: (json['averageOrderValue'] ?? 0).toDouble(),
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      periodData: PeriodData.fromJson(json['periodData'] ?? {}),
    );
  }
}

class PeriodData {
  final String startDate;
  final String endDate;
  final String period;

  PeriodData({
    required this.startDate,
    required this.endDate,
    required this.period,
  });

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      period: json['period'] ?? '',
    );
  }
}

class OrderStatus {
  final int pending;
  final int confirmed;
  final int shipped;
  final int outForDelivery;
  final int delivered;
  final int cancelled;
  final int returned;

  OrderStatus({
    required this.pending,
    required this.confirmed,
    required this.shipped,
    required this.outForDelivery,
    required this.delivered,
    required this.cancelled,
    required this.returned,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      pending: json['pending'] ?? 0,
      confirmed: json['confirmed'] ?? 0,
      shipped: json['shipped'] ?? 0,
      outForDelivery: json['outForDelivery'] ?? 0,
      delivered: json['delivered'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      returned: json['returned'] ?? 0,
    );
  }

  int get total =>
      pending +
      confirmed +
      shipped +
      outForDelivery +
      delivered +
      cancelled +
      returned;
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

  factory RevenueAnalytics.fromJson(Map<String, dynamic> json) {
    return RevenueAnalytics(
      daily: (json['daily'] ?? 0).toDouble(),
      weekly: (json['weekly'] ?? 0).toDouble(),
      monthly: (json['monthly'] ?? 0).toDouble(),
      yearly: (json['yearly'] ?? 0).toDouble(),
      breakdown: Map<String, double>.from(json['breakdown'] ?? {}),
    );
  }
}

class TopProducts {
  final List<ProductPerformance> bestSelling;
  final List<ProductPerformance> topRated;
  final List<ProductPerformance> mostViewed;
  final List<ProductPerformance> lowStock;
  final List<ProductPerformance> outOfStock;

  TopProducts({
    required this.bestSelling,
    required this.topRated,
    required this.mostViewed,
    required this.lowStock,
    required this.outOfStock,
  });

  factory TopProducts.fromJson(Map<String, dynamic> json) {
    return TopProducts(
      bestSelling:
          (json['bestSelling'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      topRated:
          (json['topRated'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      mostViewed:
          (json['mostViewed'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      lowStock:
          (json['lowStock'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      outOfStock:
          (json['outOfStock'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ProductPerformance {
  final String productId;
  final String productName;
  final String productImage;
  final int totalSold;
  final double totalRevenue;
  final int totalOrders;
  final double rating;
  final int reviews;
  final int stockAvailable;
  final bool isLowStock;
  final double conversionRate;
  final int totalViews;

  ProductPerformance({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.totalSold,
    required this.totalRevenue,
    required this.totalOrders,
    required this.rating,
    required this.reviews,
    required this.stockAvailable,
    required this.isLowStock,
    required this.conversionRate,
    required this.totalViews,
  });

  factory ProductPerformance.fromJson(Map<String, dynamic> json) {
    return ProductPerformance(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      totalSold: json['totalSold'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      stockAvailable: json['stockAvailable'] ?? 0,
      isLowStock: json['isLowStock'] ?? false,
      conversionRate: (json['conversionRate'] ?? 0).toDouble(),
      totalViews: json['totalViews'] ?? 0,
    );
  }

  double get profit => totalRevenue * 0.7; // Approximate profit calculation
}

class CustomerAnalytics {
  final int totalCustomers;
  final int newCustomers;
  final int repeatCustomers;
  final double customerRetentionRate;
  final double averageOrderPerCustomer;
  final double lifetimeValue;
  final double averageRevenuePerCustomer;

  CustomerAnalytics({
    required this.totalCustomers,
    required this.newCustomers,
    required this.repeatCustomers,
    required this.customerRetentionRate,
    required this.averageOrderPerCustomer,
    required this.lifetimeValue,
    required this.averageRevenuePerCustomer,
  });

  factory CustomerAnalytics.fromJson(Map<String, dynamic> json) {
    return CustomerAnalytics(
      totalCustomers: json['totalCustomers'] ?? 0,
      newCustomers: json['newCustomers'] ?? 0,
      repeatCustomers: json['repeatCustomers'] ?? 0,
      customerRetentionRate: (json['customerRetentionRate'] ?? 0).toDouble(),
      averageOrderPerCustomer:
          (json['averageOrderPerCustomer'] ?? 0).toDouble(),
      lifetimeValue: (json['lifetimeValue'] ?? 0).toDouble(),
      averageRevenuePerCustomer:
          (json['averageRevenuePerCustomer'] ?? 0).toDouble(),
    );
  }
}

class Summary {
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final int totalCustomers;
  final int totalProducts;

  Summary({
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.totalCustomers,
    required this.totalProducts,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      averageOrderValue: (json['averageOrderValue'] ?? 0).toDouble(),
      totalCustomers: json['totalCustomers'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
    );
  }
}

// Order Analytics Model
class OrderAnalytics {
  final Map<String, int> orderStatusBreakdown;
  final int totalOrders;
  final int completedOrders;
  final int pendingOrders;
  final int cancelledOrders;
  final double orderCompletionRate;
  final double cancellationRate;

  OrderAnalytics({
    required this.orderStatusBreakdown,
    required this.totalOrders,
    required this.completedOrders,
    required this.pendingOrders,
    required this.cancelledOrders,
    required this.orderCompletionRate,
    required this.cancellationRate,
  });

  factory OrderAnalytics.fromJson(Map<String, dynamic> json) {
    return OrderAnalytics(
      orderStatusBreakdown: Map<String, int>.from(
        json['orderStatusBreakdown'] ?? {},
      ),
      totalOrders: json['totalOrders'] ?? 0,
      completedOrders: json['completedOrders'] ?? 0,
      pendingOrders: json['pendingOrders'] ?? 0,
      cancelledOrders: json['cancelledOrders'] ?? 0,
      orderCompletionRate: (json['orderCompletionRate'] ?? 0).toDouble(),
      cancellationRate: (json['cancellationRate'] ?? 0).toDouble(),
    );
  }
}

// Sales Analytics Model
class SalesAnalytics {
  final SalesOverview salesOverview;
  final Map<String, double> revenueTrend;
  final double dailyRevenue;
  final double weeklyRevenue;
  final double monthlyRevenue;
  final double yearlyRevenue;

  SalesAnalytics({
    required this.salesOverview,
    required this.revenueTrend,
    required this.dailyRevenue,
    required this.weeklyRevenue,
    required this.monthlyRevenue,
    required this.yearlyRevenue,
  });

  factory SalesAnalytics.fromJson(Map<String, dynamic> json) {
    return SalesAnalytics(
      salesOverview: SalesOverview.fromJson(json['salesOverview']),
      revenueTrend: Map<String, double>.from(json['revenueTrend'] ?? {}),
      dailyRevenue: (json['dailyRevenue'] ?? 0).toDouble(),
      weeklyRevenue: (json['weeklyRevenue'] ?? 0).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
      yearlyRevenue: (json['yearlyRevenue'] ?? 0).toDouble(),
    );
  }
}

// Product Analytics Response
class ProductAnalyticsResponse {
  final List<ProductPerformance> bestSelling;
  final List<ProductPerformance> topRated;
  final List<ProductPerformance> mostViewed;
  final List<ProductPerformance> lowStock;
  final List<ProductPerformance> outOfStock;
  final List<ProductPerformance> allProducts;
  final Summary summary;

  ProductAnalyticsResponse({
    required this.bestSelling,
    required this.topRated,
    required this.mostViewed,
    required this.lowStock,
    required this.outOfStock,
    required this.allProducts,
    required this.summary,
  });

  factory ProductAnalyticsResponse.fromJson(Map<String, dynamic> json) {
    return ProductAnalyticsResponse(
      bestSelling:
          (json['bestSelling'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      topRated:
          (json['topRated'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      mostViewed:
          (json['mostViewed'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      lowStock:
          (json['lowStock'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      outOfStock:
          (json['outOfStock'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      allProducts:
          (json['allProducts'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      summary: Summary.fromJson(json['summary'] ?? {}),
    );
  }
}

// Report Model
class ReportResponse {
  final String reportType;
  final String date;
  final SalesOverview salesSummary;
  final List<ProductPerformance> topProducts;
  final List<String> insights;

  ReportResponse({
    required this.reportType,
    required this.date,
    required this.salesSummary,
    required this.topProducts,
    required this.insights,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      reportType: json['reportType'] ?? '',
      date: json['date'] ?? '',
      salesSummary: SalesOverview.fromJson(json['salesSummary'] ?? {}),
      topProducts:
          (json['topProducts'] as List?)
              ?.map((e) => ProductPerformance.fromJson(e))
              .toList() ??
          [],
      insights: List<String>.from(json['insights'] ?? []),
    );
  }
}

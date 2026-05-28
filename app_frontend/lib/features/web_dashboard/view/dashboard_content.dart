// lib/features/web_dashboard/widgets/product_widgets/dashboard_content.dart

import 'package:app_frontend/features/analytics/bloc/analytics_bloc.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_event.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_state.dart';
import 'package:app_frontend/features/analytics/model/analytics_models.dart';
import 'package:app_frontend/features/analytics/service/analytics_service.dart';
import 'package:app_frontend/features/analytics/widgets/analytics_charts.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardContent extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  final String token;

  const DashboardContent({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
    required this.token,
  });

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<AnalyticsBloc>().add(
      FetchDashboardAnalytics(period: AnalyticsPeriod.week),
    );
    context.read<AnalyticsBloc>().add(FetchCustomerAnalytics());
    context.read<AnalyticsBloc>().add(
      FetchProductAnalytics(sortBy: 'revenue', limit: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // AppBar always visible
          CommonAppBar(
            title: 'Welcome back, ${widget.userName}! 🚀',
            subtitle: 'Here\'s what\'s happening with your store today.',
          ),
          // Content area with loader in center
          BlocBuilder<AnalyticsBloc, AnalyticsState>(
            builder: (context, state) {
              // Show loader only when loading and data not yet loaded
              if (state is AnalyticsLoading && !_isDataLoaded) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF7C3AED),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading dashboard data...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show error widget
              if (state is AnalyticsError) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: _buildErrorWidget(state.message),
                );
              }

              // Show dashboard content when data is loaded
              if (state is DashboardAnalyticsLoaded) {
                _isDataLoaded = true;
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildDashboardContent(state.dashboardAnalytics),
                );
              }

              // Show loader for other states
              return SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF7C3AED),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading dashboard data...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(DashboardAnalytics data) {
    return Column(
      children: [
        _buildStatsGrid(data.summary),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: RevenueLineChart(
                data: data.revenueAnalytics.breakdown,
                title: 'Revenue Trend (Last 7 Days)',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(child: OrderStatusPieChart(orderStatus: data.orderStatus)),
          ],
        ),
        const SizedBox(height: 24),
        // Top Products Section - using dashboard data directly
        _buildTopProductsSection(data.topProducts.bestSelling.take(5).toList()),
        const SizedBox(height: 24),
        // Customer Section using dashboard data
        _buildCustomerSection(data.customerAnalytics),
        const SizedBox(height: 24),
        _buildQuickActions(),
      ],
    );
  }

  Widget _buildStatsGrid(Summary summary) {
    final stats = [
      {
        'title': 'Total Revenue',
        'value': '₹${summary.totalRevenue.toStringAsFixed(0)}',
        'change': '+18.6%',
        'icon': Icons.currency_rupee,
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'Total Orders',
        'value': '${summary.totalOrders}',
        'change': '+14.2%',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Total Customers',
        'value': '${summary.totalCustomers}',
        'change': '+12.5%',
        'icon': Icons.people,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Average Order Value',
        'value': '₹${summary.averageOrderValue.toStringAsFixed(0)}',
        'change': '+6.9%',
        'icon': Icons.receipt,
        'color': const Color(0xFFEF4444),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
            constraints.maxWidth > 1200
                ? 4
                : constraints.maxWidth > 800
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.6,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (stat['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          stat['icon'] as IconData,
                          color: stat['color'] as Color,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_upward,
                              size: 12,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              stat['change'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stat['value'] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat['title'] as String,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopProductsSection(List<ProductPerformance> products) {
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(child: Text('No products found')),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Selling Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7C3AED),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.productImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            width: 50,
                            height: 50,
                            color: const Color(0xFF7C3AED).withOpacity(0.1),
                            child: const Icon(
                              Icons.shopping_bag,
                              color: Color(0xFF7C3AED),
                              size: 24,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sold: ${product.totalSold} | Revenue: ₹${product.totalRevenue.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(product.totalRevenue / products.map((e) => e.totalRevenue).reduce((a, b) => a + b) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(CustomerAnalytics data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Customers',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.totalCustomers}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+${data.newCustomers} this month',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Avg Orders per Customer',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.averageOrderPerCustomer.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Retention Rate',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '${data.customerRetentionRate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Add Product',
        'subtitle': 'List a new product',
        'icon': Icons.add_box_outlined,
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'Manage Products',
        'subtitle': 'View and manage',
        'icon': Icons.inventory_2_outlined,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Manage Orders',
        'subtitle': 'Process orders',
        'icon': Icons.local_shipping_outlined,
        'color': const Color(0xFF10B981),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
            constraints.maxWidth > 800
                ? 3
                : constraints.maxWidth > 500
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.8,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (action['color'] as Color).withOpacity(0.1),
                    (action['color'] as Color).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (action['color'] as Color).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (action['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: action['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          action['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          action['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: action['color'] as Color,
                    size: 16,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEF4444)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            const Text(
              'Error Loading Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF991B1B),
              ),
            ),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Color(0xFF7F1D1D))),
            const SizedBox(height: 16),
            MaterialButton(
              onPressed: () {
                setState(() {
                  _isDataLoaded = false;
                });
                _loadData();
              },
              color: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

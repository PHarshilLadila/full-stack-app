// lib/features/web_dashboard/widgets/product_widgets/analytics_content.dart

import 'package:app_frontend/features/analytics/bloc/analytics_bloc.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_event.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_state.dart';
import 'package:app_frontend/features/analytics/model/analytics_models.dart';
import 'package:app_frontend/features/analytics/service/analytics_service.dart';
import 'package:app_frontend/features/analytics/widgets/analytics_charts.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

class AnalyticsContent extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  final String token;

  const AnalyticsContent({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
    required this.token,
  });

  @override
  State<AnalyticsContent> createState() => _AnalyticsContentState();
}

class _AnalyticsContentState extends State<AnalyticsContent> {
  AnalyticsPeriod _selectedPeriod = AnalyticsPeriod.week;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    context.read<AnalyticsBloc>().add(
      FetchDashboardAnalytics(period: _selectedPeriod),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CommonAppBar(
            title: 'Analytics Dashboard',
            subtitle: 'View detailed reports and insights for your store',
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPeriodSelector(),
                const SizedBox(height: 24),
                BlocBuilder<AnalyticsBloc, AnalyticsState>(
                  builder: (context, state) {
                    if (state is AnalyticsLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is AnalyticsError) {
                      return _buildErrorWidget(state.message);
                    } else if (state is DashboardAnalyticsLoaded) {
                      return _buildDashboardContent(state.dashboardAnalytics);
                    } else if (state is OrderAnalyticsLoaded) {
                      return _buildOrderAnalyticsContent(state.orderAnalytics);
                    } else if (state is SalesAnalyticsLoaded) {
                      return _buildSalesAnalyticsContent(state.salesAnalytics);
                    } else if (state is ProductAnalyticsLoaded) {
                      return _buildProductAnalyticsContent(
                        state.productAnalytics,
                      );
                    } else if (state is CustomerAnalyticsLoaded) {
                      return _buildCustomerAnalyticsContent(
                        state.customerAnalytics,
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.analytics_outlined,
                            size: 80,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Select an analytics view',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, size: 18, color: Color(0xFF7C3AED)),
          const SizedBox(width: 12),
          _buildPeriodButton('Today', AnalyticsPeriod.today),
          _buildPeriodButton('Week', AnalyticsPeriod.week),
          _buildPeriodButton('Month', AnalyticsPeriod.month),
          _buildPeriodButton('Year', AnalyticsPeriod.year),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, AnalyticsPeriod period) {
    final isSelected = _selectedPeriod == period;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            _selectedPeriod = period;
          });
          context.read<AnalyticsBloc>().add(
            FetchDashboardAnalytics(period: period),
          );
        },
        color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent,
        elevation: 0,
        minWidth: 60,
        height: 36,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
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
                title: 'Revenue Trend',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(child: OrderStatusPieChart(orderStatus: data.orderStatus)),
          ],
        ),
        const SizedBox(height: 24),
        _buildCustomerMetrics(data.customerAnalytics),
        const SizedBox(height: 24),
        ProductPerformanceTable(
          products: data.topProducts.bestSelling,
          title: 'Top Selling Products',
        ),
        const SizedBox(height: 24),
        _buildQuickActions(),
      ],
    );
  }

  Widget _buildOrderAnalyticsContent(OrderAnalytics data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Orders',
                '${data.totalOrders}',
                Icons.shopping_bag_outlined,
                const Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Completed Orders',
                '${data.completedOrders}',
                Icons.check_circle_outline,
                const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Cancelled Orders',
                '${data.cancelledOrders}',
                Icons.cancel_outlined,
                const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        OrderStatusPieChart(
          orderStatus: OrderStatus(
            pending: data.pendingOrders,
            confirmed: 0,
            shipped: 0,
            outForDelivery: 0,
            delivered: data.completedOrders,
            cancelled: data.cancelledOrders,
            returned: 0,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                'Order Completion Rate',
                '${data.orderCompletionRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                data.orderCompletionRate > 70
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                'Cancellation Rate',
                '${data.cancellationRate.toStringAsFixed(1)}%',
                Icons.trending_down,
                data.cancellationRate < 10
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesAnalyticsContent(SalesAnalytics data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Revenue',
                '₹${data.salesOverview.totalRevenue.toStringAsFixed(0)}',
                Icons.currency_rupee,
                const Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Total Profit',
                '₹${data.salesOverview.totalProfit.toStringAsFixed(0)}',
                Icons.trending_up,
                const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Average Order Value',
                '₹${data.salesOverview.averageOrderValue.toStringAsFixed(0)}',
                Icons.receipt,
                const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        RevenueLineChart(
          data: data.revenueTrend,
          title: 'Revenue Trend Over Time',
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Daily Revenue',
                '₹${data.dailyRevenue.toStringAsFixed(0)}',
                Icons.today,
                const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Weekly Revenue',
                '₹${data.weeklyRevenue.toStringAsFixed(0)}',
                Icons.weekend,
                const Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Monthly Revenue',
                '₹${data.monthlyRevenue.toStringAsFixed(0)}',
                Icons.calendar_month,
                const Color(0xFF06B6D4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Yearly Revenue',
                '₹${data.yearlyRevenue.toStringAsFixed(0)}',
                Icons.calendar_today,
                const Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductAnalyticsContent(ProductAnalyticsResponse data) {
    return Column(
      children: [
        _buildProductSummary(data.summary),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildSortButton('Revenue', 'revenue')),
            const SizedBox(width: 12),
            Expanded(child: _buildSortButton('Best Selling', 'totalSold')),
            const SizedBox(width: 12),
            Expanded(child: _buildSortButton('Top Rated', 'rating')),
            const SizedBox(width: 12),
            Expanded(child: _buildSortButton('Most Viewed', 'views')),
          ],
        ),
        const SizedBox(height: 24),
        ProductPerformanceTable(
          products: data.bestSelling,
          title: 'Product Performance',
        ),
        if (data.lowStock.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildLowStockWarning(data.lowStock),
        ],
      ],
    );
  }

  Widget _buildCustomerAnalyticsContent(CustomerAnalytics data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Customers',
                '${data.totalCustomers}',
                Icons.people,
                const Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'New Customers',
                '${data.newCustomers}',
                Icons.person_add,
                const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Repeat Customers',
                '${data.repeatCustomers}',
                Icons.repeat,
                const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                'Customer Retention Rate',
                '${data.customerRetentionRate.toStringAsFixed(1)}%',
                Icons.verified,
                data.customerRetentionRate > 70
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                'Average Orders per Customer',
                '${data.averageOrderPerCustomer.toStringAsFixed(1)}',
                Icons.shopping_bag,
                const Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                'Customer Lifetime Value',
                '₹${data.lifetimeValue.toStringAsFixed(0)}',
                Icons.attach_money,
                const Color(0xFF7C3AED),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF7C3AED).withOpacity(0.1),
                const Color(0xFF8B5CF6).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Insights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              _buildInsightRow(
                'Average Revenue per Customer',
                '₹${data.averageRevenuePerCustomer.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 12),
              _buildInsightRow(
                'Customer Retention',
                '${data.customerRetentionRate.toStringAsFixed(1)}%',
              ),
              const SizedBox(height: 12),
              _buildInsightRow(
                'Repeat Purchase Rate',
                '${(data.repeatCustomers / data.totalCustomers * 100).toStringAsFixed(1)}%',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(Summary summary) {
    final stats = [
      {
        'title': 'Total Revenue',
        'value': '₹${summary.totalRevenue.toStringAsFixed(0)}',
        'icon': Icons.currency_rupee,
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'Total Orders',
        'value': '${summary.totalOrders}',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Total Customers',
        'value': '${summary.totalCustomers}',
        'icon': Icons.people,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Total Products',
        'value': '${summary.totalProducts}',
        'icon': Icons.inventory,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Avg Order Value',
        'value': '₹${summary.averageOrderValue.toStringAsFixed(0)}',
        'icon': Icons.receipt,
        'color': const Color(0xFFEF4444),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
            constraints.maxWidth > 1200
                ? 5
                : constraints.maxWidth > 800
                ? 3
                : 2;
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

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerMetrics(CustomerAnalytics data) {
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
                  'Customer Insights',
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
                const Text(
                  'Total Customers',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Retention Rate',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.customerRetentionRate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Lifetime Value',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '₹${data.lifetimeValue.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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

  Widget _buildProductSummary(Summary summary) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Total Products',
            '${summary.totalProducts}',
            Icons.inventory,
            const Color(0xFF7C3AED),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Low Stock Items',
            '${summary.totalOrders}',
            Icons.warning,
            const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Out of Stock',
            '${summary.totalOrders}',
            Icons.error,
            const Color(0xFFEF4444),
          ),
        ),
      ],
    );
  }

  Widget _buildLowStockWarning(List<ProductPerformance> lowStockProducts) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text(
                'Low Stock Alert',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...lowStockProducts.map(
            (product) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      product.productName,
                      style: const TextStyle(color: Color(0xFF92400E)),
                    ),
                  ),
                  Text(
                    'Stock: ${product.stockAvailable}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
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

  Widget _buildSortButton(String label, String sortBy) {
    final isSelected =
        context.read<AnalyticsBloc>().state is ProductAnalyticsLoaded &&
        (context.read<AnalyticsBloc>().state as ProductAnalyticsLoaded)
                .currentSortBy ==
            sortBy;

    return MaterialButton(
      onPressed: () {
        context.read<AnalyticsBloc>().add(
          FetchProductAnalytics(sortBy: sortBy),
        );
      },
      color: isSelected ? const Color(0xFF7C3AED) : Colors.white,
      elevation: 0,
      height: 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: const Color(0xFF7C3AED).withOpacity(isSelected ? 0 : 0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF7C3AED),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Export Report',
        'icon': Icons.download,
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'Generate Invoice',
        'icon': Icons.receipt,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'View All Orders',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFF3B82F6),
      },
    ];

    return Row(
      children:
          actions.map((action) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: MaterialButton(
                  onPressed: () {},
                  height: 80,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        color: action['color'] as Color,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action['title'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
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
            Text(
              'Error Loading Analytics',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF991B1B),
              ),
            ),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Color(0xFF7F1D1D))),
            const SizedBox(height: 16),
            MaterialButton(
              onPressed: _loadDashboardData,
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

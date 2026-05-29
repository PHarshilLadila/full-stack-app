// lib/features/web_dashboard/widgets/product_widgets/customers_content.dart

import 'package:app_frontend/features/analytics/bloc/analytics_bloc.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_event.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_state.dart';
import 'package:app_frontend/features/analytics/model/analytics_models.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersContent extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  final String token;

  const CustomersContent({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
    required this.token,
  });

  @override
  State<CustomersContent> createState() => _CustomersContentState();
}

class _CustomersContentState extends State<CustomersContent> {
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    // Only load once on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isInitialLoad && mounted) {
        context.read<AnalyticsBloc>().add(FetchCustomerAnalytics());
        _isInitialLoad = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CommonAppBar(
          title: 'Customers',
          subtitle: 'View and manage your customer database',
        ),
        Expanded(
          child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
            buildWhen: (previous, current) {
              // Only rebuild when customer analytics related states change
              return current is CustomerAnalyticsLoaded ||
                  current is AnalyticsLoading ||
                  current is AnalyticsError;
            },
            builder: (context, state) {
              if (state is AnalyticsLoading && _isInitialLoad) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading customer data...'),
                      ],
                    ),
                  ),
                );
              } else if (state is AnalyticsError) {
                return _buildErrorWidget(state.message);
              } else if (state is CustomerAnalyticsLoaded) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildCustomersContent(state.customerAnalytics),
                );
              }
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading customer data...'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomersContent(CustomerAnalytics data) {
    return Column(
      children: [
        _buildStatsGrid(data),
        const SizedBox(height: 24),
        _buildInsightsCard(data),
        const SizedBox(height: 24),
        _buildCustomerSegments(),
        const SizedBox(height: 24),
        _buildRecentCustomersList(),
      ],
    );
  }

  Widget _buildStatsGrid(CustomerAnalytics data) {
    final stats = [
      {
        'title': 'Total Customers',
        'value': '${data.totalCustomers}',
        'icon': Icons.people,
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'New Customers',
        'value': '${data.newCustomers}',
        'icon': Icons.person_add,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Repeat Customers',
        'value': '${data.repeatCustomers}',
        'icon': Icons.repeat,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Retention Rate',
        'value': '${data.customerRetentionRate.toStringAsFixed(1)}%',
        'icon': Icons.verified,
        'color': const Color(0xFFF59E0B),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
            constraints.maxWidth > 1000
                ? 4
                : constraints.maxWidth > 600
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (stat['color'] as Color).withOpacity(0.1),
                    (stat['color'] as Color).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (stat['color'] as Color).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    stat['icon'] as IconData,
                    color: stat['color'] as Color,
                    size: 28,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stat['value'] as String,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: stat['color'] as Color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInsightsCard(CustomerAnalytics data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Avg Orders/Customer',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${data.averageOrderPerCustomer.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Lifetime Value',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${data.lifetimeValue.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Avg Revenue/Customer',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${data.averageRevenuePerCustomer.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSegments() {
    final segments = [
      {
        'name': 'Premium',
        'count': 245,
        'percentage': 26,
        'color': const Color(0xFF7C3AED),
      },
      {
        'name': 'Regular',
        'count': 423,
        'percentage': 45,
        'color': const Color(0xFF3B82F6),
      },
      {
        'name': 'New',
        'count': 274,
        'percentage': 29,
        'color': const Color(0xFF10B981),
      },
    ];

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
          const Text(
            'Customer Segments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          ...segments.map(
            (segment) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        segment['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${segment['count']} customers',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${segment['percentage']}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (segment['percentage'] as int) / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: segment['color'] as Color,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCustomersList() {
    final recentCustomers = [
      {
        'name': 'Arjun Sharma',
        'email': 'arjun@example.com',
        'orders': 12,
        'total': '₹24,500',
        'status': 'Premium',
      },
      {
        'name': 'Priya Singh',
        'email': 'priya@example.com',
        'orders': 8,
        'total': '₹15,200',
        'status': 'Regular',
      },
      {
        'name': 'Rohan Verma',
        'email': 'rohan@example.com',
        'orders': 5,
        'total': '₹8,900',
        'status': 'Regular',
      },
      {
        'name': 'Neha Patel',
        'email': 'neha@example.com',
        'orders': 3,
        'total': '₹4,500',
        'status': 'New',
      },
      {
        'name': 'Karan Mehta',
        'email': 'karan@example.com',
        'orders': 15,
        'total': '₹32,000',
        'status': 'Premium',
      },
    ];

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
                'Recent Customers',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowColor: WidgetStateProperty.resolveWith(
                (states) => const Color(0xFFF8FAFC),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Customer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Orders',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Total Spent',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows:
                  recentCustomers.map((customer) {
                    Color getStatusColor(String status) {
                      switch (status) {
                        case 'Premium':
                          return const Color(0xFF7C3AED);
                        case 'Regular':
                          return const Color(0xFF3B82F6);
                        default:
                          return const Color(0xFF10B981);
                      }
                    }

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            customer['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(Text(customer['email'] as String)),
                        DataCell(Text(customer['orders'].toString())),
                        DataCell(
                          Text(
                            customer['total'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(
                                customer['status'] as String,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              customer['status'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: getStatusColor(
                                  customer['status'] as String,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
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
              'Error Loading Customers',
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
                context.read<AnalyticsBloc>().add(FetchCustomerAnalytics());
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

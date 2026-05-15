import 'package:app_frontend/features/web_dashboard/web_dashboard.dart';
import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
    final String userName;
  final String userEmail;
  final String? userProfileImage;
  final Map<String, dynamic>? sellerStats;
  const DashboardContent({super.key, required this.userName, required this.userEmail, this.userProfileImage, this.sellerStats});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // _buildTopAppBar(),
          const CommonAppBar(
            title: 'Welcome back, Seller! 🚀',
            subtitle: 'Here\'s what\'s happening with your store today.',
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(),
                const SizedBox(height: 32),
                _buildRevenueAndSalesRow(),
                const SizedBox(height: 32),
                _buildRecentOrdersAndTopProducts(),
                const SizedBox(height: 32),
                _buildActionCards(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    final actions = [
      {
        'title': 'Add Product',
        'subtitle': 'List a new product in your store',
        'icon': Icons.add_box_outlined,
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'Manage Products',
        'subtitle': 'View and manage your products',
        'icon': Icons.inventory_2_outlined,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Manage Orders',
        'subtitle': 'Process and track orders',
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
                    color: (action['color'] as Color),
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

  Widget _buildRecentOrdersAndTopProducts() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1000;
        if (isMobile) {
          return Column(
            children: [
              _buildRecentOrdersTable(),
              const SizedBox(height: 24),
              _buildTopProductsCard(),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildRecentOrdersTable()),
            const SizedBox(width: 24),
            Expanded(child: _buildTopProductsCard()),
          ],
        );
      },
    );
  }

  Widget _buildRecentOrdersTable() {
    final orders = [
      {
        'id': '#VMR-12568',
        'customer': 'Arjun Sharma',
        'items': '2 Items',
        'amount': '₹2,499',
        'status': 'Pending',
        'date': 'May 18, 2025',
      },
      {
        'id': '#VMR-12567',
        'customer': 'Priya Singh',
        'items': '1 Item',
        'amount': '₹1,299',
        'status': 'Confirmed',
        'date': 'May 18, 2025',
      },
      {
        'id': '#VMR-12566',
        'customer': 'Rohan Verma',
        'items': '3 Items',
        'amount': '₹3,799',
        'status': 'Shipped',
        'date': 'May 17, 2025',
      },
      {
        'id': '#VMR-12565',
        'customer': 'Neha Patel',
        'items': '1 Item',
        'amount': '₹899',
        'status': 'Delivered',
        'date': 'May 17, 2025',
      },
      {
        'id': '#VMR-12564',
        'customer': 'Karan Mehta',
        'items': '2 Items',
        'amount': '₹1,999',
        'status': 'Delivered',
        'date': 'May 16, 2025',
      },
    ];

    Color getStatusColor(String status) {
      switch (status) {
        case 'Pending':
          return const Color(0xFFF59E0B);
        case 'Confirmed':
          return const Color(0xFF3B82F6);
        case 'Shipped':
          return const Color(0xFF8B5CF6);
        case 'Delivered':
          return const Color(0xFF10B981);
        default:
          return const Color(0xFF94A3B8);
      }
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
                'Recent Orders',
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
                    'Order ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Customer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Products',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows:
                  orders
                      .map(
                        (order) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                order['id'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(Text(order['customer'] as String)),
                            DataCell(Text(order['items'] as String)),
                            DataCell(
                              Text(
                                order['amount'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
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
                                    order['status'] as String,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order['status'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: getStatusColor(
                                      order['status'] as String,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(order['date'] as String)),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductsCard() {
    final products = [
      {'name': 'Velmora Premium T-Shirt', 'price': '₹4,25,680', 'quantity': 1},
      {'name': 'Velmora Hoodie', 'price': '₹3,15,420', 'quantity': 2},
      {'name': 'Velmora Sneakers', 'price': '₹2,45,760', 'quantity': 3},
      {'name': 'Velmora Watch', 'price': '₹1,25,890', 'quantity': 4},
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
          ...products
              .map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Color(0xFF7C3AED),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Quantity: ${product['quantity']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        product['price'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {
        'title': 'Total Revenue',
        'value': '₹12,45,680',
        'change': '+18.6%',
        'icon': Icons.currency_rupee,
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'Total Orders',
        'value': '1,268',
        'change': '+14.2%',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Total Customers',
        'value': '942',
        'change': '+12.5%',
        'icon': Icons.people,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Conversion Rate',
        'value': '3.42%',
        'change': '+8.7%',
        'icon': Icons.trending_up,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Average Order Value',
        'value': '₹982',
        'change': '+6.9%',
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

  Widget _buildRevenueAndSalesRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;
        if (isMobile) {
          return Column(
            children: [
              _buildRevenueCard(),
              const SizedBox(height: 24),
              _buildSalesByChannelCard(),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildRevenueCard()),
            const SizedBox(width: 24),
            Expanded(child: _buildSalesByChannelCard()),
          ],
        );
      },
    );
  }

  Widget _buildRevenueCard() {
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
            'Revenue Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '₹12,45,680',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      ['₹200K', '₹150K', '₹100K', '₹50K', '₹0']
                          .map(
                            (val) => Text(
                              val,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBar(180, const Color(0xFFEF4444)),
                      _buildBar(140, const Color(0xFF10B981)),
                      _buildBar(100, const Color(0xFF3B82F6)),
                      _buildBar(120, const Color(0xFF8B5CF6)),
                      _buildBar(90, const Color(0xFFF59E0B)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                ['Apr 20', 'May 11', 'May 18', 'May 25', 'Jun 1']
                    .map(
                      (val) => Text(
                        val,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesByChannelCard() {
    final channels = [
      {'name': 'Website', 'percentage': 0.7, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Direct', 'percentage': 15.2, 'color': const Color(0xFF3B82F6)},
      {'name': 'Social', 'percentage': 28.4, 'color': const Color(0xFF10B981)},
      {'name': 'Email', 'percentage': 12.7, 'color': const Color(0xFFF59E0B)},
      {'name': 'Referral', 'percentage': 8.3, 'color': const Color(0xFFEF4444)},
    ];

    final orderStatus = [
      {
        'name': 'Pending',
        'count': 12,
        'percentage': 8.7,
        'color': const Color(0xFFF59E0B),
      },
      {
        'name': 'Confirmed',
        'count': 28,
        'percentage': 20.3,
        'color': const Color(0xFF3B82F6),
      },
      {
        'name': 'Shipped',
        'count': 64,
        'percentage': 46.4,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'name': 'Delivered',
        'count': 78,
        'percentage': 21.7,
        'color': const Color(0xFF10B981),
      },
      {
        'name': 'Cancelled',
        'count': 6,
        'percentage': 4.3,
        'color': const Color(0xFFEF4444),
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
            'Sales by Channel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          ...channels.map(
            (channel) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        channel['name'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${channel['percentage']}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: (channel['percentage'] as double) / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: channel['color'] as Color,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Order Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          ...orderStatus.map(
            (status) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: status['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${status['name']}: ${status['count']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${status['percentage']}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
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

  Widget _buildBar(double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

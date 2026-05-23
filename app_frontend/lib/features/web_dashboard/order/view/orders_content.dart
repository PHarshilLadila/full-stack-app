 // ignore_for_file: deprecated_member_use

 import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';

class OrdersContent extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  final Map<String, dynamic>? sellerStats;
  const OrdersContent({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
    this.sellerStats,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CommonAppBar(
            title: 'Orders',
            subtitle: 'Track and manage all customer orders',
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildOrderStats(),
                const SizedBox(height: 24),
                _buildOrderList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAppBar() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.03),
  //           blurRadius: 10,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 'Orders',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF1E293B),
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 'Track and manage all customer orders',
  //                 style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           decoration: BoxDecoration(
  //             color: const Color(0xFFF8FAFC),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: const Row(
  //             children: [
  //               Icon(Icons.filter_list, size: 18, color: Color(0xFF64748B)),
  //               SizedBox(width: 8),
  //               Text('Filter', style: TextStyle(color: Color(0xFF475569))),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOrderStats() {
    final stats = [
      {
        'title': 'Total Orders',
        'value': '1,268',
        'change': '+14.2%',
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'Pending',
        'value': '142',
        'change': '+8',
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Processing',
        'value': '328',
        'change': '+24',
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Delivered',
        'value': '764',
        'change': '+112',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Cancelled',
        'value': '34',
        'change': '-6',
        'color': const Color(0xFFEF4444),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
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
                      Icons.shopping_bag,
                      color: stat['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    stat['change'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          (stat['change'] as String).startsWith('+')
                              ? Colors.green
                              : Colors.red,
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
  }

  Widget _buildOrderList() {
    final orders = [
      {
        'id': '#VMR-12568',
        'customer': 'Arjun Sharma',
        'amount': '₹2,499',
        'status': 'Pending',
        'date': 'May 18, 2025',
        'items': 2,
      },
      {
        'id': '#VMR-12567',
        'customer': 'Priya Singh',
        'amount': '₹1,299',
        'status': 'Confirmed',
        'date': 'May 18, 2025',
        'items': 1,
      },
      {
        'id': '#VMR-12566',
        'customer': 'Rohan Verma',
        'amount': '₹3,799',
        'status': 'Shipped',
        'date': 'May 17, 2025',
        'items': 3,
      },
      {
        'id': '#VMR-12565',
        'customer': 'Neha Patel',
        'amount': '₹899',
        'status': 'Delivered',
        'date': 'May 17, 2025',
        'items': 1,
      },
      {
        'id': '#VMR-12564',
        'customer': 'Karan Mehta',
        'amount': '₹1,999',
        'status': 'Delivered',
        'date': 'May 16, 2025',
        'items': 2,
      },
      {
        'id': '#VMR-12563',
        'customer': 'Sneha Reddy',
        'amount': '₹4,299',
        'status': 'Processing',
        'date': 'May 16, 2025',
        'items': 4,
      },
      {
        'id': '#VMR-12562',
        'customer': 'Vikram Singh',
        'amount': '₹699',
        'status': 'Cancelled',
        'date': 'May 15, 2025',
        'items': 1,
      },
    ];

    Color getStatusColor(String status) {
      switch (status) {
        case 'Pending':
          return const Color(0xFFF59E0B);
        case 'Confirmed':
          return const Color(0xFF3B82F6);
        case 'Processing':
          return const Color(0xFF8B5CF6);
        case 'Shipped':
          return const Color(0xFF8B5CF6);
        case 'Delivered':
          return const Color(0xFF10B981);
        case 'Cancelled':
          return const Color(0xFFEF4444);
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
          const Text(
            'Recent Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 30,
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
                    'Items',
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
                DataColumn(
                  label: Text(
                    'Actions',
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
                            DataCell(Text('${order['items']} Items')),
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
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      size: 18,
                                    ),
                                    onPressed: () {},
                                    color: const Color(0xFF3B82F6),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.local_shipping,
                                      size: 18,
                                    ),
                                    onPressed: () {},
                                    color: const Color(0xFF10B981),
                                  ),
                                ],
                              ),
                            ),
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
}

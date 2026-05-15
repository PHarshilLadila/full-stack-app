// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';

class ProductsContent extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  const ProductsContent({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // _buildAppBar('Products', 'Manage your product inventory'),
          const CommonAppBar(
            title: 'Products',
            subtitle: 'Manage your product inventory',
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildProductStats(),
                const SizedBox(height: 24),
                _buildProductList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAppBar(String title, String subtitle) {
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
  //               Text(
  //                 title,
  //                 style: const TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF1E293B),
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 subtitle,
  //                 style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
  //               ),
  //             ],
  //           ),
  //         ),
  //         ElevatedButton.icon(
  //           onPressed: () {},
  //           icon: const Icon(Icons.add, size: 18),
  //           label: const Text('Add Product'),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFF7C3AED),
  //             foregroundColor: Colors.white,
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildProductStats() {
    final stats = [
      {
        'title': 'Total Products',
        'value': '156',
        'change': '+12',
        'color': const Color(0xFF7C3AED),
      },
      {
        'title': 'Low Stock',
        'value': '8',
        'change': '-2',
        'color': const Color(0xFFEF4444),
      },
      {
        'title': 'Out of Stock',
        'value': '3',
        'change': '+1',
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Total Categories',
        'value': '24',
        'change': '+3',
        'color': const Color(0xFF10B981),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
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

  Widget _buildProductList() {
    final products = [
      {
        'name': 'Velmora Premium T-Shirt',
        'price': '₹4,25,680',
        'stock': 45,
        'status': 'In Stock',
        'category': 'Apparel',
      },
      {
        'name': 'Velmora Hoodie',
        'price': '₹3,15,420',
        'stock': 28,
        'status': 'In Stock',
        'category': 'Apparel',
      },
      {
        'name': 'Velmora Sneakers',
        'price': '₹2,45,760',
        'stock': 12,
        'status': 'Low Stock',
        'category': 'Footwear',
      },
      {
        'name': 'Velmora Watch',
        'price': '₹1,25,890',
        'stock': 8,
        'status': 'Low Stock',
        'category': 'Accessories',
      },
      {
        'name': 'Velmora Backpack',
        'price': '₹2,99,990',
        'stock': 0,
        'status': 'Out of Stock',
        'category': 'Bags',
      },
      {
        'name': 'Velmora Sunglasses',
        'price': '₹45,990',
        'stock': 32,
        'status': 'In Stock',
        'category': 'Accessories',
      },
    ];

    Color getStatusColor(String status) {
      switch (status) {
        case 'In Stock':
          return const Color(0xFF10B981);
        case 'Low Stock':
          return const Color(0xFFF59E0B);
        case 'Out of Stock':
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Products',
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
              columnSpacing: 30,
              headingRowColor: WidgetStateProperty.resolveWith(
                (states) => const Color(0xFFF8FAFC),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Product Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Price',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Stock',
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
                    'Actions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows:
                  products
                      .map(
                        (product) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                product['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(Text(product['category'] as String)),
                            DataCell(Text(product['price'] as String)),
                            DataCell(Text('${product['stock']}')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(
                                    product['status'] as String,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  product['status'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: getStatusColor(
                                      product['status'] as String,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () {},
                                    color: const Color(0xFF3B82F6),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                    ),
                                    onPressed: () {},
                                    color: const Color(0xFFEF4444),
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

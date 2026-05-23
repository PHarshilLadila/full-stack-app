import 'package:app_frontend/features/web_dashboard/order/model/seller_order_model.dart';
import 'package:flutter/material.dart';

class OrderStatsCards extends StatelessWidget {
  final OrderStats stats;
  final String? selectedFilter;
  final Function(String?) onFilterTap;

  const OrderStatsCards({
    Key? key,
    required this.stats,
    required this.selectedFilter,
    required this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cards = [
      {
        'title': 'Total Orders',
        'value': stats.totalOrders.toString(),
        'icon': Icons.shopping_bag_outlined,
        'color': const Color(0xFF7C3AED),
        'filter': null,
      },
      {
        'title': 'Pending',
        'value': stats.pendingOrders.toString(),
        'icon': Icons.pending_actions_outlined,
        'color': const Color(0xFFF59E0B),
        'filter': 'pending',
      },
      {
        'title': 'Confirmed',
        'value': stats.confirmedOrders.toString(),
        'icon': Icons.check_circle_outline,
        'color': const Color(0xFF3B82F6),
        'filter': 'confirmed',
      },
      {
        'title': 'Shipped',
        'value': stats.shippedOrders.toString(),
        'icon': Icons.local_shipping_outlined,
        'color': const Color(0xFF8B5CF6),
        'filter': 'shipped',
      },
      {
        'title': 'Out for Delivery',
        'value': stats.outForDeliveryOrders.toString(),
        'icon': Icons.delivery_dining_outlined,
        'color': const Color(0xFF06B6D4),
        'filter': 'out_for_delivery',
      },
      {
        'title': 'Delivered',
        'value': stats.deliveredOrders.toString(),
        'icon': Icons.verified_outlined,
        'color': const Color(0xFF10B981),
        'filter': 'delivered',
      },
      {
        'title': 'Cancelled',
        'value': stats.cancelledOrders.toString(),
        'icon': Icons.cancel_outlined,
        'color': const Color(0xFFEF4444),
        'filter': 'cancelled',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final isSelected = selectedFilter == card['filter'];
        return _buildStatCard(
          title: card['title'] as String,
          value: card['value'] as String,
          icon: card['icon'] as IconData,
          color: card['color'] as Color,
          isSelected: isSelected,
          onTap: () => onFilterTap(card['filter'] as String?),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_circle_right,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

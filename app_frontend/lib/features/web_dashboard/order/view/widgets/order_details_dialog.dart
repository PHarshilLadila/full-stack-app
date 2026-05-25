import 'package:app_frontend/features/web_dashboard/order/model/seller_order_model.dart';
import 'package:flutter/material.dart';

class OrderDetailsDialog extends StatelessWidget {
  final SellerOrderModel order;

  const OrderDetailsDialog({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.8, end: 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        builder: (context, double scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          width: isSmallScreen ? screenWidth - 40 : 800,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.orderId}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!isSmallScreen)
                            Text(
                              'Placed on ${_formatFullDate(order.orderDate)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
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
                        color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(order.orderStatus).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(order.orderStatus),
                            color: _getStatusColor(order.orderStatus),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatStatus(order.orderStatus),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(order.orderStatus),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Customer Info
                _buildSection(
                  title: 'Customer Information',
                  icon: Icons.person_outline,
                  children: [
                    _buildInfoRow('Name', order.customer.fullName),
                    _buildInfoRow('Email', order.customer.email),
                    _buildInfoRow('Mobile', order.customer.mobileNumber),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Shipping Address
                _buildSection(
                  title: 'Shipping Address',
                  icon: Icons.location_on_outlined,
                  children: [
                    _buildInfoRow('Full Name', order.shippingAddress.fullName),
                    _buildInfoRow('Mobile', order.shippingAddress.mobileNumber),
                    _buildInfoRow(
                      'Address',
                      '${order.shippingAddress.addressLine1}, ${order.shippingAddress.addressLine2}',
                    ),
                    _buildInfoRow('City', order.shippingAddress.city),
                    _buildInfoRow('State', order.shippingAddress.state),
                    _buildInfoRow('Pincode', order.shippingAddress.pincode),
                    _buildInfoRow('Country', order.shippingAddress.country),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Order Items
                _buildSection(
                  title: 'Order Items',
                  icon: Icons.shopping_bag_outlined,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ...order.items.map((item) => _buildOrderItem(item)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Order Summary
                _buildSection(
                  title: 'Order Summary',
                  icon: Icons.receipt_outlined,
                  children: [
                    _buildSummaryRow(
                      'Subtotal',
                      '₹${order.subtotal.toStringAsFixed(2)}',
                    ),
                    if (order.discountAmount > 0)
                      _buildSummaryRow(
                        'Discount',
                        '-₹${order.discountAmount.toStringAsFixed(2)}',
                        isNegative: true,
                      ),
                    _buildSummaryRow(
                      'Shipping',
                      '₹${order.shippingCharge.toStringAsFixed(2)}',
                    ),
                    if (order.taxAmount > 0)
                      _buildSummaryRow(
                        'Tax',
                        '₹${order.taxAmount.toStringAsFixed(2)}',
                      ),
                    const Divider(height: 20, thickness: 1),
                    _buildSummaryRow(
                      'Total Amount',
                      '₹${order.totalAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Payment Info
                _buildSection(
                  title: 'Payment Information',
                  icon: Icons.payment_outlined,
                  children: [
                    _buildInfoRow(
                      'Method',
                      order.paymentMethod.toUpperCase(),
                      badge: true,
                      badgeColor: order.paymentMethod == 'online' ? Colors.purple : Colors.orange,
                    ),
                    _buildInfoRow(
                      'Status',
                      order.paymentStatus,
                      badge: true,
                      badgeColor: order.paymentStatus == 'completed' ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
                if (order.trackingId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildInfoRow('Tracking ID', order.trackingId!),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: const Color(0xFF7C3AED)),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool badge = false, Color? badgeColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: badge
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor?.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: badgeColor?.withOpacity(0.3) ?? Colors.transparent),
                    ),
                    child: Text(
                      value.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(SellerOrderItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade100,
              child: item.productImage.isNotEmpty
                  ? Image.network(
                      item.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 30);
                      },
                    )
                  : const Icon(Icons.image_not_supported, size: 30),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity} × ₹${item.discountPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            '₹${item.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isNegative = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isNegative ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'confirmed':
        return const Color(0xFF3B82F6);
      case 'out_for_delivery':
        return const Color(0xFF06B6D4);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_actions;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'shipped':
        return Icons.local_shipping;
      case 'out_for_delivery':
        return Icons.delivery_dining;
      case 'delivered':
        return Icons.verified;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatFullDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
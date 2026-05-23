import 'package:app_frontend/features/web_dashboard/order/model/seller_order_model.dart';
import 'package:flutter/material.dart';

class OrderDetailsDialog extends StatelessWidget {
  final SellerOrderModel order;

  const OrderDetailsDialog({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.orderId}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        order.orderStatus,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatStatus(order.orderStatus),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order.orderStatus),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Customer Info
              _buildSection(
                title: 'Customer Information',
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
                ],
              ),
              const SizedBox(height: 20),
              // Order Items
              _buildSection(
                title: 'Order Items',
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
                  const Divider(height: 20),
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
                children: [
                  _buildInfoRow('Method', order.paymentMethod.toUpperCase()),
                  _buildInfoRow('Status', order.paymentStatus),
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
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(SellerOrderItem item) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade100,
              child:
                  item.productImage.isNotEmpty
                      ? Image.network(
                        item.productImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      )
                      : const Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
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

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

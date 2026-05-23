import 'package:flutter/material.dart';

class OrderStatusDialog extends StatelessWidget {
  final String orderId;
  final String currentStatus;
  final Function(String newStatus, String? trackingId) onStatusUpdate;

  const OrderStatusDialog({
    Key? key,
    required this.orderId,
    required this.currentStatus,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? trackingId;
    String selectedStatus = currentStatus;

    final statuses = [
      'pending',
      'confirmed',
      'shipped',
      'out_for_delivery',
      'delivered',
      'cancelled',
    ];

    final statusLabels = {
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'shipped': 'Shipped',
      'out_for_delivery': 'Out for Delivery',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
    };

    final statusColors = {
      'pending': const Color(0xFFF59E0B),
      'confirmed': const Color(0xFF3B82F6),
      'shipped': const Color(0xFF8B5CF6),
      'out_for_delivery': const Color(0xFF06B6D4),
      'delivered': const Color(0xFF10B981),
      'cancelled': const Color(0xFFEF4444),
    };

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Update Order Status',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select new status for this order',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ...statuses.map((status) {
                  final isEnabled = _isValidTransition(currentStatus, status);
                  return RadioListTile<String>(
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: isEnabled
                        ? (value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          }
                        : null,
                    title: Text(
                      statusLabels[status]!,
                      style: TextStyle(
                        color: isEnabled ? Colors.black : Colors.grey.shade400,
                      ),
                    ),
                    subtitle: _getStatusDescription(status),
                    activeColor: statusColors[status],
                    contentPadding: EdgeInsets.zero,
                  );
                }),
                if (selectedStatus == 'shipped')
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Tracking ID (Optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.local_shipping),
                      ),
                      onChanged: (value) => trackingId = value,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedStatus != currentStatus) {
              onStatusUpdate(selectedStatus, trackingId);
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Update Status'),
        ),
      ],
    );
  }

  bool _isValidTransition(String current, String newStatus) {
    if (current == newStatus) return true;
    
    const validTransitions = {
      'pending': ['confirmed', 'cancelled'],
      'confirmed': ['shipped', 'cancelled'],
      'shipped': ['out_for_delivery', 'cancelled'],
      'out_for_delivery': ['delivered', 'cancelled'],
      'delivered': [],
      'cancelled': [],
    };
    
    return validTransitions[current]?.contains(newStatus) ?? false;
  }

  Widget _getStatusDescription(String status) {
    String description;
    switch (status) {
      case 'pending':
        description = 'Order placed, waiting for confirmation';
        break;
      case 'confirmed':
        description = 'Order confirmed by seller';
        break;
      case 'shipped':
        description = 'Order shipped to customer';
        break;
      case 'out_for_delivery':
        description = 'Order is out for delivery';
        break;
      case 'delivered':
        description = 'Order delivered to customer';
        break;
      case 'cancelled':
        description = 'Order cancelled';
        break;
      default:
        description = '';
    }
    return Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey));
  }
}
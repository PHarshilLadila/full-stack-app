import 'package:flutter/material.dart';

class OrderStatusDialog extends StatefulWidget {
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
  State<OrderStatusDialog> createState() => _OrderStatusDialogState();
}

class _OrderStatusDialogState extends State<OrderStatusDialog> with SingleTickerProviderStateMixin {
  String? trackingId;
  late String selectedStatus;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.edit_note,
                color: Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Update Order Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFF7C3AED), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Order #${widget.orderId.substring(widget.orderId.length - 12)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColors[widget.currentStatus]?.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusLabels[widget.currentStatus]!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColors[widget.currentStatus],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select new status for this order',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ...statuses.map((status) {
                    final isEnabled = _isValidTransition(widget.currentStatus, status);
                    final isSelected = selectedStatus == status;
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? statusColors[status]?.withOpacity(0.05) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? statusColors[status]! : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: RadioListTile<String>(
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
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isEnabled ? Colors.black : Colors.grey.shade400,
                          ),
                        ),
                        subtitle: isEnabled ? _getStatusDescription(status) : null,
                        activeColor: statusColors[status],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        secondary: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: statusColors[status]?.withOpacity(isSelected ? 0.2 : 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getStatusIcon(status),
                            color: statusColors[status],
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }),
                  if (selectedStatus == 'shipped')
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 300),
                      offset: const Offset(0, 0),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Tracking ID (Optional)',
                              hintText: 'Enter tracking number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.local_shipping, color: Color(0xFF7C3AED)),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            onChanged: (value) => trackingId = value,
                          ),
                        ),
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
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedStatus != widget.currentStatus) {
                widget.onStatusUpdate(selectedStatus, trackingId);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Update Status'),
          ),
        ],
      ),
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
    return Text(
      description,
      style: const TextStyle(fontSize: 11, color: Colors.grey),
    );
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
}
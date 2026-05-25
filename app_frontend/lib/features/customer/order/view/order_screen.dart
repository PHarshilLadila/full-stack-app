import 'package:app_frontend/features/web_dashboard/order/bloc/seller_order_bloc.dart';
import 'package:app_frontend/features/web_dashboard/order/bloc/seller_order_event.dart';
import 'package:app_frontend/features/web_dashboard/order/bloc/seller_order_state.dart';
import 'package:app_frontend/features/web_dashboard/order/model/seller_order_model.dart';
import 'package:app_frontend/features/web_dashboard/order/service/seller_order_service.dart';
import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:app_frontend/utils/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late SellerOrderBloc _orderBloc;
  final ScrollController _scrollController = ScrollController();
  String? _selectedFilter;

  final List<Map<String, String?>> _filterOptions = [
    {'label': 'All', 'value': null},
    {'label': 'Pending', 'value': 'pending'},
    {'label': 'Confirmed', 'value': 'confirmed'},
    {'label': 'Shipped', 'value': 'shipped'},
    {'label': 'Out for Delivery', 'value': 'out_for_delivery'},
    {'label': 'Delivered', 'value': 'delivered'},
    {'label': 'Cancelled', 'value': 'cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    _orderBloc = SellerOrderBloc(orderService: SellerOrderService());
    _orderBloc.add(const FetchSellerOrders());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_orderBloc.state is SellerOrderLoaded) {
        final state = _orderBloc.state as SellerOrderLoaded;
        if (!state.hasReachedMax) {
          _orderBloc.add(
            LoadMoreSellerOrders(page: state.pagination.currentPage + 1),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _orderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        title: "My Orders",
        onMenuTap: () {
          Scaffold.of(context).openDrawer();
        },
        onNotificationTap: () {},
        onFavouriteTap: () {},
        showMenu: true,
        showNotification: true,
        showFavourite: true,
      ),
      body: Stack(
        children: [
          const YellowCorner(),
          const BlueCenter(),
          const RedCorner(),
          SafeArea(
            child: BlocProvider.value(
              value: _orderBloc,
              child: BlocConsumer<SellerOrderBloc, SellerOrderState>(
                listener: (context, state) {
                  if (state is OrderStatusUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else if (state is SellerOrderError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      // _buildHeader(),
                      _buildFilterChips(),
                      Expanded(child: _buildBody(state)),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track & Manage',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All your customer orders at one place',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 35,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter['value'];
          return OrderFilterChip(
            label: filter['label']!,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _selectedFilter = filter['value'];
              });
              _orderBloc.add(FilterOrdersByStatus(status: filter['value']));
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(SellerOrderState state) {
    if (state is SellerOrderLoading && state is! SellerOrderLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
      );
    } else if (state is SellerOrderLoaded) {
      if (state.orders.isEmpty) {
        return _buildEmptyState();
      }

      final stats = OrderStats.fromOrders(state.orders);

      return RefreshIndicator(
        onRefresh: () async {
          _orderBloc.add(RefreshSellerOrders(status: state.currentFilter));
        },
        color: Colors.amber,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Stats Cards
            SliverToBoxAdapter(
              child: OrderStatsCards(
                stats: stats,
                selectedFilter: state.currentFilter,
                onFilterTap: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  _orderBloc.add(FilterOrdersByStatus(status: filter));
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Orders List
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final order = state.orders[index];
                return OrderCard(
                  order: order,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                  onStatusUpdate: (newStatus, trackingId) {
                    _orderBloc.add(
                      UpdateOrderStatus(
                        orderId: order.orderId,
                        orderStatus: newStatus,
                        trackingId: trackingId,
                      ),
                    );
                  },
                );
              }, childCount: state.orders.length),
            ),

            // Loading More Indicator
            if (state.hasReachedMax == false)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      );
    } else if (state is SellerOrderError) {
      return _buildErrorState(state.message);
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 60,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here once customers place orders',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _orderBloc.add(const RefreshSellerOrders());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Failed to Load Orders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _orderBloc.add(const RefreshSellerOrders());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final SellerOrderModel order;
  final VoidCallback onTap;
  final Function(String newStatus, String? trackingId) onStatusUpdate;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onTap,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Order ID and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.orderId.substring(order.orderId.length > 12 ? order.orderId.length - 12 : 0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(order.orderDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          order.orderStatus,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(
                            order.orderStatus,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(order.orderStatus),
                            size: 14,
                            color: _getStatusColor(order.orderStatus),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatStatus(order.orderStatus),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(order.orderStatus),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Customer Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.amber.withOpacity(0.1),
                      child: Text(
                        order.customer.fullName.isNotEmpty
                            ? order.customer.fullName[0].toUpperCase()
                            : 'C',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customer.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.customer.mobileNumber,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Items Preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${order.items.length} Item${order.items.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.items
                                  .map((item) => item.productName)
                                  .join(', '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF3B82F6),
                          side: const BorderSide(color: Color(0xFF3B82F6)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (_canUpdateStatus(order.orderStatus))
                      const SizedBox(width: 12),
                    if (_canUpdateStatus(order.orderStatus))
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showStatusUpdateDialog(context),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Update'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => OrderStatusBottomSheet(
            orderId: order.orderId,
            currentStatus: order.orderStatus,
            onStatusUpdate: onStatusUpdate,
          ),
    );
  }

  bool _canUpdateStatus(String status) {
    return !['delivered', 'cancelled'].contains(status);
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

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
        'title': 'Total',
        'value': stats.totalOrders,
        'icon': Icons.shopping_bag_outlined,
        'color': Colors.amber,
        'filter': null,
      },
      {
        'title': 'Pending',
        'value': stats.pendingOrders,
        'icon': Icons.pending_actions_outlined,
        'color': const Color(0xFFF59E0B),
        'filter': 'pending',
      },
      {
        'title': 'Confirmed',
        'value': stats.confirmedOrders,
        'icon': Icons.check_circle_outline,
        'color': const Color(0xFF3B82F6),
        'filter': 'confirmed',
      },
      {
        'title': 'Shipped',
        'value': stats.shippedOrders,
        'icon': Icons.local_shipping_outlined,
        'color': const Color(0xFF8B5CF6),
        'filter': 'shipped',
      },
      {
        'title': 'Out for Delivery',
        'value': stats.outForDeliveryOrders,
        'icon': Icons.delivery_dining_outlined,
        'color': const Color(0xFF06B6D4),
        'filter': 'out_for_delivery',
      },
      {
        'title': 'Delivered',
        'value': stats.deliveredOrders,
        'icon': Icons.verified_outlined,
        'color': const Color(0xFF10B981),
        'filter': 'delivered',
      },
      {
        'title': 'Cancelled',
        'value': stats.cancelledOrders,
        'icon': Icons.cancel_outlined,
        'color': const Color(0xFFEF4444),
        'filter': 'cancelled',
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          final isSelected = selectedFilter == card['filter'];
          final value = card['value'] as int;

          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 4),

            child: GestureDetector(
              onTap: () => onFilterTap(card['filter'] as String?),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // isSelected
                  //     // ? (card['color'] as Color).withOpacity(0.05)
                  //     ? (card['color'] as Color).withOpacity(0.05)
                  //     : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isSelected
                            ? card['color'] as Color
                            : Colors.grey.shade200,
                    width: isSelected ? 1 : 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (card['color'] as Color).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        card['icon'] as IconData,
                        color: card['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected
                                ? card['color'] as Color
                                : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      card['title'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const OrderFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final SellerOrderModel order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header Card
                _buildOrderHeader(context),
                const SizedBox(height: 12),

                // Customer Info Card
                _buildSection(
                  title: 'Customer Information',
                  icon: Icons.person_outline,
                  children: [
                    _buildInfoRow('Name', order.customer.fullName),
                    _buildInfoRow('Email', order.customer.email),
                    _buildInfoRow('Mobile', order.customer.mobileNumber),
                  ],
                ),
                const SizedBox(height: 12),

                // Shipping Address Card
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
                const SizedBox(height: 12),

                // Order Items Card
                _buildSection(
                  title: 'Order Items',
                  icon: Icons.shopping_bag_outlined,
                  children: [
                    ...order.items.map((item) => _buildOrderItem(item)),
                  ],
                ),
                const SizedBox(height: 12),

                // Order Summary Card
                _buildSection(
                  title: 'Order Summary',
                  icon: Icons.receipt_outlined,
                  children: [
                    _buildSummaryRow('Subtotal', order.subtotal),
                    if (order.discountAmount > 0)
                      _buildSummaryRow(
                        'Discount',
                        -order.discountAmount,
                        isNegative: true,
                      ),
                    _buildSummaryRow('Shipping', order.shippingCharge),
                    if (order.taxAmount > 0)
                      _buildSummaryRow('Tax', order.taxAmount),
                    const Divider(height: 20, thickness: 1),
                    _buildSummaryRow(
                      'Total Amount',
                      order.totalAmount,
                      isTotal: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Payment Info Card
                _buildSection(
                  title: 'Payment Information',
                  icon: Icons.payment_outlined,
                  children: [
                    _buildInfoRow(
                      'Method',
                      order.paymentMethod.toUpperCase(),
                      badge: true,
                      badgeColor:
                          order.paymentMethod == 'online'
                              ? Colors.purple
                              : Colors.orange,
                    ),
                    _buildInfoRow(
                      'Status',
                      order.paymentStatus,
                      badge: true,
                      badgeColor:
                          order.paymentStatus == 'completed'
                              ? Colors.green
                              : Colors.orange,
                    ),
                    if (order.trackingId != null)
                      _buildInfoRow('Tracking ID', order.trackingId!),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderId}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatFullDate(order.orderDate),
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
                      size: 16,
                      color: _getStatusColor(order.orderStatus),
                    ),
                    const SizedBox(width: 6),
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
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping,
                  color: Color.fromARGB(255, 125, 94, 1),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Status Timeline',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final statuses = [
      'pending',
      'confirmed',
      'shipped',
      'out_for_delivery',
      'delivered',
    ];
    final currentIndex = statuses.indexOf(order.orderStatus);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(statuses.length, (index) {
            final isCompleted = index <= currentIndex;
            final isCurrent = index == currentIndex;

            return Expanded(
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? Colors.amber : Colors.grey.shade300,
                      border:
                          isCurrent
                              ? Border.all(color: Colors.amber, width: 3)
                              : null,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : _getStepIcon(statuses[index]),
                      size: 16,
                      color: isCompleted ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatStatus(statuses[index]),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          isCurrent ? FontWeight.w600 : FontWeight.normal,
                      color: isCompleted ? Colors.black : Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(statuses.length - 1, (index) {
            final isCompleted = index < currentIndex;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: isCompleted ? Colors.amber : Colors.grey.shade300,
              ),
            );
          }),
        ),
      ],
    );
  }

  IconData _getStepIcon(String status) {
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
      default:
        return Icons.circle;
    }
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: Colors.amber),
              ),
              const SizedBox(width: 12),
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool badge = false,
    Color? badgeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child:
                badge
                    ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor?.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              badgeColor?.withOpacity(0.3) ??
                              Colors.transparent,
                        ),
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
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(SellerOrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade200,
              child:
                  item.productImage.isNotEmpty
                      ? Image.network(
                        item.productImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 30,
                            color: Colors.grey,
                          );
                        },
                      )
                      : const Icon(
                        Icons.image_not_supported,
                        size: 30,
                        color: Colors.grey,
                      ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
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
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${isNegative ? '- ' : ''}₹${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color:
                  isNegative ? Colors.green : (isTotal ? Colors.amber : null),
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

class OrderStatusBottomSheet extends StatefulWidget {
  final String orderId;
  final String currentStatus;
  final Function(String newStatus, String? trackingId) onStatusUpdate;

  const OrderStatusBottomSheet({
    Key? key,
    required this.orderId,
    required this.currentStatus,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  State<OrderStatusBottomSheet> createState() => _OrderStatusBottomSheetState();
}

class _OrderStatusBottomSheetState extends State<OrderStatusBottomSheet> {
  String selectedStatus = '';
  String? trackingId;
  final TextEditingController _trackingController = TextEditingController();

  final List<Map<String, dynamic>> statuses = [
    {
      'value': 'pending',
      'label': 'Pending',
      'icon': Icons.pending_actions,
      'color': Color(0xFFF59E0B),
      'description': 'Order placed, waiting for confirmation',
    },
    {
      'value': 'confirmed',
      'label': 'Confirmed',
      'icon': Icons.check_circle_outline,
      'color': Color(0xFF3B82F6),
      'description': 'Order confirmed by seller',
    },
    {
      'value': 'shipped',
      'label': 'Shipped',
      'icon': Icons.local_shipping,
      'color': Color(0xFF8B5CF6),
      'description': 'Order shipped to customer',
    },
    {
      'value': 'out_for_delivery',
      'label': 'Out for Delivery',
      'icon': Icons.delivery_dining,
      'color': Color(0xFF06B6D4),
      'description': 'Order is out for delivery',
    },
    {
      'value': 'delivered',
      'label': 'Delivered',
      'icon': Icons.verified,
      'color': Color(0xFF10B981),
      'description': 'Order delivered to customer',
    },
    {
      'value': 'cancelled',
      'label': 'Cancelled',
      'icon': Icons.cancel_outlined,
      'color': Color(0xFFEF4444),
      'description': 'Order cancelled',
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Update Order Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Order #${widget.orderId.substring(widget.orderId.length - 12)}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 20),

          // Status options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: statuses.length,
              itemBuilder: (context, index) {
                final status = statuses[index];
                final isEnabled = _isValidTransition(
                  widget.currentStatus,
                  status['value'],
                );
                final isSelected = selectedStatus == status['value'];
                final statusColor = status['color'] as Color;

                if (!isEnabled && widget.currentStatus != status['value']) {
                  return const SizedBox.shrink();
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? statusColor.withOpacity(0.05)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? statusColor : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (isEnabled ||
                            widget.currentStatus == status['value']) {
                          setState(() {
                            selectedStatus = status['value'];
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                status['icon'],
                                color: statusColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    status['label'],
                                    style: TextStyle(
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                      fontSize: 15,
                                      color:
                                          isSelected
                                              ? statusColor
                                              : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    status['description'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: statusColor,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Tracking ID field for shipped status
          if (selectedStatus == 'shipped')
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _trackingController,
                decoration: InputDecoration(
                  labelText: 'Tracking ID (Optional)',
                  hintText: 'Enter tracking number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(
                    Icons.local_shipping,
                    color: Color(0xFF7C3AED),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                onChanged: (value) => trackingId = value,
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedStatus != widget.currentStatus) {
                        widget.onStatusUpdate(selectedStatus, trackingId);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Update Status'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

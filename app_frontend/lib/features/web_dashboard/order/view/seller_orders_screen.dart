import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/seller_order_bloc.dart';
import '../bloc/seller_order_event.dart';
import '../bloc/seller_order_state.dart';
import '../model/seller_order_model.dart';
import '../service/seller_order_service.dart';
import 'widgets/order_stats_cards.dart';
import 'widgets/order_status_dialog.dart';
import 'widgets/order_details_dialog.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({Key? key}) : super(key: key);

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  late SellerOrderBloc _orderBloc;
  final ScrollController _scrollController = ScrollController();

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
      body: BlocProvider.value(
        value: _orderBloc,
        child: BlocConsumer<SellerOrderBloc, SellerOrderState>(
          listener: (context, state) {
            if (state is OrderStatusUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
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
              children: [_buildHeader(), Expanded(child: _buildBody(state))],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Orders Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track and manage all customer orders',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SellerOrderState state) {
    if (state is SellerOrderLoading && state is! SellerOrderLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
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
        color: const Color(0xFF7C3AED),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              OrderStatsCards(
                stats: stats,
                selectedFilter: state.currentFilter,
                onFilterTap: (filter) {
                  _orderBloc.add(FilterOrdersByStatus(status: filter));
                },
              ),
              const SizedBox(height: 24),
              _buildOrdersTable(state),
            ],
          ),
        ),
      );
    } else if (state is SellerOrderError) {
      return _buildErrorState(state.message);
    }
    return const SizedBox.shrink();
  }

  Widget _buildOrdersTable(SellerOrderLoaded state) {
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
            'Orders List',
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
              columnSpacing: 24,
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
                    'Total',
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
                  state.orders.map((order) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            order.orderId.length > 12
                                ? '${order.orderId.substring(0, 12)}...'
                                : order.orderId,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(Text(order.customer.fullName)),
                        DataCell(Text('${order.items.length} items')),
                        DataCell(
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
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
                                fontSize: 11,
                                color: _getStatusColor(order.orderStatus),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(_formatDate(order.orderDate))),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility, size: 18),
                                onPressed: () => _showOrderDetails(order),
                                color: const Color(0xFF3B82F6),
                                tooltip: 'View Details',
                              ),
                              if (_canUpdateStatus(order.orderStatus))
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed:
                                      () => _showStatusUpdateDialog(order),
                                  color: const Color(0xFF7C3AED),
                                  tooltip: 'Update Status',
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
          if (!state.hasReachedMax)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF7C3AED),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Orders Found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here once customers place orders',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _orderBloc.add(const RefreshSellerOrders());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
          const SizedBox(height: 16),
          const Text(
            'Failed to Load Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _orderBloc.add(const RefreshSellerOrders());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(SellerOrderModel order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailsDialog(order: order),
    );
  }

  void _showStatusUpdateDialog(SellerOrderModel order) {
    showDialog(
      context: context,
      builder:
          (context) => OrderStatusDialog(
            orderId: order.orderId,
            currentStatus: order.orderStatus,
            onStatusUpdate: (newStatus, trackingId) {
              _orderBloc.add(
                UpdateOrderStatus(
                  orderId: order.orderId,
                  orderStatus: newStatus,
                  trackingId: trackingId,
                ),
              );
            },
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

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

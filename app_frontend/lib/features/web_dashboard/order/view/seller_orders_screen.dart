import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:material_table_view/table_view_typedefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/seller_order_bloc.dart';
import '../bloc/seller_order_event.dart';
import '../bloc/seller_order_state.dart';
import '../model/seller_order_model.dart';
import '../service/seller_order_service.dart';
import 'widgets/order_stats_cards.dart';
import 'widgets/order_status_dialog.dart';
import 'widgets/order_details_dialog.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  late SellerOrderBloc orderBloc;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    orderBloc = SellerOrderBloc(orderService: SellerOrderService());
    orderBloc.add(const FetchSellerOrders());
    scrollController.addListener(onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('seller_web_token_saved');
      print('🔍 Web FCM Token Saved: ${token != null ? "Yes" : "No"}');
      if (token != null) {
        print(
          '🔍 Token: ${token.substring(0, token.length > 20 ? 20 : token.length)}...',
        );
      }
    });
  }

  void onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (orderBloc.state is SellerOrderLoaded) {
        final state = orderBloc.state as SellerOrderLoaded;
        if (!state.hasReachedMax) {
          orderBloc.add(
            LoadMoreSellerOrders(page: state.pagination.currentPage + 1),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    orderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocProvider.value(
        value: orderBloc,
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
              children: [
                CommonAppBar(
                  title: 'Orders Management',
                  subtitle: 'Track and manage all customer orders.',
                ),
                Expanded(child: buildBody(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildBody(SellerOrderState state) {
    if (state is SellerOrderLoading && state is! SellerOrderLoaded) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading orders data...'),
            ],
          ),
        ),
      );
    } else if (state is SellerOrderLoaded) {
      if (state.orders.isEmpty) {
        return buildEmptyState();
      }

      final stats = OrderStats.fromOrders(state.orders);

      return RefreshIndicator(
        onRefresh: () async {
          orderBloc.add(RefreshSellerOrders(status: state.currentFilter));
        },
        color: const Color(0xFF7C3AED),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              OrderStatsCards(
                stats: stats,
                selectedFilter: state.currentFilter,
                onFilterTap: (filter) {
                  orderBloc.add(FilterOrdersByStatus(status: filter));
                },
              ),
              const SizedBox(height: 24),
              buildOrdersTable(state),
            ],
          ),
        ),
      );
    } else if (state is SellerOrderError) {
      return buildErrorState(state.message);
    }
    return const SizedBox.shrink();
  }

  Widget buildOrdersTable(SellerOrderLoaded state) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 1000;
    final availableWidth = screenSize.width - 48;

    /// Total = 100
    final columnFlex = [14, 16, 10, 10, 10, 10, 10];

    final columnWidths =
        columnFlex.map((flex) => (availableWidth * flex / 100)).toList();

    final rowHeight = 90.0;
    final headerHeight = 70.0;
    final tableHeight = (state.orders.length * rowHeight) + headerHeight;

    final columns = [
      TableColumn(width: columnWidths[0], minResizeWidth: 220),
      TableColumn(width: columnWidths[1], minResizeWidth: 220),
      TableColumn(width: columnWidths[2], minResizeWidth: 100),
      TableColumn(width: columnWidths[3], minResizeWidth: 120),
      TableColumn(width: columnWidths[4], minResizeWidth: 150),
      TableColumn(width: columnWidths[5], minResizeWidth: 120),
      TableColumn(width: columnWidths[6], minResizeWidth: 140),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: tableHeight,
          child: TableView.builder(
            columns: columns,
            rowCount: state.orders.length,
            rowHeight: rowHeight,
            headerHeight: headerHeight,
            style: TableViewStyle(
              dividers: TableViewDividersStyle(
                horizontal: TableViewHorizontalDividersStyle(
                  header: TableViewHorizontalDividerStyle(
                    color: Colors.grey.shade300,
                    thickness: 0.5,
                  ),
                  footer: TableViewHorizontalDividerStyle(
                    color: Colors.grey.shade300,
                    thickness: 0.5,
                  ),
                ),
              ),
            ),

            rowBuilder: (context, row, TableRowContentBuilder contentBuilder) {
              final order = state.orders[row];
              final statusColor = getStatusColor(order.orderStatus);

              return contentBuilder(context, (context, column) {
                switch (column) {
                  /// ORDER ID
                  case 0:
                    return Container(
                      width: columnWidths[column],
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.orderId,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 11 : 13,
                              color: const Color(0xFF1E293B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'ID: ${order.orderId}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 9 : 11,
                              color: Colors.grey.shade500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );

                  /// CUSTOMER
                  case 1:
                    return Container(
                      width: columnWidths[column],
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: isSmallScreen ? 18 : 22,
                            backgroundColor: const Color(
                              0xFF7C3AED,
                            ).withOpacity(0.1),
                            child: Text(
                              (order.customer.fullName.isNotEmpty
                                  ? order.customer.fullName[0].toUpperCase()
                                  : "?"),
                              style: const TextStyle(
                                color: Color(0xFF7C3AED),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.customer.fullName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 11 : 13,
                                    color: const Color(0xFF1E293B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  order.customer.mobileNumber,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 9 : 11,
                                    color: Colors.grey.shade500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

                  /// ITEMS
                  case 2:
                    return Container(
                      width: columnWidths[column],
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${order.items.length} Items',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 11 : 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    );

                  /// TOTAL
                  case 3:
                    return Container(
                      width: columnWidths[column],
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '₹${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: isSmallScreen ? 12 : 14,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    );

                  /// STATUS
                  case 4:
                    return Container(
                      width: columnWidths[column],
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 12,
                          vertical: isSmallScreen ? 5 : 7,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          formatStatus(order.orderStatus),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 12,
                            color: statusColor,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );

                  /// DATE
                  case 5:
                    return Container(
                      width: columnWidths[column],
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        formatDate(order.orderDate),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 11 : 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    );

                  /// ACTIONS
                  case 6:
                    return Container(
                      width: columnWidths[column],
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined),
                            onPressed: () => showOrderDetails(order),
                            tooltip: 'View Details',
                            color: const Color(0xFF3B82F6),
                            iconSize: isSmallScreen ? 18 : 20,
                          ),

                          if (canUpdateStatus(order.orderStatus))
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => showStatusUpdateDialog(order),
                              tooltip: 'Update Status',
                              color: const Color(0xFF7C3AED),
                              iconSize: isSmallScreen ? 18 : 20,
                            ),
                        ],
                      ),
                    );

                  default:
                    return const SizedBox();
                }
              });
            },

            /// HEADER
            headerBuilder: (context, contentBuilder) {
              final headers = [
                'Order ID',
                'Customer',
                'Items',
                'Total',
                'Status',
                'Date',
                'Actions',
              ];

              return contentBuilder(context, (context, column) {
                return Container(
                  width: columnWidths[column],
                  alignment:
                      column == 0 || column == 1
                          ? Alignment.centerLeft
                          : Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    headers[column],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }

  Widget buildEmptyState() {
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
              orderBloc.add(const RefreshSellerOrders());
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

  Widget buildErrorState(String message) {
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
              orderBloc.add(const RefreshSellerOrders());
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

  void showOrderDetails(SellerOrderModel order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailsDialog(order: order),
    );
  }

  void showStatusUpdateDialog(SellerOrderModel order) {
    showDialog(
      context: context,
      builder:
          (context) => OrderStatusDialog(
            orderId: order.orderId,
            currentStatus: order.orderStatus,
            onStatusUpdate: (newStatus, trackingId) {
              orderBloc.add(
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

  bool canUpdateStatus(String status) {
    return !['delivered', 'cancelled'].contains(status);
  }

  Color getStatusColor(String status) {
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

  String formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

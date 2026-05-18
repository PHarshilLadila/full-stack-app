// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:app_frontend/features/web_dashboard/view/analytics_content.dart';
import 'package:app_frontend/features/web_dashboard/view/customers_content.dart';
import 'package:app_frontend/features/web_dashboard/view/dashboard_content.dart';
import 'package:app_frontend/features/web_dashboard/view/help_support_content.dart';
import 'package:app_frontend/features/web_dashboard/view/marketing_content.dart';
import 'package:app_frontend/features/web_dashboard/view/orders_content.dart';
import 'package:app_frontend/features/web_dashboard/view/payouts_content.dart';
import 'package:app_frontend/features/web_dashboard/view/product_screen.dart';
import 'package:app_frontend/features/web_dashboard/view/returns_refunds_content.dart';
import 'package:app_frontend/features/web_dashboard/view/store_settings_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebDashboardScreen extends StatefulWidget {
  const WebDashboardScreen({super.key});

  @override
  State<WebDashboardScreen> createState() => _WebDashboardScreenState();
}

class _WebDashboardScreenState extends State<WebDashboardScreen> {
  bool _isDrawerExpanded = true;
  int _selectedIndex = 0;
  late UserBloc _userBloc;
  Map<String, dynamic>? _sellerStats;

  final List<DrawerItem> _drawerItems = [
    DrawerItem('Dashboard', Icons.dashboard_outlined, Icons.dashboard),
    DrawerItem('Products', Icons.inventory_2_outlined, Icons.inventory_2),
    DrawerItem('Orders', Icons.shopping_bag_outlined, Icons.shopping_bag),
    DrawerItem(
      'Returns & Refunds',
      Icons.assignment_return_outlined,
      Icons.assignment_return,
    ),
    DrawerItem('Customers', Icons.people_outline, Icons.people),
    DrawerItem('Marketing', Icons.campaign_outlined, Icons.campaign),
    DrawerItem('Analytics', Icons.analytics_outlined, Icons.analytics),
    DrawerItem(
      'Payouts',
      Icons.account_balance_wallet_outlined,
      Icons.account_balance_wallet,
    ),
    DrawerItem('Store Settings', Icons.store_outlined, Icons.store),
    DrawerItem('Help & Support', Icons.help_outline, Icons.help),
  ];

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userService: UserService());
    _loadUserData();
    _loadSellerStats();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      _userBloc.add(FetchUserProfile(token));
    }
  }

  Future<void> _loadSellerStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      try {
        final stats = await UserService().getSellerStats(token);
        setState(() {
          _sellerStats = stats;
        });
      } catch (e) {
        debugPrint("Error loading seller stats: $e");
      }
    }
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerExpanded = !_isDrawerExpanded;
    });
  }

  void _onDrawerItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: Scaffold(
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            String userName = "Seller";
            String userEmail = "seller@velmora.com";
            String? userProfileImage;
            String userRole = "seller";

            if (state is UserLoaded) {
              userName = state.user.fullName;
              userEmail = state.user.email;
              userProfileImage = state.user.profileImage;
              userRole = state.user.role;
            }

            return Row(
              children: [
                // Custom Drawer
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _isDrawerExpanded ? 260 : 80,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// HEADER
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7C3AED), Color(0xFFC084FC)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'V',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            /// Brand Name
                            if (_isDrawerExpanded) ...[
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'velmora',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _drawerItems.length,
                          itemBuilder: (context, index) {
                            final item = _drawerItems[index];
                            final isSelected = _selectedIndex == index;
                            return _buildDrawerItem(
                              item: item,
                              isSelected: isSelected,
                              isExpanded: _isDrawerExpanded,
                              onTap: () => _onDrawerItemTap(index),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _toggleDrawer,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: _isDrawerExpanded
                                  ? const Color(0xFF7C3AED)
                                  : const Color(0xFFF6F1F9),
                              foregroundColor: _isDrawerExpanded
                                  ? Colors.white
                                  : const Color(0xFF7C3AED),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isDrawerExpanded
                                      ? Icons.chevron_left
                                      : Icons.chevron_right,
                                ),
                                if (_isDrawerExpanded) ...[
                                  const SizedBox(width: 8),
                                  const Text('Collapse'),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: _buildMainContent(
                    userName: userName,
                    userEmail: userEmail,
                    userProfileImage: userProfileImage,
                    userRole: userRole,
                    sellerStats: _sellerStats,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent({
    required String userName,
    required String userEmail,
    required String? userProfileImage,
    required String userRole,
    required Map<String, dynamic>? sellerStats,
  }) {
    switch (_selectedIndex) {
      case 0:
        return DashboardContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
          sellerStats: sellerStats,
        );
      case 1:
        return ProductsContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      case 2:
        return OrdersContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      case 3:
        return ReturnsRefundsContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      case 4:
        return CustomersContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      case 5:
        return MarketingContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      case 6:
        return AnalyticsContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      case 7:
        return PayoutsContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      case 8:
        return StoreSettingsContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      case 9:
        return HelpSupportContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
        );
      default:
        return DashboardContent(
          userName: userName,
          userEmail: userEmail,
          userProfileImage: userProfileImage,
          sellerStats: sellerStats,
        );
    }
  }

  Widget _buildDrawerItem({
    required DrawerItem item,
    required bool isSelected,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: (isSelected && isExpanded)
                ? const Color(0xFF7C3AED).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? item.selectedIcon : item.icon,
                color: isSelected
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF64748B),
                size: 22,
              ),
              if (isExpanded) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final IconData selectedIcon;

  DrawerItem(this.title, this.icon, this.selectedIcon);
}
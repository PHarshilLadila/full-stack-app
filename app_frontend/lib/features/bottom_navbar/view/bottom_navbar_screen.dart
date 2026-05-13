// bottom_navbar_screen.dart
import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_event.dart';
import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_state.dart';
import 'package:app_frontend/features/customer/cart/view/cart_screen.dart';
import 'package:app_frontend/features/customer/categories_screen/view/categories_screen.dart';
import 'package:app_frontend/features/customer/home/view/home_screen.dart';
import 'package:app_frontend/features/customer/profile/view/profile_screen.dart';
import 'package:app_frontend/features/seller/products/view/seller_product_screen.dart';
import 'package:app_frontend/features/seller/seller_profile/view/seller_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  late String userRole = 'customer';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role') ?? 'customer';
      isLoading = false;
    });
  }

  // Get screens based on user role
  List<Widget> _getScreens(String role) {
    if (role == 'seller') {
      return [
        const HomeScreen(), // Seller can have their own home screen
        const SellerProductScreen(),
        // Seller might not have cart - you can customize
        const CartScreen(),
        const SellerProfileScreen(),
      ];
    } else {
      return [
        const HomeScreen(),
        const CategoriesScreen(),
        const CartScreen(),
        const CustomerProfileScreen(),
      ];
    }
  }

  // Get bottom nav items based on role
  List<BottomNavigationBarItem> _getNavItems(String role) {
    if (role == 'seller') {
      return [
        const BottomNavigationBarItem(
          icon: HugeIcon(icon: HugeIcons.strokeRoundedDashboardBrowsing),
          activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedDashboardBrowsing),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: HugeIcon(icon: HugeIcons.strokeRoundedPackage),
          activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedPackage),
          label: 'Products',
        ),
        const BottomNavigationBarItem(
          icon: HugeIcon(icon: HugeIcons.strokeRoundedFile01),
          activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedFile01),
          label: 'Orders', // Changed for seller
        ),
        const BottomNavigationBarItem(
          icon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
          activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
          label: 'Profile', // Changed for seller
        ),
      ];
    } else {
      return [
        const BottomNavigationBarItem(
          icon: HugeIcon(icon: HugeIcons.strokeRoundedHome03),
          activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedHome03),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: HugeIcon(icon: HugeIcons.strokeRoundedGridView),
          activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedGridView),
          label: 'Categories',
        ),
        const BottomNavigationBarItem(
          icon: HugeIcon(icon: HugeIcons.strokeRoundedShoppingCart01),
          activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedShoppingCart01),
          label: 'Cart',
        ),
        const BottomNavigationBarItem(
          icon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
          activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
          label: 'Profile',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    final screens = _getScreens(userRole);
    final navItems = _getNavItems(userRole);

    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          return screens[state.selectedIndex];
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 110, // 70
        child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.amber,
              unselectedItemColor: Colors.grey,
              iconSize: 28,
              selectedFontSize: 13,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<BottomNavigationBloc>().add(
                  BottomNavigationItemTapped(index),
                );
              },
              items: navItems,
            );
          },
        ),
      ),
    );
  }
}

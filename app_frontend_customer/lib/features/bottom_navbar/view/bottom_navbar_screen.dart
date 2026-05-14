import 'package:app_frontend_customer/features/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:app_frontend_customer/features/bottom_navbar/bloc/bottom_navbar_event.dart';
import 'package:app_frontend_customer/features/bottom_navbar/bloc/bottom_navbar_state.dart';
import 'package:app_frontend_customer/features/customer/cart/view/cart_screen.dart';
import 'package:app_frontend_customer/features/customer/categories_screen/view/categories_screen.dart';
import 'package:app_frontend_customer/features/customer/home/view/home_screen.dart';
import 'package:app_frontend_customer/features/customer/profile/view/profile_screen.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      // Not authenticated, redirect to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Customer screens only
  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const CartScreen(),
    const CustomerProfileScreen(),
  ];

  // Customer bottom nav items
  final List<BottomNavigationBarItem> _navItems = [
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          return _screens[state.selectedIndex];
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 110,
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
              items: _navItems,
            );
          },
        ),
      ),
    );
  }
}

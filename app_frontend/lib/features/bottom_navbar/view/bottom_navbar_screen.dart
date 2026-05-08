import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_event.dart';
import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_state.dart';
import 'package:app_frontend/features/customer/cart/view/cart_screen.dart';
import 'package:app_frontend/features/customer/categories_screen/view/categories_screen.dart';
import 'package:app_frontend/features/customer/home/view/home_screen.dart';
import 'package:app_frontend/features/customer/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({super.key});

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const CartScreen(),
    const CustomerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          return _screens[state.selectedIndex];
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
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

              items: [
                BottomNavigationBarItem(
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedHome03),
                  activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedHome03),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedGridView),
                  activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedGridView),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedShoppingCart01),
                  activeIcon: HugeIcon(
                    icon: HugeIcons.strokeRoundedShoppingCart01,
                  ),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
                  activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser),
                  label: 'Profile',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

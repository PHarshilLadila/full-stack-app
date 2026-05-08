import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_event.dart';
import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_state.dart';
import 'package:app_frontend/features/customer/cart/view/cart_screen.dart';
import 'package:app_frontend/features/customer/categories_screen.dart/view/categories_screen.dart';
import 'package:app_frontend/features/customer/customer_profile/view/customer_profile_screen.dart';
import 'package:app_frontend/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({super.key});

  // Screens for each tab
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
      bottomNavigationBar:
          BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
            builder: (context, state) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.amber,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
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
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category_outlined),
                    activeIcon: Icon(Icons.category),
                    label: 'Categories',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_outlined),
                    activeIcon: Icon(Icons.shopping_cart),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
    );
  }
}

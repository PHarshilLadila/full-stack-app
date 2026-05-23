import 'package:app_frontend/features/web_dashboard/order/view/seller_orders_screen.dart';
import 'package:flutter/material.dart';

class OrdersContent extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;

  const OrdersContent({
    Key? key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SellerOrdersScreen();
  }
}

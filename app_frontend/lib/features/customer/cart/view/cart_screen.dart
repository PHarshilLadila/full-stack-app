import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          YellowCorner(),
          BlueCenter(),
          RedCorner(),
          SafeArea(child: Container()),
        ],
      ),
    );
  }
}

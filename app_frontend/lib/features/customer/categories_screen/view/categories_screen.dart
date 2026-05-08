import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [  YellowCorner(),
        BlueCenter(),
        RedCorner(), SafeArea(child: Container())],
      ),
    );
  }
}

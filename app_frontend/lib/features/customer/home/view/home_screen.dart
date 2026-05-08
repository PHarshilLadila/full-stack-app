import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [  YellowCorner(),
        BlueCenter(),
        RedCorner(), SafeArea(child: Container())]),
    );
  }
}

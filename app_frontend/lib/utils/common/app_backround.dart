import 'package:flutter/material.dart';

//  RedCorner(),
//  BlueCenter(),
//  YellowCorner(),

class RedCorner extends StatelessWidget {
  const RedCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.07),
              blurRadius: 80,
              spreadRadius: 80,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

class BlueCenter extends StatelessWidget {
  const BlueCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.09),
              blurRadius: 50,
              spreadRadius: 40,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

class YellowCorner extends StatelessWidget {
  const YellowCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.09),
              blurRadius: 80,
              spreadRadius: 80,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

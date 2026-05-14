// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final String loadingPageName;
  final bool isExtra;
  final String extraText;
  const CustomLoader({
    super.key,
    required this.loadingPageName,
    this.isExtra = false,
    this.extraText = "",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 120,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.amber),
            SizedBox(height: 16),
            Text(
              isExtra == true ? extraText : "Loading $loadingPageName...",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

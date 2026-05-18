 import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:app_frontend/utils/common/widgets/app_placeholder.dart';
import 'package:flutter/material.dart';

class CustomersContent extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  const CustomersContent({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CommonAppBar(
            title: 'Customers',
            subtitle: 'View and manage your customer database',
          ),
          AppPlaceholder.build(icon: Icons.people, title: "Customers"),
        ],
      ),
    );
  }
}

import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:app_frontend/utils/common/widgets/app_placeholder.dart';
import 'package:flutter/material.dart';

class AnalyticsContent extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  const AnalyticsContent({
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
            title: 'Analytics',
            subtitle: 'View detailed reports and insights',
          ),
          AppPlaceholder.build(
            icon: Icons.dashboard_outlined,
            title: "Analytics",
          ),
        ],
      ),
    );
  }
}

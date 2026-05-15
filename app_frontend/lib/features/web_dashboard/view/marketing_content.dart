import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
import 'package:app_frontend/utils/common/widgets/app_placeholder.dart';
import 'package:flutter/material.dart';

class MarketingContent extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;
  const MarketingContent({
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
            title: 'Marketing',
            subtitle: 'Create campaigns and track marketing performance',
          ),
          AppPlaceholder.build(icon: Icons.campaign, title: "Marketing"),
        ],
      ),
    );
  }
}

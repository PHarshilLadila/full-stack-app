import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:app_frontend/utils/common/widgets/app_placeholder.dart';
import 'package:flutter/material.dart';

class HelpSupportContent extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;

  const HelpSupportContent({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonAppBar(
            title: 'Help & Support',
            subtitle: 'Get assistance and browse documentation',
          ),
          AppPlaceholder.build(icon: Icons.help, title: "Help & Support"),
        ],
      ),
    );
  }
}

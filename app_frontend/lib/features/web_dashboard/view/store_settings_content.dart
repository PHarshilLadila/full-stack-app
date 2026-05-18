 import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:app_frontend/utils/common/widgets/app_placeholder.dart';
import 'package:flutter/material.dart';

class StoreSettingsContent extends StatelessWidget {
      final String userName;
  final String userEmail;
  final String? userProfileImage;
  const StoreSettingsContent({super.key, required this.userName, required this.userEmail, this.userProfileImage});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CommonAppBar(
            title: 'Store Settings',
            subtitle: 'Configure your store preferences and details',
          ),
          AppPlaceholder.build(
            icon: Icons.store,
            title: "Store Settings",
          ),
         ],
      ),
    );
  } 
}
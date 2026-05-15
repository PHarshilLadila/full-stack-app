import 'package:app_frontend/features/web_dashboard/web_dashboard.dart';
import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
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
          _buildPlaceholderContent(Icons.store, 'Store Settings'),
        ],
      ),
    );
  }
  Widget _buildPlaceholderContent(IconData icon, String title) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: const Color(0xFF7C3AED).withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Content for $title will be displayed here',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
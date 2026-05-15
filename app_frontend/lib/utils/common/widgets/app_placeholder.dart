import 'package:flutter/material.dart';

class AppPlaceholder {
  /// Basic placeholder widget (most used)
  static Widget build({
    required IconData icon,
    required String title,
    String? subtitle,
    double height = 400,
    Color? iconColor,
    Color? titleColor,
    Color? subtitleColor,
  }) {
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: (iconColor ?? const Color(0xFF7C3AED)).withOpacity(0.3),
            ),
            const SizedBox(height: 16),

            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: titleColor ?? const Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle ?? 'Content for $title will be displayed here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor ?? Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state version (for lists, products, orders)
  static Widget emptyState({
    required String title,
    required String message,
    IconData icon = Icons.inbox_outlined,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 70,
            color: const Color(0xFF7C3AED).withOpacity(0.25),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Loading placeholder (optional but useful)
  static Widget loading({
    String message = "Loading...",
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF7C3AED),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
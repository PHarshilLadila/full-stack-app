// app_frontend/lib/utils/token_saver.dart
import 'package:app_frontend/service/fcm_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSaver {
  static Future<void> saveFcmTokenAfterLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');
    
    if (authToken != null && authToken.isNotEmpty) {
      await FCMNotificationService.saveTokenToBackend(authToken);
    }
  }
}
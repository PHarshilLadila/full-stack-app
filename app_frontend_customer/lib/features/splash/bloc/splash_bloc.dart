// features/splash/bloc/splash_bloc.dart
import 'dart:developer';
import 'package:app_frontend_customer/service/fcm_notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      emit(SplashLoading());

      await _checkApiConnection(emit);
      await _checkAuthStatus(emit);
    });
  }

  Future<void> _checkApiConnection(Emitter<SplashState> emit) async {
    try {
      final response = await http
          .get(Uri.parse("https://full-stack-app-1-4iqk.onrender.com/"))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(SplashApiSuccess(data['message'] ?? 'API Working'));
      } else {
        emit(SplashApiError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      log("API Connection Error: $e");
      emit(SplashApiError('Unable to connect to server'));
    }

    await Future.delayed(const Duration(milliseconds: 1000));
  }

  Future<void> _checkAuthStatus(Emitter<SplashState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getString('user_id');
    final userRole = prefs.getString('user_role');
    final userName = prefs.getString('user_name');

    log("Splash - Token exists: ${token != null}");
    log("Splash - User Role: $userRole");
    log("Splash - User ID: $userId");

    if (token != null && token.isNotEmpty) {
      // Refresh FCM token on app start (optional but good practice)
      await FCMNotificationService.saveTokenToBackend(token);

      emit(
        Authenticated(
          token: token,
          userId: userId,
          userRole: userRole ?? 'customer',
          userName: userName,
        ),
      );
    } else {
      emit(Unauthenticated());
    }
  }
}

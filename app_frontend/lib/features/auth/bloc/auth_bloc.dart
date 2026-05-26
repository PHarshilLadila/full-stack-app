// app_frontend/lib/features/auth/bloc/auth_bloc.dart
import 'dart:developer';
import 'package:app_frontend/service/fcm_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../model/login_model.dart';
import '../model/register_model.dart';
import '../service/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService service;

  AuthBloc(this.service) : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final message = await service.register(event.registerModel);
        log("Register Success: $message");
        emit(AuthSuccess(message));
      } catch (e) {
        log("Register Error: $e");
        emit(AuthError(e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await service.login(event.loginModel);

        log("Login Success - Role: ${response.role}");
        log("Login Success - UserId: ${response.userId}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.token);
        await prefs.setString('user_role', response.role.toLowerCase());
        await prefs.setString('user_id', response.userId);

        if (response.user != null) {
          await prefs.setString('user_name', response.user!.fullName);
        }

        // ==============================================
        // SAVE SELLER FCM TOKEN AFTER LOGIN
        // ==============================================
        // Add small delay to ensure token is available
        await Future.delayed(const Duration(milliseconds: 500));
        await FCMNotificationService.saveTokenToBackend(response.token);
        // ==============================================

        emit(
          AuthSuccess(
            response.message,
            token: response.token,
            role: response.role,
          ),
        );
      } catch (e) {
        log("Login Error: $e");
        emit(AuthError(e.toString()));
      }
    });

    // Add logout event handler
    on<LogoutEvent>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        
        if (token != null) {
          await FCMNotificationService.removeTokenFromBackend(token);
        }
        
        await prefs.clear();
        emit(AuthInitial());
      } catch (e) {
        log("Logout Error: $e");
        emit(AuthError(e.toString()));
      }
    });
  }
}
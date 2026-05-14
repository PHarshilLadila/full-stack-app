import 'dart:developer';

import 'package:app_frontend_customer/features/auth/bloc/auth_event.dart';
import 'package:app_frontend_customer/features/auth/bloc/auth_state.dart';
import 'package:app_frontend_customer/features/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService service;

  AuthBloc(this.service) : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final message = await service.register(event.registerModel);
        log("Register Success: $message");
        
        // After successful registration, just show success and stay on auth screen
        // User will manually login
        emit(AuthSuccess(message, isRegistration: true));
      } catch (e) {
        log("Register Error: $e");
        debugPrint("Register Error : $e");
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
        
        // Save all user data locally
        await prefs.setString('auth_token', response.token);
        await prefs.setString('user_role', response.role.toLowerCase());
        await prefs.setString('user_id', response.userId);

        if (response.user != null) {
          await prefs.setString('user_name', response.user!.fullName);
          await prefs.setString('user_email', response.user!.email);
          await prefs.setString('user_mobile', response.user!.mobile);
          await prefs.setString('user_username', response.user!.username);
        }

        emit(
          AuthSuccess(
            response.message,
            token: response.token,
            role: response.role,
            userId: response.userId,
            isRegistration: false,
          ),
        );
      } catch (e) {
        log("Login Error: $e");
        debugPrint("Login Error : $e");
        emit(AuthError(e.toString()));
      }
    });
  }
}
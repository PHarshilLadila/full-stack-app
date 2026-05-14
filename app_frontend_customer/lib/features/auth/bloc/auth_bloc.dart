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
        emit(AuthSuccess(message));
      } catch (e) {
        log("Register Error: $e");
        debugPrint("Register Error : $e");
        emit(AuthError(e.toString()));
      }
    });

    // auth_bloc.dart - LoginEvent handler (already correct, but verify)
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final response = await service.login(event.loginModel);

        log("Login Success - Role: ${response.role}");
        log("Login Success - UserId: ${response.userId}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.token);
        await prefs.setString(
          'user_role',
          response.role.toLowerCase(),
        ); // Ensure lowercase
        await prefs.setString('user_id', response.userId);

        if (response.user != null) {
          await prefs.setString('user_name', response.user!.fullName);
        }

        emit(
          AuthSuccess(
            response.message,
            token: response.token,
            role: response.role,
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

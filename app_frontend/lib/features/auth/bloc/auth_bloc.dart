import 'package:app_frontend/features/auth/bloc/auth_event.dart';
import 'package:app_frontend/features/auth/bloc/auth_state.dart';
import 'package:app_frontend/features/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService service;

  AuthBloc(this.service) : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final message = await service.register(event.registerModel);
        emit(AuthSuccess(message));
      } catch (e) {
        debugPrint("Register Error");
        emit(AuthError(e.toString()));
      }
    });
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final response = await service.login(event.loginModel);

        // if using String token
        emit(AuthSuccess("Login Successful", token: response.toString()));

        // if using LoginResponseModel:
        // emit(AuthSuccess(response.message, token: response.token));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}

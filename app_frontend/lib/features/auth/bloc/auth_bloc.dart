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
  }
}

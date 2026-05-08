// lib/features/user/bloc/user_bloc.dart

import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(UserInitial()) {
    on<FetchUserProfile>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userService.getUserProfile(event.token);
        emit(UserLoaded(user));
      } catch (e) {
        debugPrint("Get Profile Error : $e");

        emit(UserError(e.toString()));
      }
    });
    on<UpdateUserProfile>((event, emit) async {
      emit(UserUpdating());
      try {
        final result = await userService.updateUserProfile(
          token: event.token,
          fullName: event.fullName,
          username: event.username,
          email: event.email,
          mobile: event.mobile,
          profileImage: event.profileImage,
        );

        // After successful update, fetch the updated profile
        final updatedUser = await userService.getUserProfile(event.token);
        emit(UserUpdated(updatedUser, result['message']));
      } catch (e) {
        debugPrint("Update Details Error : $e");

        emit(UserError(e.toString()));
      }
    });
  }
}

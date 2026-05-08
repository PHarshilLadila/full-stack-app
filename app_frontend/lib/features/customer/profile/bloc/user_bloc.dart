import 'dart:developer';
import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(UserInitial()) {
    on<FetchUserProfile>((event, emit) async {
      log("FetchUserProfile event received");
      emit(UserLoading());
      try {
        log("Calling getUserProfile with token");
        final user = await userService.getUserProfile(event.token);
        log("User loaded successfully: ${user.fullName}, Role: ${user.role}");
        emit(UserLoaded(user));
      } catch (e) {
        log("Get Profile Error: $e");
        debugPrint("Get Profile Error : $e");
        emit(UserError(e.toString()));
      }
    });
    
    on<UpdateUserProfile>((event, emit) async {
      log("UpdateUserProfile event received");
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

        log("Update successful, fetching updated profile");
        // After successful update, fetch the updated profile
        final updatedUser = await userService.getUserProfile(event.token);
        log("Updated user fetched: ${updatedUser.fullName}");
        emit(UserUpdated(updatedUser, result['message'] ?? 'Profile updated successfully'));
      } catch (e) {
        log("Update Details Error: $e");
        debugPrint("Update Details Error : $e");
        emit(UserError(e.toString()));
      }
    });
  }
}
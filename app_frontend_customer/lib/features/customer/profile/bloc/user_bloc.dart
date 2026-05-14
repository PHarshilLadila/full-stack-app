import 'dart:developer';
import 'package:app_frontend_customer/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend_customer/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend_customer/features/customer/profile/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          imageFile: event.imageFile,
        );

        log("Update successful, fetching updated profile");
        final updatedUser = await userService.getUserProfile(event.token);
        log("Updated user fetched: ${updatedUser.fullName}");
        emit(
          UserUpdated(
            updatedUser,
            result['message'] ?? 'Profile updated successfully',
          ),
        );
      } catch (e) {
        log("Update Details Error: $e");
        debugPrint("Update Details Error : $e");
        emit(UserError(e.toString()));
      }
    });

    on<LogoutUser>((event, emit) async {
      log("LogoutUser event received");
      emit(UserLoggingOut());

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        if (token != null && token.isNotEmpty) {
          final result = await userService.logout(token);
          log("Logout API response: $result");
        }

        await prefs.clear();
        log("User logged out successfully");
        emit(UserLoggedOut());
      } catch (e) {
        log("Logout Error in Bloc: $e");
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        emit(UserLogoutError(e.toString()));
      }
    });
  }
}

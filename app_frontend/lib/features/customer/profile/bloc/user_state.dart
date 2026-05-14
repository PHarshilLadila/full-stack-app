// lib/features/user/bloc/user_state.dart

import '../model/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserUpdating extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}

class UserUpdated extends UserState {
  final UserModel user;
  final String message;
  UserUpdated(this.user, this.message);
}

class UserLoggingOut extends UserState {}

class UserLoggedOut extends UserState {}

class UserLogoutError extends UserState {
  final String error;
  UserLogoutError(this.error);
}
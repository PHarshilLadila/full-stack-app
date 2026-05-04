// lib/features/user/bloc/user_bloc.dart

import 'package:app_frontend/features/home/bloc/user_event.dart';
import 'package:app_frontend/features/home/bloc/user_state.dart';
import 'package:app_frontend/features/home/service/user_service.dart';
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
        emit(UserError(e.toString()));
      }
    });
  }
}

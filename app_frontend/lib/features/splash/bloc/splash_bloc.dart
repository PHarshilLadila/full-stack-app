import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event,
      Emitter<SplashState> emit) async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2)); // simulate delay

    // 🔥 Replace with real auth logic
    bool isLoggedIn = false;

    if (isLoggedIn) {
      emit(SplashAuthenticated());
    } else {
      emit(SplashUnauthenticated());
    }
  }
}
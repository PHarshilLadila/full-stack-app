abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashApiSuccess extends SplashState {
  final String message;
  SplashApiSuccess(this.message);
}

class SplashApiError extends SplashState {
  final String error;
  SplashApiError(this.error);
}

class Authenticated extends SplashState {
  final String? role;
  Authenticated({this.role});
}

class Unauthenticated extends SplashState {}
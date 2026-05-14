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
  final String token;
  final String? userId;
  final String userRole;
  final String? userName;
  
  Authenticated({
    required this.token,
    this.userId,
    required this.userRole,
    this.userName,
  });
}

class Unauthenticated extends SplashState {}
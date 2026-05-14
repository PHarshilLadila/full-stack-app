abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

class AuthSuccess extends AuthState {
  final String message;
  final String? token;
  final String? role;
  final String? userId;
  final bool isRegistration;
  
  AuthSuccess(
    this.message, {
    this.token,
    this.role,
    this.userId,
    this.isRegistration = false,
  });
}
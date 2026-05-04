abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final String? token;
  AuthSuccess(this.message, {this.token});
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

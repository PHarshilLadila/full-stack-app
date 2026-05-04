// lib/features/user/bloc/user_event.dart

abstract class UserEvent {}

class FetchUserProfile extends UserEvent {
  final String token;
  FetchUserProfile(this.token);
}
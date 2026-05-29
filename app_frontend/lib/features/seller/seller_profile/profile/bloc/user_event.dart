// lib/features/user/bloc/user_event.dart

abstract class UserEvent {}

class FetchUserProfile extends UserEvent {
  final String token;
  FetchUserProfile(this.token);
}

class UpdateUserProfile extends UserEvent {
  final String token;
  final String fullName;
  final String username;
  final String email;
  final String mobile;
  final String? profileImage;
  
  UpdateUserProfile({
    required this.token,
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
    this.profileImage,
  });
}
class LogoutUser extends UserEvent {}

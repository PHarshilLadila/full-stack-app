import 'dart:io';

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
  final File? imageFile;

  UpdateUserProfile({
    required this.token,
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
    this.imageFile,
  });
}

class LogoutUser extends UserEvent {}

// lib/features/user/model/user_model.dart

class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String mobile;
  final String createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
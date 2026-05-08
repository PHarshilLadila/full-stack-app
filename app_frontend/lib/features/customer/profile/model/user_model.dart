// lib/features/user/model/user_model.dart

class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String mobile;
  final String createdAt;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.createdAt,
    required this.profileImage,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
    );
  }
}

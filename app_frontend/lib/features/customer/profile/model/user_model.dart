class UserModel {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String mobile;
  final String createdAt;
  final String? profileImage;
  final String role; // Add role field

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.createdAt,
    required this.profileImage,
    required this.role, // Add role parameter
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
      role: json['role']?.toString() ?? 'customer', // Get role from response
    );
  }
}
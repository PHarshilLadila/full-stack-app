class LoginModel {
  final String identifier;
  final String password;

  LoginModel({required this.identifier, required this.password});

  Map<String, dynamic> toJson() {
    return {"identifier": identifier, "password": password};
  }
}

class LoginResponseModel {
  final String message;
  final String token;
  final String role;
  final String userId;
  final UserData? user;

  LoginResponseModel({
    required this.message, 
    required this.token, 
    required this.role,
    required this.userId,
    this.user
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      role: json['role'] ?? 'customer',
      userId: json['userId'] ?? '',
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class UserData {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String mobile;
  final String role;

  UserData({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? 'customer',
    );
  }
}
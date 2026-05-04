// lib/features/auth/model/login_model.dart

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
  final UserData? user;

  LoginResponseModel({required this.message, required this.token, this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
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

  UserData({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}
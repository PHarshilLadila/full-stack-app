class RegisterModel {
  final String fullName;
  final String username;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  final String role;

  RegisterModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile, 
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "username": username,
      "email": email,
      "mobile": mobile,
      "password": password,
      "confirmPassword": confirmPassword,
      "role": role,
    };
  }
}
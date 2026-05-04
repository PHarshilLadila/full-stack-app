class RegisterModel {
  final String fullName;
  final String username;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;

  RegisterModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "username": username,
      "email": email,
      "mobile": mobile,
      "password": password,
      "confirmPassword": confirmPassword,
    };
  }
}
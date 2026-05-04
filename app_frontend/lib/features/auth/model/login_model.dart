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

  LoginResponseModel({required this.message, required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(message: json['message'], token: json['token']);
  }
}

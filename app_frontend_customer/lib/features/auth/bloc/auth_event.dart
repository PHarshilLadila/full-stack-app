 

import 'package:app_frontend_customer/features/auth/model/login_model.dart';
import 'package:app_frontend_customer/features/auth/model/register_model.dart';

abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final RegisterModel registerModel;

  RegisterEvent(this.registerModel);
}

class LoginEvent extends AuthEvent {
  final LoginModel loginModel;

  LoginEvent(this.loginModel);
}
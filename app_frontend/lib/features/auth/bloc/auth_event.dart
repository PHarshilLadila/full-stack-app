import 'package:app_frontend/features/auth/model/register_model.dart';

abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final RegisterModel registerModel;

  RegisterEvent(this.registerModel);
}

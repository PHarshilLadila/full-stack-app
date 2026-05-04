import 'package:validators/validators.dart';

bool isValidEmail(String email) => isEmail(email);

bool isValidUsername(String username) {
  return username.length >= 4 && !username.contains(' ');
}

bool isValidMobile(String mobile) {
  return RegExp(r'^[6-9]\d{9}$').hasMatch(mobile);
}
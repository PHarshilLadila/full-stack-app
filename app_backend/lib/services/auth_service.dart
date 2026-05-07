// ignore_for_file: public_member_api_docs

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_backend/config/env.dart';

class AuthService {
  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  static bool verifyPassword(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }

  static String generateToken(String id, String role) {
    final jwt = JWT({'id': id, 'role': role});

    return jwt.sign(
      SecretKey(Env.jwtSecret),
      expiresIn: const Duration(days: 7),
    );
  }
}

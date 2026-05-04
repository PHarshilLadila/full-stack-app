import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../config/env.dart';

class AuthService {
  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  static bool verifyPassword(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }

  static String generateToken(String id) {
    final jwt = JWT({'id': id});

    return jwt.sign(
      SecretKey(Env.jwtSecret),
      expiresIn: Duration(days: 7),
    );
  }
}
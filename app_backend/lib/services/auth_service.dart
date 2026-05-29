// // ignore_for_file: public_member_api_docs

// import 'package:bcrypt/bcrypt.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:my_backend/config/env.dart';

// class AuthService {
//   static String hashPassword(String password) {
//     return BCrypt.hashpw(password, BCrypt.gensalt());
//   }

//   static bool verifyPassword(String password, String hash) {
//     return BCrypt.checkpw(password, hash);
//   }

//   static String generateToken(String id, String role) {
//     final jwt = JWT({'id': id, 'role': role});

//     return jwt.sign(
//       SecretKey(Env.jwtSecret),
//       expiresIn: const Duration(days: 7),
//     );
//   }
// }

// services/auth_service.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_backend/config/env.dart';

class AuthService {
  // Hash password using SHA-256 (consistent with reset service)
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Verify password using SHA-256
  static bool verifyPassword(String plainPassword, String hashedPassword) {
    final hashedInput = hashPassword(plainPassword);
    final result = hashedInput == hashedPassword;
    print('Password verification - Plain: $plainPassword');
    print('Hashed input: $hashedInput');
    print('Stored hash: $hashedPassword');
    print('Match: $result');
    return result;
  }

  // Generate JWT token
  static String generateToken(String userId, String role) {
    final jwt = JWT({
      'id': userId,
      'role': role,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp':
          DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/
          1000,
    });

    return jwt.sign(SecretKey(Env.jwtSecret));
  }

  // Verify JWT token
  static Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
      return jwt.payload as Map<String, dynamic>;
    } catch (e) {
      print('❌ Token verification failed: $e');
      return null;
    }
  }
}

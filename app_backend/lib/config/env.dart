// ignore_for_file: public_member_api_docs

import 'package:dotenv/dotenv.dart';

class Env {
  static final env = DotEnv()..load();

  static String get mongoUrl => env['MONGO_URL'] ?? '';
  static String get jwtSecret => env['JWT_SECRET'] ?? '';
  static String get cloudinaryUrl => env['CLOUDINARY_URL'] ?? '';
  static String get stripeSecretKey => env['KEY'] ?? '';

  // Firebase getters - Add these if you want direct access
  static String get firebaseProjectId => env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseClientEmail => env['FIREBASE_CLIENT_EMAIL'] ?? '';
  static String get firebasePrivateKey => env['FIREBASE_PRIVATE_KEY'] ?? '';
}
 
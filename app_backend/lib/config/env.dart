// ignore_for_file: public_member_api_docs

import 'package:dotenv/dotenv.dart';

class Env {
  static final env = DotEnv()..load();

  static String get mongoUrl => env['MONGO_URL'] ?? '';
  static String get jwtSecret => env['JWT_SECRET'] ?? '';
  static String get cloudinaryUrl => env['CLOUDINARY_URL'] ?? '';
}

import 'package:dotenv/dotenv.dart';

class Env {
  static final env = DotEnv()..load();

  static String get mongoUrl => env['MONGO_URL'] ?? '';
  static String get jwtSecret => env['JWT_SECRET'] ?? '';
}
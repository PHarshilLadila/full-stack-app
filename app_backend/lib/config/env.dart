// // ignore_for_file: public_member_api_docs

// import 'package:dotenv/dotenv.dart';

// class Env {
//   static final env = DotEnv()..load();

//   static String get mongoUrl => env['MONGO_URL'] ?? '';
//   static String get jwtSecret => env['JWT_SECRET'] ?? '';
// }

import 'dart:io';

class Env {
  static String get mongoUrl => Platform.environment['MONGO_URL'] ?? '';
  static String get jwtSecret => Platform.environment['JWT_SECRET'] ?? '';
}

// MONGO_URL=mongodb+srv://harshilgajiparaladila_db_user:Gajipara%4096@usercluster.4cpa4pd.mongodb.net/mydb?retryWrites=true&w=majority
// JWT_SECRET=Qvvt5vAUuNmdaebL3sakv15rSqu5XJpYOuMobvqwGbs=

// ignore_for_file: avoid_print, public_member_api_docs

import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';

class MongoService {
  static Db? db;
  static DbCollection? users;

  static bool isConnected = false;

  static Future<void> connect() async {
    if (isConnected) return;

    try {
      print('Connecting Mongo...');

      db = await Db.create(Env.mongoUrl);
      await db!.open(secure: true);

      users = db!.collection('users');

      isConnected = true;

      print('✅ MongoDB Connected');
    } catch (e) {
      print('❌ Mongo Error: $e');
    }
  }
}

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/config/firebase.dart';
import 'package:my_backend/db/mongo.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  print('🚀 Starting server initialization...');

  try {
    final connected = await MongoService.init();
    if (connected) {
      print('✅ MongoDB initialized successfully');
    } else {
      print('⚠️ MongoDB initialization failed');
    }
  } catch (e) {
    print('❌ Unexpected error during MongoDB init: $e');
  }

  await FirebaseConfig.init();
  // NotificationService doesn't need initialize() method

  print('🎯 Starting HTTP server on port $port...');
  return serve(handler, ip, port);
}

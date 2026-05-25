import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/config/firebase.dart';
import 'package:my_backend/db/mongo.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  // Initialize MongoDB BEFORE the server starts accepting requests
  print('🚀 Starting server initialization...');
  
  try {
    final connected = await MongoService.init();
    if (connected) {
      print('✅ MongoDB initialized successfully');
    } else {
      print('⚠️ MongoDB initialization failed - server will start but DB features may not work');
    }
  } catch (e) {
    print('❌ Unexpected error during MongoDB init: $e');
  }
    await FirebaseConfig.init();
  
  print('🎯 Starting HTTP server on port $port...');
  return serve(handler, ip, port);
}
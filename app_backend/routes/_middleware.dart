// ignore_for_file: avoid_print

import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/db/mongo.dart';

Handler middleware(Handler handler) {
  return (context) async {
    print('🔥 Middleware hit');

    await MongoService.connect();

    return handler(context);
  };
}

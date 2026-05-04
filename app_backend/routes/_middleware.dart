import 'package:dart_frog/dart_frog.dart';
import '../lib/db/mongo.dart';

Handler middleware(Handler handler) {
  return (context) async {
    print("🔥 Middleware hit");

    await MongoService.connect();

    return handler(context);
  };
}

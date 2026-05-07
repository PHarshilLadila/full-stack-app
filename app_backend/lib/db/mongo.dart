// ignore_for_file: avoid_print, public_member_api_docs

import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';

class MongoService {
  static Db? _db;
  static DbCollection? _users;
  static DbCollection? _products;

  static bool _isConnecting = false;
  static bool isConnected = false;

  static DbCollection? get users => _users;
  static DbCollection? get products => _products;

  static Future<void> connect() async {
    // If already connected and db exists, return
    if (isConnected && _db != null) {
      print('✅ Already connected to MongoDB');
      return;
    }

    // If currently connecting, wait to avoid multiple connections
    if (_isConnecting) {
      print('⏳ Connection already in progress, waiting...');
      // Wait a bit for connection to complete
      await Future.delayed(Duration(milliseconds: 500));
      if (isConnected) return;
      _isConnecting = false; // Reset if still not connected
    }

    _isConnecting = true;

    try {
      print('Connecting to MongoDB...');

      final mongoUrl = Env.mongoUrl;
      if (mongoUrl.isEmpty) {
        throw Exception('MongoDB URL is empty. Please check .env file');
      }

      // Create DB connection
      _db = await Db.create(mongoUrl);

      // Open connection (with timeout using Future.timeout)
      await _db!
          .open(secure: true)
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              throw Exception('MongoDB connection timeout after 30 seconds');
            },
          );

      // Initialize collections
      _users = _db!.collection('users');
      _products = _db!.collection('products');

      // Create indexes (use try-catch for each to avoid failure if index exists)
      try {
        await _products!.createIndex(keys: {'productName': 'text'});
        print('✅ Text index created');
      } catch (indexError) {
        print('⚠️ Text index warning: $indexError');
      }

      try {
        await _products!.createIndex(keys: {'category': 1});
        await _products!.createIndex(keys: {'sellerId': 1});
        await _products!.createIndex(keys: {'price': 1});
        await _products!.createIndex(keys: {'tags': 1});
        print('✅ Regular indexes created');
      } catch (indexError) {
        print('⚠️ Index creation warning: $indexError');
      }

      isConnected = true;
      print('✅ MongoDB Connected Successfully');
    } catch (e) {
      print('❌ MongoDB Connection Error: $e');
      print('❌ URL: ${_maskUrl(Env.mongoUrl)}');
      isConnected = false;
      _db = null;
      _users = null;
      _products = null;
      // Don't rethrow - let the app continue
    } finally {
      _isConnecting = false;
    }
  }

  static Future<void> disconnect() async {
    if (_db != null) {
      try {
        await _db!.close();
        print('MongoDB disconnected');
      } catch (e) {
        print('Error disconnecting: $e');
      }
      isConnected = false;
      _db = null;
      _users = null;
      _products = null;
    }
  }

  static String _maskUrl(String url) {
    try {
      // Just show the first part of the URL for debugging
      if (url.contains('@')) {
        final parts = url.split('@');
        if (parts.length > 1) {
          return '${parts[0].substring(0, parts[0].indexOf('://') + 3)}***@${parts[1]}';
        }
      }
    } catch (_) {}
    return url.length > 50 ? '${url.substring(0, 50)}...' : url;
  }
}

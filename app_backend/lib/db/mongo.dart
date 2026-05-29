// // ignore_for_file: avoid_print, public_member_api_docs, inference_failure_on_instance_creation, avoid_redundant_argument_values, lines_longer_than_80_chars

// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:my_backend/config/env.dart';

// class MongoService {
//   static Db? _db;
//   static DbCollection? _users;
//   static DbCollection? _products;
//   static DbCollection? _reviews;
//   static DbCollection? _addresses;
//   static DbCollection? _carts;
//   static DbCollection? _favorites;
//   static DbCollection? _orders;

//   static bool _isConnecting = false;
//   static bool isConnected = false;

//   static DbCollection? get users => _users;
//   static DbCollection? get products => _products;
//   static DbCollection? get reviews => _reviews;
//   static DbCollection? get addresses => _addresses;
//   static DbCollection? get carts => _carts;
//   static DbCollection? get favorites => _favorites;
//   static DbCollection? get orders => _orders;

//   static Future<void> connect() async {
//     // If already connected and db exists, return
//     if (isConnected && _db != null) {
//       print('✅ Already connected to MongoDB');
//       return;
//     }

//     // If currently connecting, wait to avoid multiple connections
//     if (_isConnecting) {
//       print('⏳ Connection already in progress, waiting...');
//       // Wait a bit for connection to complete
//       await Future.delayed(const Duration(milliseconds: 500));
//       if (isConnected) return;
//       _isConnecting = false; // Reset if still not connected
//     }

//     _isConnecting = true;

//     try {
//       print('Connecting to MongoDB...');

//       final mongoUrl = Env.mongoUrl;
//       if (mongoUrl.isEmpty) {
//         throw Exception('MongoDB URL is empty. Please check .env file');
//       }

//       // Create DB connection
//       _db = await Db.create(mongoUrl);

//       // Open connection (with timeout using Future.timeout)
//       await _db!
//           .open(secure: true)
//           .timeout(
//             const Duration(seconds: 30),
//             onTimeout: () {
//               throw Exception('MongoDB connection timeout after 30 seconds');
//             },
//           );

//       // Initialize collections
//       _users = _db!.collection('users');
//       _products = _db!.collection('products');
//       _reviews = _db!.collection('reviews');
//       _addresses = _db!.collection('addresses');
//       _carts = _db!.collection('carts');
//       _favorites = _db!.collection('favorites');
//       _orders = _db!.collection('orders');

//       // Create indexes (use try-catch for each to avoid failure if index exists),
//       try {
//         await _products!.createIndex(keys: {'productName': 'text'});
//         print('✅ Text index created');
//       } catch (indexError) {
//         print('⚠️ Text index warning: $indexError');
//       }

//       try {
//         await _products!.createIndex(keys: {'category': 1});
//         await _products!.createIndex(keys: {'sellerId': 1});
//         await _products!.createIndex(keys: {'price': 1});
//         await _products!.createIndex(keys: {'tags': 1});
//         print('✅ Regular indexes created');
//       } catch (indexError) {
//         print('⚠️ Index creation warning: $indexError');
//       }

//       try {
//         await _reviews!.createIndex(keys: {'productId': 1});
//         await _reviews!.createIndex(keys: {'userId': 1});
//         await _reviews!.createIndex(keys: {'rating': 1});
//         await _reviews!.createIndex(keys: {'createdAt': -1});
//         print('✅ Review indexes created');
//       } catch (indexError) {
//         print('⚠️ Review index creation warning: $indexError');
//       }
//       try {
//         await _addresses!.createIndex(keys: {'userId': 1});
//         await _addresses!.createIndex(keys: {'isDefault': 1});

//         await _carts!.createIndex(keys: {'userId': 1});

//         await _favorites!.createIndex(keys: {'userId': 1});
//         await _favorites!.createIndex(keys: {'productId': 1});
//         await _favorites!.createIndex(keys: {'userId': 1, 'productId': 1});

//         await _orders!.createIndex(keys: {'orderId': 1});
//         await _orders!.createIndex(keys: {'userId': 1});
//         await _orders!.createIndex(keys: {'sellerId': 1});
//         await _orders!.createIndex(keys: {'orderStatus': 1});
//         await _orders!.createIndex(keys: {'createdAt': -1});
//         print('✅ Additional indexes created');
//       } catch (indexError) {
//         print('⚠️ Additional index creation warning: $indexError');
//       }

//       isConnected = true;
//       print('✅ MongoDB Connected Successfully');
//     } catch (e) {
//       print('❌ MongoDB Connection Error: $e');
//       print('❌ URL: ${_maskUrl(Env.mongoUrl)}');
//       isConnected = false;
//       _db = null;
//       _users = null;
//       _products = null;
//       // Don't rethrow - let the app continue
//     } finally {
//       _isConnecting = false;
//     }
//   }

//   static Future<void> disconnect() async {
//     if (_db != null) {
//       try {
//         await _db!.close();
//         print('MongoDB disconnected');
//       } catch (e) {
//         print('Error disconnecting: $e');
//       }
//       isConnected = false;
//       _db = null;
//       _users = null;
//       _products = null;
//     }
//   }

//   static String _maskUrl(String url) {
//     try {
//       // Just show the first part of the URL for debugging
//       if (url.contains('@')) {
//         final parts = url.split('@');
//         if (parts.length > 1) {
//           return '${parts[0].substring(0, parts[0].indexOf('://') + 3)}***@${parts[1]}';
//         }
//       }
//     } catch (_) {}
//     return url.length > 50 ? '${url.substring(0, 50)}...' : url;
//   }
// }
// ignore_for_file: avoid_print

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';

class MongoService {
  static Db? _db;
  static DbCollection? _users;
  static DbCollection? _products;
  static DbCollection? _reviews;
  static DbCollection? _addresses;
  static DbCollection? _carts;
  static DbCollection? _favorites;
  static DbCollection? _orders;
  static DbCollection? _notifications;
  static DbCollection? _payments;
  static DbCollection? _passwordResets;

  static Timer? _keepAliveTimer;
  static bool _isConnected = false;
  static Completer<bool>? _connectionCompleter;

  static DbCollection? get users => _users;
  static DbCollection? get products => _products;
  static DbCollection? get reviews => _reviews;
  static DbCollection? get addresses => _addresses;
  static DbCollection? get carts => _carts;
  static DbCollection? get favorites => _favorites;
  static DbCollection? get orders => _orders;
  static DbCollection? get notifications => _notifications;
  static DbCollection? get payments => _payments;
  static DbCollection? get passwordResets => _passwordResets;

  /// Initialize connection (call once at startup)
  static Future<bool> init() async {
    // If already connected and alive, return true
    if (_isConnected && _db != null) {
      if (await _isAlive()) {
        print('✅ MongoDB already connected');
        return true;
      } else {
        print('⚠️ Connection exists but dead, reconnecting...');
        await _close();
      }
    }

    // If connection is in progress, wait for it
    if (_connectionCompleter != null) {
      print('⏳ Waiting for ongoing connection...');
      return _connectionCompleter!.future;
    }

    // Start new connection
    _connectionCompleter = Completer<bool>();

    try {
      await _connect();
      _connectionCompleter!.complete(true);
      return true;
    } catch (e) {
      _connectionCompleter!.complete(false);
      return false;
    } finally {
      _connectionCompleter = null;
    }
  }

  /// Ensure connection is ready (called by middleware)
  static Future<bool> ensureConnection() async {
    // Fast path: already connected
    if (_isConnected && _db != null) {
      return true;
    }

    // Slow path: need to connect
    return await init();
  }

  /// Actual connection logic
  static Future<void> _connect() async {
    print('🔄 Establishing MongoDB connection...');

    final mongoUrl = Env.mongoUrl;
    if (mongoUrl.isEmpty) {
      throw Exception('MongoDB URL is empty');
    }

    try {
      // Build connection URL with proper parameters
      String finalUrl = mongoUrl;
      if (!mongoUrl.contains('safeAtlas')) {
        final separator = mongoUrl.contains('?') ? '&' : '?';
        finalUrl =
            '$mongoUrl${separator}safeAtlas=true&retryWrites=true&retryReads=true';
      }

      // Create and open connection with timeout
      _db = await Db.create(finalUrl);

      // Add timeout to open operation
      await _db!.open().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Connection timeout after 30 seconds'),
      );

      // Test connection with ping
      final pingResult = await _db!
          .runCommand({'ping': 1})
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw Exception('Ping timeout'),
          );

      if (pingResult['ok'] != 1.0) {
        throw Exception('Ping failed: $pingResult');
      }

      // Initialize collections
      _users = _db!.collection('users');
      _products = _db!.collection('products');
      _reviews = _db!.collection('reviews');
      _addresses = _db!.collection('addresses');
      _carts = _db!.collection('carts');
      _favorites = _db!.collection('favorites');
      _orders = _db!.collection('orders');
      _notifications = _db!.collection('notifications');
      _payments = _db!.collection('payments');
      _passwordResets = _db!.collection('password_resets');

      // Create indexes in background (don't wait)
      _createIndexes().catchError((e) {
        print('⚠️ Index creation warning: ${e.toString().substring(0, 100)}');
      });

      // Start keep-alive
      _startKeepAlive();

      _isConnected = true;
      print('✅ MongoDB Connected Successfully');
    } catch (e) {
      print('❌ MongoDB Connection Error: $e');
      _isConnected = false;
      _db = null;
      rethrow;
    }
  }

  /// Check if connection is alive
  static Future<bool> _isAlive() async {
    if (_db == null) return false;

    try {
      final result = await _db!
          .runCommand({'ping': 1})
          .timeout(
            const Duration(seconds: 2),
            onTimeout: () => throw Exception('Timeout'),
          );
      return result['ok'] == 1.0;
    } catch (e) {
      return false;
    }
  }

  /// Keep connection alive
  static void _startKeepAlive() {
    _keepAliveTimer?.cancel();

    _keepAliveTimer = Timer.periodic(const Duration(seconds: 20), (
      timer,
    ) async {
      if (!_isConnected || _db == null) {
        timer.cancel();
        return;
      }

      try {
        await _db!.runCommand({'ping': 1}).timeout(const Duration(seconds: 5));
        // print('💓 Keep-alive ping successful');
      } catch (e) {
        print('⚠️ Keep-alive ping failed: $e');
        _isConnected = false;
        timer.cancel();
      }
    });
  }

  /// Close connection
  static Future<void> _close() async {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;

    if (_db != null) {
      try {
        await _db!.close();
      } catch (e) {
        // Ignore
      }
    }

    _db = null;
    _isConnected = false;
  }

  /// Create indexes safely
  static Future<void> _createIndexes() async {
    // Products
    await _safeCreateIndex(_products!, 'productName');
    await _safeCreateIndex(_products!, 'category');
    await _safeCreateIndex(_products!, 'sellerId');
    await _safeCreateIndex(_products!, 'price');
    await _safeCreateIndex(_products!, 'tags');

    // Reviews
    await _safeCreateIndex(_reviews!, 'productId');
    await _safeCreateIndex(_reviews!, 'userId');
    await _safeCreateIndex(_reviews!, 'rating');
    await _safeCreateIndex(_reviews!, 'createdAt');

    // Addresses
    await _safeCreateIndex(_addresses!, 'userId');
    await _safeCreateIndex(_addresses!, 'isDefault');

    // Carts
    await _safeCreateIndex(_carts!, 'userId');

    // Favorites
    await _safeCreateIndex(_favorites!, 'userId');
    await _safeCreateIndex(_favorites!, 'productId');

    // Orders
    await _safeCreateIndex(_orders!, 'orderId', unique: true);
    await _safeCreateIndex(_orders!, 'userId');
    await _safeCreateIndex(_orders!, 'sellerId');
    await _safeCreateIndex(_orders!, 'orderStatus');
    await _safeCreateIndex(_orders!, 'createdAt');

    // Notifications indexes
    await _safeCreateIndex(_notifications!, 'userId');
    await _safeCreateIndex(_notifications!, 'notificationId', unique: true);
    await _safeCreateIndex(_notifications!, 'type');
    await _safeCreateIndex(_notifications!, 'createdAt');
    await _safeCreateIndex(_notifications!, 'isRead');

    // Payments
    await _safeCreateIndex(_payments!, 'paymentId', unique: true);
    await _safeCreateIndex(_payments!, 'orderId');
    await _safeCreateIndex(_payments!, 'userId');
    await _safeCreateIndex(_payments!, 'paymentStatus');

    // Password resets indexes
    await _safeCreateIndex(_passwordResets!, 'token', unique: true);
    await _safeCreateIndex(_passwordResets!, 'userId');
    await _safeCreateIndex(_passwordResets!, 'expiresAt');
    await _safeCreateIndex(_passwordResets!, 'isUsed');

    print('✅ All indexes verified');
  }

  static Future<void> _safeCreateIndex(
    DbCollection collection,
    String field, {
    bool unique = false,
  }) async {
    try {
      await collection.createIndex(key: field, unique: unique);
    } catch (e) {
      // Ignore "already exists" errors
      if (!e.toString().contains('already exists')) {
        print('⚠️ Index error on $field: ${e.toString().substring(0, 80)}');
      }
    }
  }

  /// Clean shutdown
  static Future<void> close() async {
    await _close();
    print('MongoDB connection closed');
  }
}

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


// ignore_for_file: avoid_print, public_member_api_docs, inference_failure_on_instance_creation, avoid_redundant_argument_values, lines_longer_than_80_chars
// ignore_for_file: avoid_print, public_member_api_docs, inference_failure_on_instance_creation, avoid_redundant_argument_values, lines_longer_than_80_chars

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

  static bool _isConnecting = false;
  static bool isConnected = false;
  static DateTime? _lastSuccessfulPing;
  static Timer? _keepAliveTimer;

  static DbCollection? get users => _users;
  static DbCollection? get products => _products;
  static DbCollection? get reviews => _reviews;
  static DbCollection? get addresses => _addresses;
  static DbCollection? get carts => _carts;
  static DbCollection? get favorites => _favorites;
  static DbCollection? get orders => _orders;

  /// Check if the current connection is actually alive
  static Future<bool> _isConnectionAlive() async {
    if (_db == null || !isConnected) return false;
    
    try {
      // Use runCommand to ping the database
      final result = await _db!.runCommand({'ping': 1}).timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw Exception('Ping timeout'),
      );
      
      // Check if ping was successful (should return {ok: 1.0})
      final isOk = result['ok'] == 1.0;
      if (isOk) {
        _lastSuccessfulPing = DateTime.now();
      }
      return isOk;
    } catch (e) {
      print('⚠️ Connection health check failed: $e');
      return false;
    }
  }

  /// Force close and reset the connection
  static Future<void> _forceDisconnect() async {
    print('🔄 Force disconnecting dead connection...');
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    
    try {
      if (_db != null) {
        await _db!.close();
      }
    } catch (e) {
      // Ignore errors during force disconnect
      print('Error during force disconnect: $e');
    } finally {
      _db = null;
      _users = null;
      _products = null;
      _reviews = null;
      _addresses = null;
      _carts = null;
      _favorites = null;
      _orders = null;
      isConnected = false;
      _isConnecting = false;
      _lastSuccessfulPing = null;
    }
  }

  static Future<void> connect() async {
    // If we have a connection, check if it's still alive
    if (isConnected && _db != null) {
      // Check if connection is actually alive
      final isAlive = await _isConnectionAlive();
      
      if (isAlive) {
        print('✅ Already connected to MongoDB');
        return;
      } else {
        print('⚠️ Existing connection is dead, reconnecting...');
        await _forceDisconnect();
      }
    }

    // If currently connecting, wait to avoid multiple connections
    if (_isConnecting) {
      print('⏳ Connection already in progress, waiting...');
      int waitCount = 0;
      while (_isConnecting && waitCount < 30) {
        await Future.delayed(const Duration(milliseconds: 100));
        waitCount++;
      }
      if (isConnected && _db != null) {
        // Verify the connection is actually good
        final isAlive = await _isConnectionAlive();
        if (isAlive) return;
      }
      // If we get here, either timeout or connection is dead
      _isConnecting = false;
    }

    _isConnecting = true;

    try {
      print('Connecting to MongoDB...');

      final mongoUrl = Env.mongoUrl;
      if (mongoUrl.isEmpty) {
        throw Exception('MongoDB URL is empty. Please check .env file');
      }

      // Add connection pool settings and keep-alive to prevent disconnection
      String modifiedUrl = mongoUrl;
      
      // Add connection parameters for better reliability with Atlas free tier
      if (!mongoUrl.contains('maxPoolSize')) {
        final separator = mongoUrl.contains('?') ? '&' : '?';
        modifiedUrl = '$mongoUrl${separator}maxPoolSize=5&minPoolSize=1&maxIdleTimeMS=60000&heartbeatFrequencyMS=10000';
        print('🔌 Added connection pool parameters');
      }
      
      // Create DB connection
      _db = await Db.create(modifiedUrl);

      // Open connection with proper options
      await _db!.open();
      
      // Test the connection immediately with runCommand
      final pingResult = await _db!.runCommand({'ping': 1});
      if (pingResult['ok'] != 1.0) {
        throw Exception('Ping failed: $pingResult');
      }
      
      _lastSuccessfulPing = DateTime.now();

      // Initialize collections
      _users = _db!.collection('users');
      _products = _db!.collection('products');
      _reviews = _db!.collection('reviews');
      _addresses = _db!.collection('addresses');
      _carts = _db!.collection('carts');
      _favorites = _db!.collection('favorites');
      _orders = _db!.collection('orders');

      // Create indexes (ignore duplicate errors by catching them)
      await _createIndexes();

      isConnected = true;
      print('✅ MongoDB Connected Successfully');
      
      // Start background keep-alive pinger
      _startKeepAlivePinger();
      
    } catch (e) {
      print('❌ MongoDB Connection Error: $e');
      print('❌ URL: ${_maskUrl(Env.mongoUrl)}');
      isConnected = false;
      _db = null;
      // Don't rethrow - let the app continue
    } finally {
      _isConnecting = false;
    }
  }

  static Future<void> _createIndexes() async {
    // Create indexes with try-catch for each to prevent failures
    try {
      await _products!.createIndex(key: 'productName', unique: false);
      print('✅ Text index created');
    } catch (indexError) {
      print('⚠️ Text index warning: $indexError');
    }

    try {
      await _products!.createIndex(key: 'category', unique: false);
      await _products!.createIndex(key: 'sellerId', unique: false);
      await _products!.createIndex(key: 'price', unique: false);
      await _products!.createIndex(key: 'tags', unique: false);
      print('✅ Regular indexes created');
    } catch (indexError) {
      print('⚠️ Index creation warning: $indexError');
    }

    try {
      await _reviews!.createIndex(key: 'productId', unique: false);
      await _reviews!.createIndex(key: 'userId', unique: false);
      await _reviews!.createIndex(key: 'rating', unique: false);
      await _reviews!.createIndex(key: 'createdAt', unique: false);
      print('✅ Review indexes created');
    } catch (indexError) {
      print('⚠️ Review index creation warning: $indexError');
    }
    
    try {
      await _addresses!.createIndex(key: 'userId', unique: false);
      await _addresses!.createIndex(key: 'isDefault', unique: false);

      await _carts!.createIndex(key: 'userId', unique: false);

      await _favorites!.createIndex(key: 'userId', unique: false);
      await _favorites!.createIndex(key: 'productId', unique: false);
      
      // Composite unique index to prevent duplicate favorites
      try {
        await _favorites!.createIndex(
          keys: {'userId': 1, 'productId': 1}, 
          unique: true,
        );
      } catch (e) {
        print('⚠️ Favorites composite index warning: $e');
      }

      await _orders!.createIndex(key: 'orderId', unique: true);
      await _orders!.createIndex(key: 'userId', unique: false);
      await _orders!.createIndex(key: 'sellerId', unique: false);
      await _orders!.createIndex(key: 'orderStatus', unique: false);
      await _orders!.createIndex(key: 'createdAt', unique: false);
      print('✅ Additional indexes created');
    } catch (indexError) {
      print('⚠️ Additional index creation warning: $indexError');
    }
  }

  static void _startKeepAlivePinger() {
    // Cancel existing timer if any
    _keepAliveTimer?.cancel();
    
    // Send a ping every 20 seconds to keep the connection alive
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (!isConnected || _db == null) {
        timer.cancel();
        _keepAliveTimer = null;
        return;
      }
      
      try {
        final result = await _db!.runCommand({'ping': 1}).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw Exception('Ping timeout'),
        );
        
        if (result['ok'] == 1.0) {
          _lastSuccessfulPing = DateTime.now();
          // Optional: print('.',); // Uncomment for debugging
        } else {
          throw Exception('Ping failed: $result');
        }
      } catch (e) {
        print('⚠️ Keep-alive ping failed: $e');
        // Mark connection as potentially dead
        isConnected = false;
        timer.cancel();
        _keepAliveTimer = null;
      }
    });
  }

  /// Get a guaranteed fresh connection for critical operations
  static Future<Db> getFreshConnection() async {
    // If current connection is dead, force reconnect
    if (!await _isConnectionAlive()) {
      await _forceDisconnect();
      await connect();
    }
    
    if (_db == null || !isConnected) {
      await connect();
    }
    
    if (_db == null) {
      throw Exception('Failed to establish MongoDB connection');
    }
    
    return _db!;
  }

  static Future<void> disconnect() async {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    
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
      _reviews = null;
      _addresses = null;
      _carts = null;
      _favorites = null;
      _orders = null;
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
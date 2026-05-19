// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

/// GET /favorites/list
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /favorites/list API HIT');

  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'success': false, 'message': 'Token missing'},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    final userId = jwt.payload['id'].toString();

    final page =
        int.tryParse(context.request.uri.queryParameters['page'] ?? '1') ?? 1;
    final limit =
        int.tryParse(context.request.uri.queryParameters['limit'] ?? '20') ??
        20;
    final skip = (page - 1) * limit;

    final totalCount = await MongoService.favorites!.count({'userId': userId});

    // Get all favorites first
    final allFavorites =
        await MongoService.favorites!.find({'userId': userId}).toList();

    // Sort manually (newest first)
    allFavorites.sort((a, b) {
      final aDate = a['createdAt'] as DateTime;
      final bDate = b['createdAt'] as DateTime;
      return bDate.compareTo(aDate);
    });

    // Apply pagination
    final favorites = allFavorites.skip(skip).take(limit).toList();

    final transformedFavorites =
        favorites.map((fav) {
          return {
            '_id': (fav['_id'] as ObjectId).oid,
            'productId': fav['productId']?.toString() ?? '',
            'productName': fav['productName']?.toString() ?? '',
            'productImage': fav['productImage']?.toString() ?? '',
            'price': (fav['price'] as num?)?.toDouble() ?? 0.0,
            'discountPrice':
                fav['discountPrice'] != null
                    ? (fav['discountPrice'] as num).toDouble()
                    : null,
            'sellerId': fav['sellerId']?.toString() ?? '',
            'sellerName': fav['sellerName']?.toString() ?? '',
            'rating': (fav['rating'] as num?)?.toDouble() ?? 0.0,
            'createdAt':
                fav['createdAt'] is DateTime
                    ? (fav['createdAt'] as DateTime).toIso8601String()
                    : null,
          };
        }).toList();

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Favorites fetched successfully',
        'data': transformedFavorites,
        'pagination': {
          'currentPage': page,
          'totalPages': totalCount > 0 ? (totalCount / limit).ceil() : 0,
          'totalItems': totalCount,
          'itemsPerPage': limit,
        },
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: $e'},
    );
  }
}

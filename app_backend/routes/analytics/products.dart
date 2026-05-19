// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/analytics_service.dart';

/// GET /analytics/products
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /analytics/products API HIT');

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
    final userRole = jwt.payload['role']?.toString() ?? 'customer';

    if (userRole != 'seller') {
      return Response.json(
        statusCode: 403,
        body: {'success': false, 'message': 'Only sellers can view analytics'},
      );
    }

    final queryParams = context.request.uri.queryParameters;
    final sortBy =
        queryParams['sortBy'] ?? 'totalSold'; // totalSold, rating, revenue
    final limit = int.tryParse(queryParams['limit'] ?? '50') ?? 50;

    final analytics = AnalyticsService(sellerId: userId);

    final productPerformance = await analytics.getProductPerformance();

    // Sort products
    List<Map<String, dynamic>> sortedProducts = List.from(productPerformance);
    switch (sortBy) {
      case 'totalSold':
        sortedProducts.sort(
          (a, b) => (b['totalSold'] as int).compareTo(a['totalSold'] as int),
        );
        break;
      case 'rating':
        sortedProducts.sort(
          (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
        );
        break;
      case 'revenue':
        sortedProducts.sort(
          (a, b) => (b['totalRevenue'] as double).compareTo(
            a['totalRevenue'] as double,
          ),
        );
        break;
      case 'views':
        sortedProducts.sort(
          (a, b) => (b['totalViews'] as int).compareTo(a['totalViews'] as int),
        );
        break;
    }

    final topProducts = sortedProducts.take(limit).toList();
    final topProductsData = await analytics.getTopProducts();

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Product analytics fetched successfully',
        'data': {
          'bestSelling': topProductsData['bestSelling'],
          'topRated': topProductsData['topRated'],
          'mostViewed': topProductsData['mostViewed'],
          'lowStock': topProductsData['lowStock'],
          'outOfStock': topProductsData['outOfStock'],
          'allProducts': topProducts,
          'summary': {
            'totalProducts': productPerformance.length,
            'lowStockCount': topProductsData['lowStock']?.length ?? 0,
            'outOfStockCount': topProductsData['outOfStock']?.length ?? 0,
          },
        },
      },
    );
  } catch (e, stackTrace) {
    print('❌ ERROR: $e');
    print('Stack trace: $stackTrace');
    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: ${e.toString()}'},
    );
  }
}

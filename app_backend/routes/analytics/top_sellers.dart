// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/db/mongo.dart';

/// GET /analytics/top-sellers?limit=5
///
/// Returns top sellers with their best selling product details
/// Public API - No token required
Future<Response> onRequest(RequestContext context) async {
  print('🔥 /analytics/top-sellers API HIT');

  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  try {
    final queryParams = context.request.uri.queryParameters;
    final limit = int.tryParse(queryParams['limit'] ?? '5') ?? 5;

    final sellersData = await _getTopSellersWithBestProducts(limit);

    if (sellersData.isEmpty) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'No sellers found with products'},
      );
    }

    final totalRevenue = sellersData.fold<double>(
      0,
      (sum, seller) => sum + (seller['sellerTotalRevenue'] as double? ?? 0),
    );

    final totalProducts = sellersData.fold<int>(
      0,
      (sum, seller) => sum + (seller['totalProducts'] as int? ?? 0),
    );

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Top sellers fetched successfully',
        'data': {
          'sellers': sellersData,
          'summary': {
            'totalSellers': sellersData.length,
            'totalRevenue': totalRevenue,
            'totalProducts': totalProducts,
            'averageRevenuePerSeller':
                totalRevenue /
                (sellersData.length > 0 ? sellersData.length : 1),
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

Future<List<Map<String, dynamic>>> _getTopSellersWithBestProducts(
  int limit,
) async {
  try {
    final productsCollection = MongoService.products;
    final ordersCollection = MongoService.orders;
    final usersCollection = MongoService.users;

    if (productsCollection == null ||
        ordersCollection == null ||
        usersCollection == null) {
      return [];
    }

    final allSellers = await usersCollection.find({'role': 'seller'}).toList();

    if (allSellers.isEmpty) {
      return [];
    }

    final sellerPerformance = <Map<String, dynamic>>[];

    for (final seller in allSellers) {
      final sellerId = (seller['_id'] as ObjectId).oid;
      final sellerName =
          seller['name']?.toString() ??
          seller['fullName']?.toString() ??
          'Unknown Seller';
      final sellerStoreName =
          seller['storeName']?.toString() ??
          seller['shopName']?.toString() ??
          '';
      final sellerProfileImage =
          seller['profileImage']?.toString() ??
          seller['avatar']?.toString() ??
          '';

      final sellerProducts =
          await productsCollection.find({'sellerId': sellerId}).toList();

      if (sellerProducts.isEmpty) {
        continue;
      }

      final productPerformance = <Map<String, dynamic>>[];

      for (final product in sellerProducts) {
        final productId = (product['_id'] as ObjectId).oid;

        final productOrders =
            await ordersCollection.find({
              'items.productId': productId,
            }).toList();

        int totalSold = 0;
        double totalRevenue = 0.0;
        int totalOrders = 0;

        for (final order in productOrders) {
          final items = order['items'] as List? ?? [];

          for (final item in items) {
            final itemProductId = item['productId']?.toString();
            if (itemProductId == productId) {
              totalSold += item['quantity'] as int? ?? 1;
              totalRevenue += (item['totalPrice'] as num?)?.toDouble() ?? 0;
              totalOrders++;
            }
          }
        }

        productPerformance.add({
          'productId': productId,
          'productName':
              product['productName']?.toString() ?? 'Unknown Product',
          'productImage': product['mainBannerImage']?.toString() ?? '',
          'price': (product['price'] as num?)?.toDouble() ?? 0.0,
          'discountPrice': (product['discountPrice'] as num?)?.toDouble(),
          'discountPercentage':
              (product['discountPercentage'] as num?)?.toDouble() ?? 0.0,
          'stock': product['stock'] as int? ?? 0,
          'category': product['category']?.toString() ?? '',
          'rating': (product['rating'] as num?)?.toDouble() ?? 0.0,
          'totalReviews': product['totalReviews'] as int? ?? 0,
          'totalSold': totalSold,
          'totalRevenue': totalRevenue,
          'totalOrders': totalOrders,
          'colors':
              (product['colors'] as List?)?.map((e) => e.toString()).toList() ??
              [],
          'sizes':
              (product['sizes'] as List?)?.map((e) => e.toString()).toList() ??
              [],
          'description': product['description']?.toString() ?? '',
          'brand': product['brand']?.toString() ?? '',
          'isActive': product['isActive'] as bool? ?? true,
        });
      }

      productPerformance.sort(
        (a, b) => (b['totalSold'] as int).compareTo(a['totalSold'] as int),
      );

      final bestProduct =
          productPerformance.isNotEmpty ? productPerformance.first : null;

      final sellerTotalRevenue = productPerformance.fold<double>(
        0,
        (sum, p) => sum + (p['totalRevenue'] as double? ?? 0),
      );

      final sellerTotalSold = productPerformance.fold<int>(
        0,
        (sum, p) => sum + (p['totalSold'] as int? ?? 0),
      );

      sellerPerformance.add({
        'sellerId': sellerId,
        'sellerName': sellerName,
        'storeName': sellerStoreName,
        'storeLogo': sellerProfileImage,
        'totalProducts': sellerProducts.length,
        'sellerTotalRevenue': sellerTotalRevenue,
        'sellerTotalSold': sellerTotalSold,
        'bestProduct': bestProduct, // ✅ ONLY 1 BEST PRODUCT
      });
    }

    sellerPerformance.sort(
      (a, b) => (b['sellerTotalRevenue'] as double).compareTo(
        a['sellerTotalRevenue'] as double,
      ),
    );

    return sellerPerformance.take(limit).toList();
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

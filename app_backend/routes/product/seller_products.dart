// ignore_for_file: avoid_print, avoid_dynamic_calls, inference_failure_on_collection_literal

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/seller_products API HIT');

  /// AUTH HEADER
  final authHeader = context.request.headers['authorization'];

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'success': false, 'message': 'Token missing'},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    /// VERIFY JWT
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));

    final userId = jwt.payload['id'].toString();

    final userRole = jwt.payload['role']?.toString() ?? 'customer';

    /// SELLER CHECK
    if (userRole != 'seller') {
      return Response.json(
        statusCode: 403,
        body: {'success': false, 'message': 'Only sellers can view products'},
      );
    }

    /// PAGINATION
    final queryParams = context.request.uri.queryParameters;

    final page = int.tryParse(queryParams['page'] ?? '1') ?? 1;

    final limit = int.tryParse(queryParams['limit'] ?? '10') ?? 10;

    final skip = (page - 1) * limit;

    /// SERVER URL
    final baseUrl = 'http://192.168.1.10:8080';

    /// FILTER
    final filter = {'sellerId': userId};

    /// TOTAL COUNT
    final totalCount = await MongoService.products!.count(filter);

    /// PRODUCTS
    final allProducts = await MongoService.products!.find(filter).toList();

    final products = allProducts.skip(skip).take(limit).toList();

    /// TRANSFORM PRODUCTS
    final transformedProducts =
        products.map((product) {
          final transformed = Map<String, dynamic>.from(product);

          /// OBJECT ID
          transformed['_id'] = (product['_id'] as ObjectId).oid;

          /// DATE
          if (product['createdAt'] is DateTime) {
            transformed['createdAt'] =
                (product['createdAt'] as DateTime).toIso8601String();
          }

          if (product['updatedAt'] is DateTime) {
            transformed['updatedAt'] =
                (product['updatedAt'] as DateTime).toIso8601String();
          }

          /// MAIN IMAGE
          if (transformed['mainBannerImage'] != null) {
            final image = transformed['mainBannerImage'].toString();

            if (image.startsWith('/uploads')) {
              transformed['mainBannerImage'] = '$baseUrl$image';
            }
          }

          /// MULTIPLE IMAGES
          if (transformed['multipleImages'] is List &&
              transformed['multipleImages'] != null) {
            final images = List<String>.from(
              transformed['multipleImages'] as List,
            );

            transformed['multipleImages'] =
                images.map((image) {
                  if (image.startsWith('/uploads')) {
                    return '$baseUrl$image';
                  }

                  return image;
                }).toList();
          } else {
            transformed['multipleImages'] = [];
          }

          /// TAGS
          if (transformed['tags'] == null || transformed['tags'] is! List) {
            transformed['tags'] = [];
          }

          /// SPECIFICATIONS
          if (transformed['specifications'] == null ||
              transformed['specifications'] is! Map) {
            transformed['specifications'] = {};
          }

          return transformed;
        }).toList();

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Products fetched successfully',
        'data': transformedProducts,
        'pagination': {
          'currentPage': page,
          'totalPages': (totalCount / limit).ceil(),
          'totalItems': totalCount,
          'itemsPerPage': limit,
        },
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': e.toString()},
    );
  }
}

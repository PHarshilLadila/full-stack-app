// ignore_for_file: avoid_print, avoid_dynamic_calls, inference_failure_on_collection_literal

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/db/mongo.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/details API HIT');

  final productId =
      context.request.uri.queryParameters['id'];

  if (productId == null || productId.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {
        'success': false,
        'message': 'Product ID required',
      },
    );
  }

  try {
    /// FIND PRODUCT
    final product =
        await MongoService.products!.findOne({
      '_id': ObjectId.parse(productId),
      'isActive': true,
    });

    if (product == null) {
      return Response.json(
        statusCode: 404,
        body: {
          'success': false,
          'message': 'Product not found',
        },
      );
    }

    /// CONVERT MAP
    final transformed =
        Map<String, dynamic>.from(product);

    /// OBJECT ID
    transformed['_id'] =
        (product['_id'] as ObjectId).oid;

    /// DATE CONVERT
    if (product['createdAt'] is DateTime) {
      transformed['createdAt'] =
          (product['createdAt'] as DateTime)
              .toIso8601String();
    }

    if (product['updatedAt'] is DateTime) {
      transformed['updatedAt'] =
          (product['updatedAt'] as DateTime)
              .toIso8601String();
    }

    /// SERVER BASE URL
    ///
    /// CHANGE THIS
    final baseUrl =
        'http://192.168.1.10:8080';

    /// MAIN BANNER IMAGE
    if (transformed['mainBannerImage'] != null) {
      final image =
          transformed['mainBannerImage']
              .toString();

      /// IF LOCAL STORAGE IMAGE
      if (image.startsWith('/uploads')) {
        transformed['mainBannerImage'] =
            '$baseUrl$image';
      }
    }

    /// MULTIPLE IMAGES
    if (transformed['multipleImages'] != null &&
        transformed['multipleImages'] is List) {
      final images =
          List<String>.from(
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
    if (transformed['tags'] == null ||
        transformed['tags'] is! List) {
      transformed['tags'] = [];
    }

    /// SPECIFICATIONS
    if (transformed['specifications'] == null ||
        transformed['specifications'] is! Map) {
      transformed['specifications'] = {};
    }

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message':
            'Product details fetched successfully',
        'data': transformed,
      },
    );
  } catch (e) {
    print('❌ ERROR: $e');

    return Response.json(
      statusCode: 500,
      body: {
        'success': false,
        'message':
            'Failed to fetch product details',
        'error': e.toString(),
      },
    );
  }
}
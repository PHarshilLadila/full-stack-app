// ignore_for_file: avoid_print, avoid_dynamic_calls, unused_local_variable, inference_failure_on_collection_literal

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/list API HIT - View Products');

  // Optional authentication (customers can view without login)
  final authHeader = context.request.headers['authorization'];

  if (authHeader != null && authHeader.startsWith('Bearer ')) {
    try {
      final token = authHeader.split(' ')[1];
      JWT.verify(token, SecretKey(Env.jwtSecret));
    } catch (e) {
      // Token invalid but still allow as guest
      print('Invalid token, continuing as guest');
    }
  }

  // Get query parameters for filtering
  final queryParams = context.request.uri.queryParameters;
  final page = int.tryParse(queryParams['page'] ?? '1') ?? 1;
  final limit = int.tryParse(queryParams['limit'] ?? '20') ?? 20;
  final skip = (page - 1) * limit;
  
  final category = queryParams['category'];
  final subCategory = queryParams['subCategory'];
  final search = queryParams['search'];
  final minPrice = double.tryParse(queryParams['minPrice'] ?? '0');
  final maxPrice = double.tryParse(queryParams['maxPrice'] ?? '1000000');
  final sortBy = queryParams['sortBy'] ?? 'createdAt';
  final sortOrder = queryParams['sortOrder'] ?? 'desc';
  final tags = queryParams['tags']?.split(',');

  // Build filter using Map
  final Map<String, dynamic> filter = {
    'isActive': true,
    'stockAvailable': true,
    'stock': {r'$gt': 0},
  };

  // Apply filters
  if (category != null && category.isNotEmpty) {
    filter['category'] = category;
  }

  if (subCategory != null && subCategory.isNotEmpty) {
    filter['subCategory'] = subCategory;
  }

  // Handle price range
  if (minPrice != null || maxPrice != null) {
    final priceFilter = <String, dynamic>{};
    if (minPrice != null) {
      priceFilter[r'$gte'] = minPrice;
    }
    if (maxPrice != null) {
      priceFilter[r'$lte'] = maxPrice;
    }
    filter['price'] = priceFilter;
  }

  if (tags != null && tags.isNotEmpty) {
    filter['tags'] = {r'$all': tags};
  }

  if (search != null && search.isNotEmpty) {
    filter[r'$text'] = {r'$search': search};
  }

  // Build sort order
  final sortOrderValue = sortOrder == 'asc' ? 1 : -1;

  try {
    // Check if products collection exists
    if (MongoService.products == null) {
      return Response.json(
        statusCode: 500,
        body: {'error': 'Database not connected'},
      );
    }

    // Get total count
    final totalCount = await MongoService.products!.count(filter);

    // Get products using proper mongo_dart syntax
    final products = await MongoService.products!
        .find(filter)
        .toList();

    // Apply sorting, skipping, and limiting manually (or use aggregation)
    var sortedProducts = products;
    
    // Sort manually
    if (sortBy == 'price') {
      sortedProducts.sort((a, b) {
        final aValue = a[sortBy] as num;
        final bValue = b[sortBy] as num;
        return sortOrder == 'asc' 
            ? aValue.compareTo(bValue) 
            : bValue.compareTo(aValue);
      });
    } else if (sortBy == 'createdAt') {
      sortedProducts.sort((a, b) {
        final aValue = a[sortBy] as DateTime;
        final bValue = b[sortBy] as DateTime;
        return sortOrder == 'asc' 
            ? aValue.compareTo(bValue) 
            : bValue.compareTo(aValue);
      });
    } else if (sortBy == 'rating') {
      sortedProducts.sort((a, b) {
        final aValue = a[sortBy] as num;
        final bValue = b[sortBy] as num;
        return sortOrder == 'asc' 
            ? aValue.compareTo(bValue) 
            : bValue.compareTo(aValue);
      });
    }

    // Apply pagination manually
    final paginatedProducts = sortedProducts.skip(skip).take(limit).toList();

    // Transform ObjectId to string
    final transformedProducts = paginatedProducts.map((product) {
      final transformed = Map<String, dynamic>.from(product);
      transformed['_id'] = (product['_id'] as ObjectId).oid;
      
      if (product['createdAt'] is DateTime) {
        transformed['createdAt'] = (product['createdAt'] as DateTime).toIso8601String();
      }
      if (product['updatedAt'] is DateTime) {
        transformed['updatedAt'] = (product['updatedAt'] as DateTime).toIso8601String();
      }
      
      // Ensure arrays are properly formatted
      if (transformed['multipleImages'] == null || transformed['multipleImages'] is! List) {
        transformed['multipleImages'] = [];
      }
      if (transformed['tags'] == null || transformed['tags'] is! List) {
        transformed['tags'] = [];
      }
      if (transformed['specifications'] == null || transformed['specifications'] is! Map) {
        transformed['specifications'] = {};
      }
      
      return transformed;
    }).toList();

    print('✅ Products fetched: ${transformedProducts.length}');

    return Response.json(
      body: {
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
      body: {'error': 'Failed to fetch products: $e'},
    );
  }
}

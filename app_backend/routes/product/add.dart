// ignore_for_file: avoid_print, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path/path.dart' as path;

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/add API HIT');

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

    /// ONLY SELLER CAN ADD PRODUCT
    if (userRole != 'seller') {
      return Response.json(
        statusCode: 403,
        body: {'success': false, 'message': 'Only sellers can add products'},
      );
    }

    /// FIND SELLER
    final seller = await MongoService.users!.findOne({
      '_id': ObjectId.parse(userId),
    });

    if (seller == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Seller not found'},
      );
    }

    /// CHECK CONTENT TYPE
    final contentType = context.request.headers['content-type'] ?? '';

    if (contentType.contains('multipart/form-data')) {
      return _handleMultipartRequest(context, userId, seller);
    } else {
      return _handleJsonRequest(context, userId, seller);
    }
  } catch (e) {
    print('❌ ERROR: $e');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': e.toString()},
    );
  }
}

/// MULTIPART REQUEST
Future<Response> _handleMultipartRequest(
  RequestContext context,
  String userId,
  Map<String, dynamic> seller,
) async {
  try {
    final formData = await context.request.formData();

    /// TEXT FIELDS
    final productName = formData['productName'];

    final priceStr = formData['price'];

    final stockStr = formData['stock'];

    final category = formData['category'];

    final subCategory = formData['subCategory'];

    final shortDescription = formData['shortDescription'];

    final detailedDescription = formData['detailedDescription'];

    final discountPriceStr = formData['discountPrice'];

    final tagsStr = formData['tags'];

    final specificationsStr = formData['specifications'];

    /// PARSE VALUES
    final price = priceStr != null ? double.tryParse(priceStr) : null;

    final stock = stockStr != null ? int.tryParse(stockStr) : null;

    final discountPrice =
        discountPriceStr != null ? double.tryParse(discountPriceStr) : null;

    /// TAGS
    List<String> tags = [];

    if (tagsStr != null && tagsStr.isNotEmpty) {
      tags = tagsStr.split(',').map((e) => e.trim()).toList();
    }

    /// SPECIFICATIONS
    Map<String, dynamic> specifications = {};

    if (specificationsStr != null && specificationsStr.isNotEmpty) {
      try {
        specifications = Map<String, dynamic>.from(
          jsonDecode(specificationsStr) as Map,
        );
      } catch (e) {
        print('Specification Error: $e');
      }
    }

    /// VALIDATION
    if (productName == null || productName.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product name required'},
      );
    }

    if (price == null || price <= 0) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid price'},
      );
    }

    if (stock == null || stock < 0) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid stock'},
      );
    }

    if (category == null || category.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Category required'},
      );
    }

    if (subCategory == null || subCategory.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Sub category required'},
      );
    }

    /// MAIN BANNER IMAGE
    String mainBannerImage = '';

    final mainBannerFile = formData.files['mainBannerImage'];

    if (mainBannerFile != null) {
      mainBannerImage = await _saveFile(mainBannerFile, 'products/banners');
    } else if (formData['mainBannerImage'] != null) {
      mainBannerImage = formData['mainBannerImage']!;
    } else {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Main banner image required'},
      );
    }

    /// MULTIPLE IMAGES
    List<String> multipleImages = [];

    for (final entry in formData.files.entries) {
      if (entry.key == 'multipleImages') {
        final imageUrl = await _saveFile(entry.value, 'products/images');

        if (imageUrl.isNotEmpty) {
          multipleImages.add(imageUrl);
        }
      }
    }

    /// MULTIPLE IMAGE URLS
    if (formData['multipleImagesUrls'] != null) {
      final urls = formData['multipleImagesUrls']!.split(',');

      multipleImages.addAll(urls);
    }

    /// PRODUCT DATA
    final productData = {
      'sellerId': userId,
      'sellerName': seller['fullName']?.toString() ?? '',
      'productName': productName,
      'mainBannerImage': mainBannerImage,
      'multipleImages': multipleImages,
      'price': price,
      'discountPrice': discountPrice,
      'stock': stock,
      'stockAvailable': stock > 0,
      'category': category,
      'subCategory': subCategory,
      'tags': tags,
      'rating': 0.0,
      'totalReviews': 0,
      'shortDescription': shortDescription?.toString() ?? '',
      'detailedDescription': detailedDescription?.toString() ?? '',
      'specifications': specifications,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'isActive': true,
    };

    /// INSERT PRODUCT
    final result = await MongoService.products!.insertOne(productData);

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to add product'},
      );
    }

    print('✅ PRODUCT ADDED');

    return Response.json(
      statusCode: 201,
      body: {
        'success': true,
        'message': 'Product added successfully',
        'data': {
          'productName': productName,
          'mainBannerImage': mainBannerImage,
          'multipleImages': multipleImages,
        },
      },
    );
  } catch (e) {
    print('❌ MULTIPART ERROR: $e');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': e.toString()},
    );
  }
}

/// JSON REQUEST
Future<Response> _handleJsonRequest(
  RequestContext context,
  String userId,
  Map<String, dynamic> seller,
) async {
  try {
    final body =
        jsonDecode(await context.request.body()) as Map<String, dynamic>;

    /// REQUIRED FIELDS
    final requiredFields = [
      'productName',
      'mainBannerImage',
      'price',
      'stock',
      'category',
      'subCategory',
    ];

    for (final field in requiredFields) {
      if (body[field] == null) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': '$field is required'},
        );
      }
    }

    /// MULTIPLE IMAGES
    List<String> multipleImages = [];

    if (body['multipleImages'] is List) {
      multipleImages =
          (body['multipleImages'] as List).map((e) => e.toString()).toList();
    }

    /// TAGS
    List<String> tags = [];

    if (body['tags'] is List) {
      tags = (body['tags'] as List).map((e) => e.toString()).toList();
    }

    /// SPECIFICATIONS
    Map<String, dynamic> specifications = {};

    if (body['specifications'] is Map) {
      specifications = Map<String, dynamic>.from(body['specifications'] as Map);
    }

    /// PRODUCT DATA
    final productData = {
      'sellerId': userId,
      'sellerName': seller['fullName']?.toString() ?? '',
      'productName': body['productName'].toString(),
      'mainBannerImage': body['mainBannerImage'].toString(),
      'multipleImages': multipleImages,
      'price': (body['price'] as num).toDouble(),
      'discountPrice':
          body['discountPrice'] != null
              ? (body['discountPrice'] as num).toDouble()
              : null,
      'stock': (body['stock'] as num).toInt(),
      'stockAvailable': (body['stock'] as num) > 0,
      'category': body['category'].toString(),
      'subCategory': body['subCategory'].toString(),
      'tags': tags,
      'rating': 0.0,
      'totalReviews': 0,
      'shortDescription': body['shortDescription']?.toString() ?? '',
      'detailedDescription': body['detailedDescription']?.toString() ?? '',
      'specifications': specifications,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'isActive': true,
    };

    /// INSERT PRODUCT
    final result = await MongoService.products!.insertOne(productData);

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to add product'},
      );
    }

    return Response.json(
      statusCode: 201,
      body: {'success': true, 'message': 'Product added successfully'},
    );
  } catch (e) {
    print('❌ JSON ERROR: $e');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': e.toString()},
    );
  }
}

/// SAVE FILE
Future<String> _saveFile(dynamic file, String subDirectory) async {
  try {
    /// CREATE DIRECTORY
    final uploadDir = Directory('uploads/$subDirectory');

    if (!await uploadDir.exists()) {
      await uploadDir.create(recursive: true);
    }

    /// FILE NAME
    final originalFileName = file.filename.toString();

    final safeFileName = path.basename(originalFileName);

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$safeFileName';

    final filePath = '${uploadDir.path}/$fileName';

    /// SAVE FILE
    final savedFile = File(filePath);

    /// READ BYTES
    final List<int> bytes = await file.readAsBytes() as List<int>;

    await savedFile.writeAsBytes(bytes);

    /// RETURN FILE URL
    return '/uploads/$subDirectory/$fileName';
  } catch (e) {
    print('❌ SAVE FILE ERROR: $e');

    return '';
  }
}

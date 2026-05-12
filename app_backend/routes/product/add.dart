// ignore_for_file: avoid_print, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/cloudinary_setup.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/add API HIT');

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
        body: {'success': false, 'message': 'Only sellers can add products'},
      );
    }

    final seller = await MongoService.users!.findOne({
      '_id': ObjectId.parse(userId),
    });

    if (seller == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Seller not found'},
      );
    }

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

Future<Response> _handleMultipartRequest(
  RequestContext context,
  String userId,
  Map<String, dynamic> seller,
) async {
  try {
    final formData = await context.request.formData();

    print('📋 Form data fields: ${formData.fields.keys}');
    print('📋 Form data files keys: ${formData.files.keys}');

    // Debug: Print all files received
    print('🔍 All files received:');
    for (final entry in formData.files.entries) {
      print('  Key: ${entry.key} -> File: ${entry.value.name}');
    }

    // Extract text fields
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

    // Validate required fields
    if (productName == null || productName.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product name is required'},
      );
    }

    final price = priceStr != null ? double.tryParse(priceStr) : null;
    if (price == null || price <= 0) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Valid price is required'},
      );
    }

    final stock = stockStr != null ? int.tryParse(stockStr) : null;
    if (stock == null || stock < 0) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Valid stock is required'},
      );
    }

    if (category == null || category.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Category is required'},
      );
    }

    if (subCategory == null || subCategory.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Sub category is required'},
      );
    }

    // Parse tags
    List<String> tags = [];
    if (tagsStr != null && tagsStr.isNotEmpty) {
      tags = tagsStr.split(',').map((e) => e.trim()).toList();
    }

    // Parse specifications
    Map<String, dynamic> specifications = {};
    if (specificationsStr != null && specificationsStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(specificationsStr);
        specifications = Map<String, dynamic>.from(decoded as Map);
      } catch (e) {
        print('Specification parsing error: $e');
        try {
          final fixedJson = specificationsStr
              .replaceAll('(', '{')
              .replaceAll(')', '}');
          final decoded = jsonDecode(fixedJson);
          specifications = Map<String, dynamic>.from(decoded as Map);
        } catch (e2) {
          print('Failed to parse specifications: $e2');
        }
      }
    }

    // Upload main banner image
    String mainBannerImage = '';
    final mainBannerFile = formData.files['mainBannerImage'];

    if (mainBannerFile != null) {
      print('📸 Processing main banner image: ${mainBannerFile.name}');
      mainBannerImage = await _uploadToCloudinary(mainBannerFile);
      if (mainBannerImage.isEmpty) {
        return Response.json(
          statusCode: 400,
          body: {
            'success': false,
            'message': 'Failed to upload main banner image',
          },
        );
      }
    } else {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Main banner image is required'},
      );
    }

    // Upload multiple images - IMPROVED: Handle all possible formats
    List<String> multipleImages = [];

    // Method 1: Look for keys that start with 'multipleImages' or 'multipileimages' (typo in your screenshot)
    for (final entry in formData.files.entries) {
      final key = entry.key.toLowerCase();
      // Check for various patterns: multipleImages, multipleImages1, multipleImages[], multipileimages, etc.
      if (key.startsWith('multipleimages') ||
          key.startsWith('multipileimages') ||
          key.contains('multipleimages') ||
          key == 'multipileimages') {
        final file = entry.value;
        print(
          '📸 Processing multiple image with key ${entry.key}: ${file.name}',
        );
        final url = await _uploadToCloudinary(file);
        if (url.isNotEmpty) {
          multipleImages.add(url);
        }
      }
    }

    // Method 2: Look for array format like multipleImages[0], multipleImages[1], etc.
    for (final entry in formData.files.entries) {
      final key = entry.key;
      final pattern = RegExp(r'multipleImages\[\d+\]', caseSensitive: false);
      if (pattern.hasMatch(key)) {
        final file = entry.value;
        print('📸 Processing multiple image with array key $key: ${file.name}');
        final url = await _uploadToCloudinary(file);
        if (url.isNotEmpty && !multipleImages.contains(url)) {
          multipleImages.add(url);
        }
      }
    }

    // Method 3: Look for numbered keys like multipleImages1, multipleImages2, etc.
    for (final entry in formData.files.entries) {
      final key = entry.key;
      final pattern = RegExp(r'multipleImages\d+', caseSensitive: false);
      if (pattern.hasMatch(key)) {
        final file = entry.value;
        final url = await _uploadToCloudinary(file);
        if (url.isNotEmpty && !multipleImages.contains(url)) {
          multipleImages.add(url);
        }
      }
    }

    print('✅ Total multiple images uploaded: ${multipleImages.length}');

    if (multipleImages.isEmpty) {
      print('⚠️ Warning: No multiple images were uploaded');
    }

    // Prepare product data
    final productData = {
      'sellerId': userId,
      'sellerName':
          seller['fullName']?.toString() ??
          seller['name']?.toString() ??
          'Seller',
      'productName': productName,
      'mainBannerImage': mainBannerImage,
      'multipleImages': multipleImages,
      'price': price,
      'discountPrice':
          discountPriceStr != null ? double.tryParse(discountPriceStr) : null,
      'stock': stock,
      'stockAvailable': stock > 0,
      'category': category,
      'subCategory': subCategory,
      'tags': tags,
      'rating': 0.0,
      'totalReviews': 0,
      'shortDescription': shortDescription ?? '',
      'detailedDescription': detailedDescription ?? '',
      'specifications': specifications,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'isActive': true,
    };

    // Insert into database
    final result = await MongoService.products!.insertOne(productData);

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {
          'success': false,
          'message': 'Failed to save product to database',
        },
      );
    }

    print('✅ Product added successfully: $productName');
    print('📸 Main image: $mainBannerImage');
    print('📸 Multiple images (${multipleImages.length}): $multipleImages');

    return Response.json(
      statusCode: 201,
      body: {
        'success': true,
        'message': 'Product added successfully',
        'data': {
          'productName': productName,
          'mainBannerImage': mainBannerImage,
          'multipleImages': multipleImages,
          'totalImages': 1 + multipleImages.length,
        },
      },
    );
  } catch (e, stackTrace) {
    print('❌ Multipart error: $e');
    print('Stack trace: $stackTrace');

    return Response.json(
      statusCode: 500,
      body: {'success': false, 'message': 'Server error: ${e.toString()}'},
    );
  }
}

Future<String> _uploadToCloudinary(UploadedFile file) async {
  try {
    print('📸 Processing file: ${file.name}');

    final List<int> bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      print('❌ File is empty');
      return '';
    }

    print(
      '✅ File size: ${bytes.length} bytes (${(bytes.length / 1024 / 1024).toStringAsFixed(2)} MB)',
    );

    final Uint8List imageBytes = Uint8List.fromList(bytes);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final originalName = file.name ?? 'image.jpg';
    final extension =
        originalName.contains('.') ? originalName.split('.').last : 'jpg';
    final fileName = '${timestamp}_product.$extension';

    print('📁 Uploading as: $fileName');

    final url = await CloudinarySetup.uploadImageDirect(
      bytes: imageBytes,
      fileName: fileName,
      folder: 'ecommerce/products',
    );

    if (url == null || url.isEmpty) {
      print('❌ Upload failed - no URL returned');
      return '';
    }

    print('✅ Successfully uploaded to: $url');
    return url;
  } catch (e, stackTrace) {
    print('❌ Upload error: $e');
    print('Stack trace: $stackTrace');
    return '';
  }
}

Future<Response> _handleJsonRequest(
  RequestContext context,
  String userId,
  Map<String, dynamic> seller,
) async {
  final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;

  final productData = {
    'sellerId': userId,
    'sellerName': seller['fullName'] ?? '',
    'productName': body['productName'],
    'mainBannerImage': body['mainBannerImage'],
    'multipleImages': body['multipleImages'] ?? [],
    'price': body['price'],
    'stock': body['stock'],
    'category': body['category'],
    'subCategory': body['subCategory'],
    'createdAt': DateTime.now(),
    'updatedAt': DateTime.now(),
  };

  await MongoService.products!.insertOne(productData);

  return Response.json(
    statusCode: 201,
    body: {'success': true, 'message': 'Product added successfully'},
  );
}

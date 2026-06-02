// // ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values

// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:mongo_dart/mongo_dart.dart';

// import 'package:my_backend/config/env.dart';
// import 'package:my_backend/db/mongo.dart';

// /// API Endpoint: POST /product/review/add
// ///
// /// Request Body:
// /// {
// ///   "productId": "product_object_id",
// ///   "rating": 5,
// ///   "comment": "Great product!",
// ///   "images": ["image_url_1", "image_url_2"]  // optional
// /// }
// Future<Response> onRequest(RequestContext context) async {
//   print('🔥 /product/review/add API HIT');

//   // Check method
//   if (context.request.method != HttpMethod.post) {
//     return Response.json(
//       statusCode: 405,
//       body: {'success': false, 'message': 'Method not allowed'},
//     );
//   }

//   // Auth header validation
//   final authHeader = context.request.headers['authorization'];
//   if (authHeader == null || !authHeader.startsWith('Bearer ')) {
//     return Response.json(
//       statusCode: 401,
//       body: {'success': false, 'message': 'Token missing or invalid'},
//     );
//   }

//   final token = authHeader.split(' ')[1];

//   try {
//     // Verify JWT
//     final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
//     final userId = jwt.payload['id'].toString();
//     final userRole = jwt.payload['role']?.toString() ?? 'customer';

//     // Only customers can add reviews
//     if (userRole != 'customer') {
//       return Response.json(
//         statusCode: 403,
//         body: {'success': false, 'message': 'Only customers can add reviews'},
//       );
//     }

//     // Parse request body
//     final body =
//         jsonDecode(await context.request.body()) as Map<String, dynamic>;

//     final productId = body['productId']?.toString();
//     final rating = body['rating'] as int?;
//     final comment = body['comment']?.toString();
//     final images =
//         (body['images'] as List?)?.map((e) => e.toString()).toList() ?? [];

//     // Validate required fields
//     if (productId == null || productId.isEmpty) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Product ID is required'},
//       );
//     }

//     if (rating == null || rating < 1 || rating > 5) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Rating must be between 1 and 5'},
//       );
//     }

//     if (comment == null || comment.isEmpty) {
//       return Response.json(
//         statusCode: 400,
//         body: {'success': false, 'message': 'Comment is required'},
//       );
//     }

//     // Check if product exists and is active
//     final product = await MongoService.products!.findOne({
//       '_id': ObjectId.parse(productId),
//       'isActive': true,
//     });

//     if (product == null) {
//       return Response.json(
//         statusCode: 404,
//         body: {'success': false, 'message': 'Product not found'},
//       );
//     }

//     // Check if user has already reviewed this product
//     final existingReview = await MongoService.reviews!.findOne({
//       'productId': productId,
//       'userId': userId,
//     });

//     if (existingReview != null) {
//       return Response.json(
//         statusCode: 400,
//         body: {
//           'success': false,
//           'message': 'You have already reviewed this product',
//         },
//       );
//     }

//     // Get user details
//     final user = await MongoService.users!.findOne({
//       '_id': ObjectId.parse(userId),
//     });

//     if (user == null) {
//       return Response.json(
//         statusCode: 404,
//         body: {'success': false, 'message': 'User not found'},
//       );
//     }

//     final userName =
//         user['fullName']?.toString() ?? user['name']?.toString() ?? 'User';
//     final userAvatar = user['avatar']?.toString() ?? '';

//     // Check if user has purchased this product (optional - for verified purchase)
//     // This depends on your orders collection structure
//     bool isVerifiedPurchase = false;
//     if (MongoService.orders != null) {
//       final order = await MongoService.orders!.findOne({
//         'userId': userId,
//         'orderStatus': 'delivered',
//         'items.productId': productId,
//       });
//       isVerifiedPurchase = order != null;
//     }

//     // Create review
//     final reviewData = {
//       'productId': productId,
//       'userId': userId,
//       'userName': userName,
//       'userAvatar': userAvatar,
//       'rating': rating,
//       'comment': comment,
//       'images': images,
//       'isVerifiedPurchase': isVerifiedPurchase,
//       'createdAt': DateTime.now(),
//       'updatedAt': DateTime.now(),
//     };

//     final result = await MongoService.reviews!.insertOne(reviewData);

//     if (!result.isSuccess) {
//       return Response.json(
//         statusCode: 500,
//         body: {'success': false, 'message': 'Failed to save review'},
//       );
//     }

//     // Update product rating and total reviews
//     await _updateProductRating(productId);

//     print(
//       '✅ Review added successfully for product: $productId by user: $userId',
//     );

//     return Response.json(
//       statusCode: 201,
//       body: {
//         'success': true,
//         'message': 'Review added successfully',
//         'data': {
//           'reviewId': (result.document!['_id'] as ObjectId).oid,
//           'productId': productId,
//           'rating': rating,
//         },
//       },
//     );
//   } catch (e) {
//     print('❌ ERROR: $e');
//     return Response.json(
//       statusCode: 500,
//       body: {'success': false, 'message': 'Server error: $e'},
//     );
//   }
// }

// /// Helper function to update product rating and total reviews
// Future<void> _updateProductRating(String productId) async {
//   try {
//     // Get all reviews for this product
//     final reviews =
//         await MongoService.reviews!.find({'productId': productId}).toList();

//     if (reviews.isEmpty) return;

//     // Calculate average rating
//     double totalRating = 0;
//     for (final review in reviews) {
//       totalRating += (review['rating'] as int).toDouble();
//     }
//     final averageRating = totalRating / reviews.length;
//     final roundedRating = double.parse(averageRating.toStringAsFixed(1));

//     // Update product
//     await MongoService.products!.updateOne(
//       {'_id': ObjectId.parse(productId)},
//       {
//         r'$set': {
//           'rating': roundedRating,
//           'totalReviews': reviews.length,
//           'updatedAt': DateTime.now(),
//         },
//       },
//     );

//     print('✅ Product rating updated: $roundedRating ($totalRating total)');
//   } catch (e) {
//     print('❌ Error updating product rating: $e');
//   }
// }

// routes/product/review/add.dart (COMPLETE REPLACEMENT)
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values
// routes/product/review/add.dart
// ignore_for_file: avoid_print, avoid_dynamic_calls, deprecated_member_use, inference_failure_on_collection_literal, omit_local_variable_types, prefer_final_locals, lines_longer_than_80_chars, avoid_redundant_argument_values

import 'dart:convert';
import 'dart:typed_data';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/cloudinary_setup.dart';

Future<Response> onRequest(RequestContext context) async {
  print('🔥 /product/review/add API HIT');

  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: 401,
      body: {'success': false, 'message': 'Token missing or invalid'},
    );
  }

  final token = authHeader.split(' ')[1];

  try {
    final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));
    final userId = jwt.payload['id'].toString();
    final userRole = jwt.payload['role']?.toString() ?? 'customer';

    if (userRole != 'customer') {
      return Response.json(
        statusCode: 403,
        body: {'success': false, 'message': 'Only customers can add reviews'},
      );
    }

    final request = context.request;
    final contentType = request.headers['content-type'] ?? '';

    String? productId;
    int? rating;
    String? comment;
    List<String> imageUrls = [];

    if (contentType.contains('multipart/form-data')) {
      print('📎 Processing multipart form data with files...');

      try {
        final formData = await request.formData();

        productId = formData.fields['productId'];
        rating = int.tryParse(formData.fields['rating'] ?? '');
        comment = formData.fields['comment'];

        final dynamic imagesField = formData.files['images'];

        print('📊 Product ID: $productId');
        print('⭐ Rating: $rating');
        if (comment != null && comment.isNotEmpty) {
          print(
            '💬 Comment: ${comment.substring(0, comment.length > 50 ? 50 : comment.length)}...',
          );
        }

        List<dynamic> filesList = [];

        if (imagesField != null) {
          if (imagesField is List) {
            filesList = imagesField;
            print('📸 Multiple images detected: ${filesList.length} files');
          } else {
            filesList.add(imagesField);
            print('📸 Single image detected');
          }
        }

        print('📸 Total images to process: ${filesList.length}');

        // Upload each image to Cloudinary using readAsBytes() method
        if (filesList.isNotEmpty) {
          print('☁️ Uploading ${filesList.length} images to Cloudinary...');

          for (int i = 0; i < filesList.length; i++) {
            final dynamic file = filesList[i];

            String fileName =
                'review_image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            try {
              if (file.name != null) {
                fileName = file.name.toString();
              }
            } catch (e) {
              print('  ⚠️ Could not get file name: $e');
            }

            print(
              '  📤 Uploading image ${i + 1}/${filesList.length}: $fileName',
            );

            try {
              final dynamic bytesData = await file.readAsBytes();

              if (bytesData == null) {
                print('  ❌ No data read from file');
                continue;
              }

              // Convert to Uint8List properly
              final Uint8List bytes;
              if (bytesData is Uint8List) {
                bytes = bytesData;
              } else if (bytesData is List<int>) {
                bytes = Uint8List.fromList(bytesData);
              } else {
                print('  ❌ Unexpected bytes type: ${bytesData.runtimeType}');
                continue;
              }

              if (bytes.isEmpty) {
                print('  ❌ File is empty');
                continue;
              }

              print('  ✅ File size: ${bytes.length} bytes');

              final imageUrl = await CloudinarySetup.uploadImageDirect(
                bytes: bytes,
                fileName: fileName,
                folder: 'ecommerce/reviews',
              );

              if (imageUrl != null && imageUrl.isNotEmpty) {
                imageUrls.add(imageUrl);
                print('  ✅ Upload successful: $imageUrl');
              } else {
                print('  ❌ Upload failed for: $fileName');
              }
            } catch (uploadError) {
              print('  ❌ Error uploading file: $uploadError');
            }
          }
        } else {
          print('⚠️ No images found in the request');
        }
      } catch (e, stackTrace) {
        print('❌ Error parsing form data: $e');
        print('Stack trace: $stackTrace');
        return Response.json(
          statusCode: 400,
          body: {
            'success': false,
            'message': 'Invalid form data: ${e.toString()}',
          },
        );
      }
    } else {
      print('📝 Processing JSON request...');
      try {
        final body = jsonDecode(await request.body()) as Map<String, dynamic>;
        productId = body['productId']?.toString();
        rating = body['rating'] as int?;
        comment = body['comment']?.toString();
        imageUrls =
            (body['images'] as List?)?.map((e) => e.toString()).toList() ?? [];
      } catch (e) {
        return Response.json(
          statusCode: 400,
          body: {'success': false, 'message': 'Invalid JSON body: $e'},
        );
      }
    }

    if (productId == null || productId.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Product ID is required'},
      );
    }

    if (rating == null || rating < 1 || rating > 5) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Rating must be between 1 and 5'},
      );
    }

    if (comment == null || comment.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Comment is required'},
      );
    }

    late final ObjectId productObjectId;
    try {
      productObjectId = ObjectId.parse(productId);
    } catch (e) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid product ID format'},
      );
    }

    final product = await MongoService.products!.findOne({
      '_id': productObjectId,
      'isActive': true,
    });

    if (product == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'Product not found'},
      );
    }

    final existingReview = await MongoService.reviews!.findOne({
      'productId': productId,
      'userId': userId,
    });

    if (existingReview != null) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'You have already reviewed this product',
        },
      );
    }

    final user = await MongoService.users!.findOne({
      '_id': ObjectId.parse(userId),
    });

    if (user == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'User not found'},
      );
    }

    final userName =
        user['fullName']?.toString() ?? user['name']?.toString() ?? 'User';
    final userAvatar = user['avatar']?.toString() ?? '';

    bool isVerifiedPurchase = false;
    if (MongoService.orders != null) {
      final order = await MongoService.orders!.findOne({
        'userId': userId,
        'orderStatus': 'delivered',
        'items.productId': productId,
      });
      isVerifiedPurchase = order != null;
    }

    final reviewData = {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'images': imageUrls,
      'isVerifiedPurchase': isVerifiedPurchase,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    final result = await MongoService.reviews!.insertOne(reviewData);

    if (!result.isSuccess) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Failed to save review'},
      );
    }

    await _updateProductRating(productId);

    print(
      '✅ Review added successfully for product: $productId by user: $userId',
    );
    print('📸 Uploaded ${imageUrls.length} images to Cloudinary');

    return Response.json(
      statusCode: 201,
      body: {
        'success': true,
        'message': 'Review added successfully',
        'data': {
          'reviewId': (result.document!['_id'] as ObjectId).oid,
          'productId': productId,
          'rating': rating,
          'images': imageUrls,
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

Future<void> _updateProductRating(String productId) async {
  try {
    final reviews =
        await MongoService.reviews!.find({'productId': productId}).toList();

    if (reviews.isEmpty) return;

    double totalRating = 0;
    for (final review in reviews) {
      totalRating += (review['rating'] as int).toDouble();
    }
    final averageRating = totalRating / reviews.length;
    final roundedRating = double.parse(averageRating.toStringAsFixed(1));

    await MongoService.products!.updateOne(
      {'_id': ObjectId.parse(productId)},
      {
        r'$set': {
          'rating': roundedRating,
          'totalReviews': reviews.length,
          'updatedAt': DateTime.now(),
        },
      },
    );

    print(
      '✅ Product rating updated: $roundedRating (${reviews.length} total reviews)',
    );
  } catch (e) {
    print('❌ Error updating product rating: $e');
  }
}

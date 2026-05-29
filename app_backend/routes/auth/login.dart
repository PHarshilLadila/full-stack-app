// // // ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars

// // import 'dart:convert';
// // import 'package:dart_frog/dart_frog.dart';
// // import 'package:mongo_dart/mongo_dart.dart';
// // import 'package:my_backend/db/mongo.dart';
// // import 'package:my_backend/services/auth_service.dart';

// // Future<Response> onRequest(RequestContext context) async {
// //   final body = jsonDecode(await context.request.body());

// //   print('LOGIN BODY: $body');

// //   final identifier = body['identifier']?.toString() ?? '';
// //   final password = body['password']?.toString() ?? '';

// //   if (identifier.isEmpty || password.isEmpty) {
// //     return Response.json(body: {'error': 'Identifier and password required'});
// //   }

// //   if (MongoService.users == null) {
// //     return Response.json(body: {'error': 'DB not connected'});
// //   }

// //   final user = await MongoService.users!.findOne({
// //     r'$or': [
// //       {'email': identifier},
// //       {'username': identifier},
// //       {'mobile': identifier},
// //     ],
// //   });

// //   if (user == null) {
// //     return Response.json(body: {'error': 'User not found'});
// //   }

// //   final valid = AuthService.verifyPassword(
// //     password,
// //     user['passwordHash'].toString(),
// //   );

// //   if (!valid) {
// //     return Response.json(body: {'error': 'Wrong password'});
// //   }

// //   final objectId = user['_id'] as ObjectId;
// //   final userRole =
// //       user['role']?.toString() ?? 'customer'; // Default to customer

// //   final token = AuthService.generateToken(objectId.oid, userRole);

// //   print('🆔 ObjectId: ${objectId.oid}');
// //   print('👤 User Role: $userRole');
// //   print('🔐 Generated Token: $token');
// //   print('✅ Login success');

// //   return Response.json(
// //     body: {
// //       'message': 'Login success',
// //       'token': token,
// //       'role': userRole,
// //       'userId': objectId.oid,
// //     },
// //   );
// // }

// // routes/auth/login.dart
// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:my_backend/db/mongo.dart';
// import 'package:my_backend/services/auth_service.dart';

// Future<Response> onRequest(RequestContext context) async {
//   try {
//     print('🔥 LOGIN API HIT');

//     final body = jsonDecode(await context.request.body());
//     print('LOGIN BODY: $body');

//     final identifier = body['identifier']?.toString().trim() ?? '';
//     final password = body['password']?.toString().trim() ?? '';

//     if (identifier.isEmpty || password.isEmpty) {
//       return Response.json(
//         statusCode: 400, // Bad Request
//         body: {'success': false, 'message': 'Identifier and password required'},
//       );
//     }

//     if (MongoService.users == null) {
//       return Response.json(
//         statusCode: 503, // Service Unavailable
//         body: {
//           'success': false,
//           'message': 'Database connection is unavailable',
//         },
//       );
//     }

//     final user = await MongoService.users!.findOne({
//       r'$or': [
//         {'email': identifier},
//         {'username': identifier},
//         {'mobile': identifier},
//       ],
//     });

//     if (user == null) {
//       return Response.json(
//         statusCode: 404, // Not Found
//         body: {'success': false, 'message': 'User not found'},
//       );
//     }

//     // Defensive check: Ensure passwordHash exists in DB document
//     if (user['passwordHash'] == null) {
//       return Response.json(
//         statusCode: 500,
//         body: {'success': false, 'message': 'User account is misconfigured'},
//       );
//     }

//     final valid = AuthService.verifyPassword(
//       password,
//       user['passwordHash'].toString(),
//     );

//     if (!valid) {
//       return Response.json(
//         statusCode: 401, // Unauthorized
//         body: {'success': false, 'message': 'Wrong password'},
//       );
//     }

//     final objectId = user['_id'] as ObjectId;
//     final userRole = user['role']?.toString() ?? 'customer';

//     final token = AuthService.generateToken(objectId.oid, userRole);

//     print('✅ Login success for: $identifier');

//     return Response.json(
//       statusCode: 200, // Explicit OK
//       body: {
//         'success': true,
//         'message': 'Login success',
//         'token': token,
//         'role': userRole,
//         'userId': objectId.oid,
//       },
//     );
//   } catch (e, stackTrace) {
//     print('❌ LOGIN ROUTE ERROR: $e');
//     print('STACK TRACE: $stackTrace');

//     // This ensures your Flutter app ALWAYS receives valid JSON, even during a backend crash!
//     return Response.json(
//       statusCode: 500,
//       body: {
//         'success': false,
//         'message': 'Internal server error',
//         'error': e.toString(), // Optional: remove in production
//       },
//     );
//   }
// }

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/db/mongo.dart';
import 'package:my_backend/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }

  try {
    print('🔥 LOGIN API HIT');

    final bodyString = await context.request.body();
    print('Raw body: $bodyString');

    if (bodyString.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Request body is empty'},
      );
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(bodyString) as Map<String, dynamic>;
    } catch (e) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid JSON format'},
      );
    }

    final identifier = body['identifier']?.toString().trim() ?? '';
    final password = body['password']?.toString().trim() ?? '';

    if (identifier.isEmpty || password.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'Email/Username and password required',
        },
      );
    }

    if (MongoService.users == null) {
      return Response.json(
        statusCode: 503,
        body: {'success': false, 'message': 'Database connection unavailable'},
      );
    }

    final user = await MongoService.users!.findOne({
      r'$or': [
        {'email': identifier},
        {'username': identifier},
        {'mobile': identifier},
      ],
    });

    if (user == null) {
      return Response.json(
        statusCode: 404,
        body: {'success': false, 'message': 'User not found'},
      );
    }

    final storedHash = user['passwordHash']?.toString() ?? '';

    if (storedHash.isEmpty) {
      return Response.json(
        statusCode: 500,
        body: {'success': false, 'message': 'Invalid user account'},
      );
    }

    // Check if it's bcrypt hash (starts with $2) - if yes, user needs password reset
    if (storedHash.startsWith(r'$2')) {
      return Response.json(
        statusCode: 401,
        body: {
          'success': false,
          'message':
              'Your password needs to be reset. Please use "Forgot Password" option.',
          'needsReset': true,
        },
      );
    }

    // Verify password using SHA-256
    final isValid = AuthService.verifyPassword(password, storedHash);

    if (!isValid) {
      return Response.json(
        statusCode: 401,
        body: {'success': false, 'message': 'Invalid password'},
      );
    }

    final objectId = user['_id'] as ObjectId;
    final userRole = user['role']?.toString() ?? 'customer';
    final token = AuthService.generateToken(objectId.oid, userRole);

    print('✅ Login successful: $identifier');

    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Login successful',
        'token': token,
        'role': userRole,
        'userId': objectId.oid,
        'email': user['email'],
        'fullName': user['fullName'],
      },
    );
  } catch (e, stackTrace) {
    print('❌ LOGIN ERROR: $e');
    print('STACK TRACE: $stackTrace');

    return Response.json(
      statusCode: 500,
      body: {
        'success': false,
        'message': 'Internal server error',
        'error': e.toString(),
      },
    );
  }
}

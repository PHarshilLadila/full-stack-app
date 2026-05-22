// // ignore_for_file: avoid_print, avoid_redundant_argument_values

// import 'dart:io';

// import 'package:dart_frog/dart_frog.dart';
// import 'package:my_backend/db/mongo.dart';

// Handler middleware(Handler handler) {
//   return (context) async {
//     print('🔥 Middleware hit');

//     await MongoService.connect();

//     // Handle OPTIONS request
//     if (context.request.method == HttpMethod.options) {
//       return Response(
//         statusCode: 200,
//         headers: {
//           HttpHeaders.accessControlAllowOriginHeader: '*',
//           HttpHeaders.accessControlAllowMethodsHeader:
//               'GET, POST, PUT, DELETE, OPTIONS',
//           HttpHeaders.accessControlAllowHeadersHeader: '*',
//         },
//       );
//     }

//     final response = await handler(context);

//     // Add CORS headers
//     return response.copyWith(
//       headers: {
//         ...response.headers,
//         HttpHeaders.accessControlAllowOriginHeader: '*',
//         HttpHeaders.accessControlAllowMethodsHeader:
//             'GET, POST, PUT, DELETE, OPTIONS',
//         HttpHeaders.accessControlAllowHeadersHeader: '*',
//       },
//     );
//   };
// }

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/db/mongo.dart';

Handler middleware(Handler handler) {
  return (context) async {
    print('🔥 Middleware hit');
    
    // Ensure database connection is ready
    try {
      await MongoService.ensureConnection();
    } catch (e) {
      print('❌ Database connection failed: $e');
      return Response.json(
        statusCode: 503,
        body: {
          'error': 'Service temporarily unavailable',
          'message': 'Please try again in a moment',
        },
      );
    }
    
    // Handle CORS preflight
    if (context.request.method == HttpMethod.options) {
      return Response(
        statusCode: 200,
        headers: {
          HttpHeaders.accessControlAllowOriginHeader: '*',
          HttpHeaders.accessControlAllowMethodsHeader:
              'GET, POST, PUT, DELETE, OPTIONS',
          HttpHeaders.accessControlAllowHeadersHeader: '*',
        },
      );
    }
    
    final response = await handler(context);
    
    // Add CORS headers to response
    return response.copyWith(
      headers: {
        ...response.headers,
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.accessControlAllowMethodsHeader:
            'GET, POST, PUT, DELETE, OPTIONS',
        HttpHeaders.accessControlAllowHeadersHeader: '*',
      },
    );
  };
}
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

// ignore_for_file: avoid_print, avoid_redundant_argument_values

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/db/mongo.dart';

Handler middleware(Handler handler) {
  return (context) async {
    print('🔥 Middleware hit');

    try {
      await MongoService.connect();
    } catch (e) {
      print('❌ Middleware connection error: $e');
      // Return a friendly error to the client
      return Response.json(
        statusCode: 503,
        body: {
          'error': 'Service temporarily unavailable',
          'message': 'Database connection issue. Please try again.',
        },
      );
    }

    // Handle OPTIONS request
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

    // Add CORS headers
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

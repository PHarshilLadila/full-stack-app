// // ignore_for_file: public_member_api_docs

// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:my_backend/config/env.dart';

// Handler middleware(Handler handler) {
//   return (context) async {
//     final request = context.request;

//     // Allow public routes
//     if (request.uri.path.contains('/auth/login') ||
//         request.uri.path.contains('/auth/register') ||
//         request.uri.path.contains('/product/list') ||
//         request.uri.path.contains('/product/details')) {
//       return handler(context);
//     }

//     final authHeader = request.headers['authorization'];

//     if (authHeader == null || !authHeader.startsWith('Bearer ')) {
//       return Response.json(statusCode: 401, body: {'error': 'Token missing'});
//     }

//     final token = authHeader.split(' ')[1];

//     try {
//       // final env = DotEnv()..load();

//       // JWT.verify(token, SecretKey(env['JWT_SECRET']!));
//       // final secret = Platform.environment['JWT_SECRET']!;
//       JWT.verify(token, SecretKey(Env.jwtSecret));
//       // JWT.verify(token, SecretKey(secret));

//       // Token valid → allow request
//       return handler(context);
//     } catch (e) {
//       return Response.json(statusCode: 401, body: {'error': 'Invalid token'});
//     }
//   };
// }

// app_backend/lib/middleware/auth_middleware.dart
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_backend/config/env.dart';

/// Authentication data holder
class AuthData {
  final String userId;
  final String userRole;

  const AuthData({required this.userId, required this.userRole});
}

/// Auth middleware to validate JWT and add user info to context
Handler authMiddleware(Handler handler) {
  return (context) async {
    final request = context.request;

    // Public routes that don't require authentication
    final publicRoutes = [
      '/auth/login',
      '/auth/register',
      '/product/list',
      '/product/details',
    ];

    if (publicRoutes.any((route) => request.uri.path.contains(route))) {
      return handler(context);
    }

    // Check for authorization header
    final authHeader = request.headers['authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(
        statusCode: 401,
        body: {'success': false, 'message': 'Token missing'},
      );
    }

    final token = authHeader.split(' ')[1];

    try {
      // Verify JWT token
      final jwt = JWT.verify(token, SecretKey(Env.jwtSecret));

      final userId = jwt.payload['id']?.toString();
      final userRole = jwt.payload['role']?.toString() ?? 'customer';

      if (userId == null) {
        return Response.json(
          statusCode: 401,
          body: {'success': false, 'message': 'Invalid token payload'},
        );
      }

      // Create auth data and add to context
      final authData = AuthData(userId: userId, userRole: userRole);
      final updatedContext = context.provide<AuthData>(() => authData);

      return handler(updatedContext);
    } catch (e) {
      return Response.json(
        statusCode: 401,
        body: {'success': false, 'message': 'Invalid token: ${e.toString()}'},
      );
    }
  };
}

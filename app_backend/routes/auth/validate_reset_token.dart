// routes/auth/validate_reset_token.dart
// GET /auth/validate-reset-token?token=xxx

// ignore_for_file: avoid_print, lines_longer_than_80_chars, avoid_redundant_argument_values

import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/services/password_reset_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // Only allow GET method
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }
  
  try {
    print('🔥 VALIDATE RESET TOKEN API HIT');
    
    // Get token from query parameters
    final uri = context.request.uri;
    final token = uri.queryParameters['token'];
    
    if (token == null || token.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'Reset token is required',
        },
      );
    }
    
    // Validate token
    final validation = await PasswordResetService.validateToken(token);
    
    if (validation == null) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'Invalid or expired reset token. Please request a new password reset.',
        },
      );
    }
    
    // Extract values with type casting
    final userId = validation['userId'] as String;
    final email = validation['email'] as String;
    
    return Response.json(
      statusCode: 200,
      body: {
        'success': true,
        'message': 'Token is valid',
        'data': {
          'userId': userId,
          'email': email,
        },
      },
    );
  } catch (e, stackTrace) {
    print('❌ VALIDATE TOKEN ERROR: $e');
    print('STACK TRACE: $stackTrace');
    
    return Response.json(
      statusCode: 500,
      body: {
        'success': false,
        'message': 'Internal server error',
      },
    );
  }
}

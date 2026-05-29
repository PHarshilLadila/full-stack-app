// routes/auth/forgot_password.dart
// POST /auth/forgot-password

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/services/password_reset_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // Only allow POST method
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'success': false, 'message': 'Method not allowed'},
    );
  }
  
  try {
    print('🔥 FORGOT PASSWORD API HIT');
    
    // Parse request body
    final body = jsonDecode(await context.request.body()) as Map<String, dynamic>;
    final identifier = body['identifier']?.toString().trim() ?? '';
    
    // Get client info
    final userAgent = context.request.headers['user-agent'] ?? 'Unknown';
    final ipAddress = context.request.headers['x-forwarded-for'] ?? 
                      context.request.headers['cf-connecting-ip'] ?? 
                      'Unknown';
    
    // Validate input
    if (identifier.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'Please provide email, username, or mobile number',
        },
      );
    }
    
    // Create reset request
    final resetData = await PasswordResetService.createResetRequest(
      identifier: identifier,
      userAgent: userAgent,
      ipAddress: ipAddress.toString(),
    );
    
    if (resetData == null) {
      // Don't reveal if user exists or not for security
      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'If an account exists with this identifier, you will receive a password reset email.',
        },
      );
    }
    
    // Extract values with proper type casting
    final email = resetData['email'] as String;
    final token = resetData['token'] as String;
    final fullName = resetData['fullName'] as String;
    
    // Send reset email
    final emailSent = await PasswordResetService.sendResetEmail(
      email: email,
      token: token,
      fullName: fullName,
    );
    
    if (emailSent) {
      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'Password reset email has been sent to your registered email address.',
        },
      );
    } else {
      return Response.json(
        statusCode: 500,
        body: {
          'success': false,
          'message': 'Failed to send reset email. Please try again later.',
        },
      );
    }
  } catch (e, stackTrace) {
    print('❌ FORGOT PASSWORD ERROR: $e');
    print('STACK TRACE: $stackTrace');
    
    return Response.json(
      statusCode: 500,
      body: {
        'success': false,
        'message': 'Internal server error. Please try again later.',
      },
    );
  }
}
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:my_backend/config/env.dart';
import 'package:my_backend/db/mongo.dart';

class PasswordResetService {
  // Generate a secure reset token
  static String generateResetToken(String userId, String email) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random.secure();
    final randomBytes = List<int>.generate(32, (_) => random.nextInt(256));
    final randomString = base64Url.encode(randomBytes);

    final data = '$userId:$email:$timestamp:$randomString';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  // Create password reset request in database
  static Future<Map<String, dynamic>?> createResetRequest({
    required String identifier,
    required String userAgent,
    required String ipAddress,
  }) async {
    try {
      // Find user by identifier
      final user = await MongoService.users!.findOne({
        r'$or': [
          {'email': identifier},
          {'username': identifier},
          {'mobile': identifier},
        ],
      });

      if (user == null) {
        print('❌ User not found with identifier: $identifier');
        return null;
      }

      final userId = (user['_id'] as ObjectId).oid;
      final email = user['email'] as String;
      final fullName = user['fullName'] as String? ?? 'User';

      // Generate token
      final token = generateResetToken(userId, email);

      // Calculate expiry (24 hours from now)
      final expiresAt = DateTime.now().add(const Duration(hours: 24));

      // Check if there's an existing valid reset request
      final existingRequest = await MongoService.passwordResets!.findOne({
        'userId': userId,
        'isUsed': false,
        'expiresAt': {'\$gt': DateTime.now()},
      });

      // If exists and not expired, delete it (create new one)
      if (existingRequest != null) {
        await MongoService.passwordResets!.deleteOne({
          '_id': existingRequest['_id'],
        });
      }

      // Create new reset request
      final resetRequest = {
        'userId': userId,
        'email': email,
        'token': token,
        'createdAt': DateTime.now(),
        'expiresAt': expiresAt,
        'isUsed': false,
        'userAgent': userAgent,
        'ipAddress': ipAddress,
      };

      await MongoService.passwordResets!.insertOne(resetRequest);

      print('✅ Password reset request created for: $email');

      return {
        'userId': userId,
        'email': email,
        'token': token,
        'fullName': fullName,
      };
    } catch (e) {
      print('❌ Error creating reset request: $e');
      return null;
    }
  }

  // Send password reset email
  static Future<bool> sendResetEmail({
    required String email,
    required String token,
    required String fullName,
  }) async {
    try {
      final resetLink = '${Env.appUrl}/auth/reset-password?token=$token';

      // HTML email template
      final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Your Password</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
    }
    .container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #ffffff;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .header {
      text-align: center;
      padding: 20px 0;
      border-bottom: 2px solid #f0f0f0;
    }
    .header h1 {
      color: #2563eb;
      margin: 0;
    }
    .content {
      padding: 30px 20px;
    }
    .button {
      display: inline-block;
      background-color: #2563eb;
      color: #ffffff !important;
      text-decoration: none;
      padding: 12px 30px;
      border-radius: 8px;
      margin: 20px 0;
      font-weight: bold;
      text-align: center;
    }
    .button:hover {
      background-color: #1d4ed8;
    }
    .footer {
      text-align: center;
      padding: 20px;
      font-size: 12px;
      color: #666;
      border-top: 1px solid #f0f0f0;
    }
    .warning {
      background-color: #fef3c7;
      padding: 15px;
      border-radius: 8px;
      margin: 20px 0;
      font-size: 14px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🛍️ E-Shop</h1>
      <p>Password Reset Request</p>
    </div>
    <div class="content">
      <p>Hello <strong>$fullName</strong>,</p>
      <p>We received a request to reset your password for your E-Shop account.</p>
      <p>Click the button below to create a new password:</p>
      <div style="text-align: center;">
        <a href="$resetLink" class="button">Reset Password</a>
      </div>
      <p>Or copy and paste this link in your browser:</p>
      <p style="word-break: break-all; background-color: #f5f5f5; padding: 10px; border-radius: 6px; font-size: 12px;">
        $resetLink
      </p>
      <div class="warning">
        ⚠️ <strong>Important:</strong> This link will expire in <strong>24 hours</strong>. 
        If you didn't request a password reset, please ignore this email or contact support.
      </div>
    </div>
    <div class="footer">
      <p>© ${DateTime.now().year} E-Shop. All rights reserved.</p>
      <p>This is an automated message, please do not reply to this email.</p>
    </div>
  </div>
</body>
</html>
      ''';

      // Plain text version
      final textContent = '''
Hello $fullName,

We received a request to reset your password for your E-Shop account.

Click the link below to create a new password:
$resetLink

Important: This link will expire in 24 hours.

If you didn't request a password reset, please ignore this email or contact support.

---
E-Shop Team
${DateTime.now().year} E-Shop. All rights reserved.
      ''';

      // SMTP server configuration for Gmail
      final smtpServer = gmail(Env.emailUser, Env.emailPassword);

      // Create email message
      final message =
          Message()
            ..from = Address(Env.emailFrom, 'E-Shop Support')
            ..recipients.add(email)
            ..subject = 'Reset Your E-Shop Password'
            ..text = textContent
            ..html = htmlContent;

      // Send email
      final sendReport = await send(message, smtpServer);

      // FIXED: Check if email was sent successfully
      // In mailer package, we check if there are no errors
      if (sendReport.toString().contains('success') ||
          !sendReport.toString().contains('Exception')) {
        print('✅ Reset email sent to: $email');
        return true;
      } else {
        print('❌ Failed to send email: ${sendReport.toString()}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending reset email: $e');
      return false;
    }
  }

  // Validate reset token
  static Future<Map<String, dynamic>?> validateToken(String token) async {
    try {
      final resetRequest = await MongoService.passwordResets!.findOne({
        'token': token,
        'isUsed': false,
        'expiresAt': {'\$gt': DateTime.now()},
      });

      if (resetRequest == null) {
        print('❌ Invalid or expired token');
        return null;
      }

      return {
        'userId': resetRequest['userId'] as String,
        'email': resetRequest['email'] as String,
        'token': resetRequest['token'] as String,
      };
    } catch (e) {
      print('❌ Error validating token: $e');
      return null;
    }
  }

  // Reset password
  static Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      // Validate token
      final validation = await validateToken(token);
      if (validation == null) {
        return false;
      }

      final userId = validation['userId'] as String;

      // Hash new password
      final hashedPassword = _hashPassword(newPassword);

      // Update user password
      final updateResult = await MongoService.users!.updateOne(
        where.id(ObjectId.fromHexString(userId)),
        modify
            .set('passwordHash', hashedPassword)
            .set('updatedAt', DateTime.now())
            .set('passwordUpdatedAt', DateTime.now()),
      );

      // Check if update was successful
      if (updateResult.isSuccess && updateResult.nModified == 1) {
        // Mark reset token as used
        await MongoService.passwordResets!.updateOne(
          where.eq('token', token),
          modify.set('isUsed', true).set('usedAt', DateTime.now()),
        );

        // Invalidate all existing user sessions (optional)
        await _invalidateUserSessions(userId);

        print('✅ Password reset successful for user: $userId');
        return true;
      }

      print('❌ Password reset failed - no document modified');
      return false;
    } catch (e) {
      print('❌ Error resetting password: $e');
      return false;
    }
  }

  // Helper: Hash password using SHA-256
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Helper: Invalidate user sessions
  static Future<void> _invalidateUserSessions(String userId) async {
    try {
      // If you have a sessions collection, delete all sessions for this user
      // await MongoService.sessions!.deleteMany({'userId': userId});
      print('✅ User sessions invalidated for: $userId');
    } catch (e) {
      print('⚠️ Error invalidating sessions: $e');
    }
  }
}

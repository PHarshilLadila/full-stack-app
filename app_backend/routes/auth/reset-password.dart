// routes/auth/reset-password.dart
// Professional UI for password reset

import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_backend/services/password_reset_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;

  if (method == HttpMethod.get) {
    return _showResetForm(context);
  }

  if (method == HttpMethod.post) {
    return _processResetPassword(context);
  }

  return Response.json(
    statusCode: 405,
    body: {'success': false, 'message': 'Method not allowed'},
  );
}

Future<Response> _showResetForm(RequestContext context) async {
  try {
    final uri = context.request.uri;
    final token = uri.queryParameters['token'] ?? '';

    final validation = await PasswordResetService.validateToken(token);

    if (validation == null) {
      return Response(
        statusCode: 200,
        body: '''
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Invalid Reset Link - E-Shop</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                body {
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    background: #f5f5f5;
                    min-height: 100vh;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    padding: 20px;
                }
                .card {
                    background: white;
                    border-radius: 16px;
                    padding: 48px;
                    max-width: 500px;
                    width: 100%;
                    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                    text-align: center;
                }
                .icon {
                    width: 64px;
                    height: 64px;
                    background: #fee2e2;
                    border-radius: 32px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 24px;
                }
                .icon span {
                    font-size: 32px;
                }
                h1 {
                    font-size: 24px;
                    font-weight: 600;
                    color: #1a1a1a;
                    margin-bottom: 12px;
                }
                p {
                    color: #666;
                    line-height: 1.6;
                    margin-bottom: 32px;
                }
                .btn {
                    display: inline-block;
                    background: #1a1a1a;
                    color: white;
                    padding: 12px 24px;
                    text-decoration: none;
                    border-radius: 8px;
                    font-weight: 500;
                    transition: background 0.2s;
                }
                .btn:hover {
                    background: #333;
                }
            </style>
        </head>
        <body>
            <div class="card">
                <div class="icon">
                    <span>🔒</span>
                </div>
                <h1>Invalid Reset Link</h1>
                <p>This password reset link is invalid or has already been used. Please request a new reset link.</p>
                <a href="/auth/login" class="btn">Back to Login</a>
            </div>
        </body>
        </html>
        ''',
        headers: {'Content-Type': 'text/html'},
      );
    }

    final email = validation['email'] as String;

    return Response(
      statusCode: 200,
      body: '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Reset Password - E-Shop</title>
          <style>
              * {
                  margin: 0;
                  padding: 0;
                  box-sizing: border-box;
              }
              body {
                  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                  background: #f5f5f5;
                  min-height: 100vh;
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  padding: 20px;
              }
              .container {
                  max-width: 450px;
                  width: 100%;
              }
              .card {
                  background: white;
                  border-radius: 16px;
                  padding: 40px;
                  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
              }
              .logo {
                  text-align: center;
                  margin-bottom: 32px;
              }
              .logo h1 {
                  font-size: 24px;
                  font-weight: 600;
                  color: #1a1a1a;
              }
              .logo p {
                  color: #666;
                  font-size: 14px;
                  margin-top: 8px;
              }
              .email-badge {
                  background: #f0f0f0;
                  padding: 12px;
                  border-radius: 8px;
                  text-align: center;
                  margin-bottom: 32px;
              }
              .email-badge span {
                  color: #1a1a1a;
                  font-weight: 500;
              }
              .form-group {
                  margin-bottom: 24px;
              }
              label {
                  display: block;
                  margin-bottom: 8px;
                  font-weight: 500;
                  color: #1a1a1a;
                  font-size: 14px;
              }
              input {
                  width: 100%;
                  padding: 12px 16px;
                  border: 1px solid #e0e0e0;
                  border-radius: 8px;
                  font-size: 16px;
                  transition: border-color 0.2s, box-shadow 0.2s;
                  font-family: inherit;
              }
              input:focus {
                  outline: none;
                  border-color: #1a1a1a;
                  box-shadow: 0 0 0 3px rgba(26,26,26,0.1);
              }
              .requirements {
                  font-size: 12px;
                  color: #999;
                  margin-top: 6px;
              }
              .error {
                  color: #dc2626;
                  font-size: 13px;
                  margin-top: 6px;
                  display: none;
              }
              .btn {
                  width: 100%;
                  padding: 14px;
                  background: #1a1a1a;
                  color: white;
                  border: none;
                  border-radius: 8px;
                  font-size: 16px;
                  font-weight: 500;
                  cursor: pointer;
                  transition: background 0.2s;
                  font-family: inherit;
              }
              .btn:hover {
                  background: #333;
              }
              .btn:disabled {
                  background: #ccc;
                  cursor: not-allowed;
              }
              .loading {
                  display: none;
                  text-align: center;
                  margin-top: 24px;
              }
              .spinner {
                  width: 32px;
                  height: 32px;
                  border: 3px solid #f0f0f0;
                  border-top: 3px solid #1a1a1a;
                  border-radius: 50%;
                  animation: spin 0.8s linear infinite;
                  margin: 0 auto 12px;
              }
              @keyframes spin {
                  0% { transform: rotate(0deg); }
                  100% { transform: rotate(360deg); }
              }
              .footer {
                  text-align: center;
                  margin-top: 24px;
                  font-size: 12px;
                  color: #999;
              }
              .success-card {
                  background: white;
                  border-radius: 16px;
                  padding: 48px;
                  text-align: center;
                  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
              }
              .success-icon {
                  width: 64px;
                  height: 64px;
                  background: #e6f7e6;
                  border-radius: 32px;
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  margin: 0 auto 24px;
              }
              .success-icon span {
                  font-size: 32px;
              }
              .success-card h2 {
                  font-size: 24px;
                  font-weight: 600;
                  color: #1a1a1a;
                  margin-bottom: 12px;
              }
              .success-card p {
                  color: #666;
                  margin-bottom: 32px;
                  line-height: 1.6;
              }
          </style>
      </head>
      <body>
          <div class="container">
              <div class="card" id="resetCard">
                  <div class="logo">
                      <h1>E-Shop</h1>
                      <p>Reset your password</p>
                  </div>
                  
                  <div class="email-badge">
                      <span>$email</span>
                  </div>
                  
                  <form id="resetForm">
                      <div class="form-group">
                          <label>New Password</label>
                          <input type="password" id="newPassword" placeholder="Enter new password" required>
                          <div class="requirements">• Minimum 6 characters</div>
                          <div class="error" id="passwordError"></div>
                      </div>
                      
                      <div class="form-group">
                          <label>Confirm New Password</label>
                          <input type="password" id="confirmPassword" placeholder="Confirm new password" required>
                          <div class="error" id="confirmError"></div>
                      </div>
                      
                      <button type="submit" class="btn" id="submitBtn">Reset Password</button>
                  </form>
                  
                  <div class="loading" id="loading">
                      <div class="spinner"></div>
                      <p>Resetting password...</p>
                  </div>
                  
                  <div class="footer">
                      <p>Secure password reset</p>
                  </div>
              </div>
          </div>
          
          <script>
              const form = document.getElementById('resetForm');
              const newPassword = document.getElementById('newPassword');
              const confirmPassword = document.getElementById('confirmPassword');
              const passwordError = document.getElementById('passwordError');
              const confirmError = document.getElementById('confirmError');
              const submitBtn = document.getElementById('submitBtn');
              const loading = document.getElementById('loading');
              const resetCard = document.getElementById('resetCard');
              
              form.addEventListener('submit', async (e) => {
                  e.preventDefault();
                  
                  // Reset errors
                  passwordError.style.display = 'none';
                  confirmError.style.display = 'none';
                  
                  // Validation
                  let isValid = true;
                  
                  if (newPassword.value.length < 6) {
                      passwordError.textContent = 'Password must be at least 6 characters';
                      passwordError.style.display = 'block';
                      isValid = false;
                  }
                  
                  if (newPassword.value !== confirmPassword.value) {
                      confirmError.textContent = 'Passwords do not match';
                      confirmError.style.display = 'block';
                      isValid = false;
                  }
                  
                  if (!isValid) return;
                  
                  // Show loading
                  submitBtn.disabled = true;
                  loading.style.display = 'block';
                  form.style.display = 'none';
                  
                  try {
                      const response = await fetch(window.location.href, {
                          method: 'POST',
                          headers: {
                              'Content-Type': 'application/json',
                          },
                          body: JSON.stringify({
                              token: '$token',
                              newPassword: newPassword.value,
                              confirmPassword: confirmPassword.value,
                          }),
                      });
                      
                      const result = await response.json();
                      
                      if (result.success) {
                          // Show success message
                          resetCard.innerHTML = \`
                              <div class="success-card">
                                  <div class="success-icon">
                                      <span>✓</span>
                                  </div>
                                  <h2>Password Reset Successful</h2>
                                  <p>\${result.message}</p>
                                  <a href="/auth/login" class="btn" style="display: inline-block; text-decoration: none;">Back to Login</a>
                              </div>
                          \`;
                      } else {
                          alert(result.message);
                          submitBtn.disabled = false;
                          loading.style.display = 'none';
                          form.style.display = 'block';
                      }
                  } catch (error) {
                      alert('Something went wrong. Please try again.');
                      submitBtn.disabled = false;
                      loading.style.display = 'none';
                      form.style.display = 'block';
                  }
              });
          </script>
      </body>
      </html>
      ''',
      headers: {'Content-Type': 'text/html'},
    );
  } catch (e) {
    print('❌ Error showing reset form: $e');
    return Response(
      statusCode: 200,
      body: '''
      <!DOCTYPE html>
      <html>
      <head>
          <title>Error - E-Shop</title>
          <style>
              * { margin: 0; padding: 0; box-sizing: border-box; }
              body {
                  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                  background: #f5f5f5;
                  min-height: 100vh;
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  padding: 20px;
              }
              .card {
                  background: white;
                  border-radius: 16px;
                  padding: 48px;
                  max-width: 450px;
                  text-align: center;
                  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
              }
              h2 { margin-bottom: 16px; color: #1a1a1a; }
              p { color: #666; margin-bottom: 24px; }
              .btn {
                  display: inline-block;
                  background: #1a1a1a;
                  color: white;
                  padding: 12px 24px;
                  text-decoration: none;
                  border-radius: 8px;
              }
          </style>
      </head>
      <body>
          <div class="card">
              <h2>Something went wrong</h2>
              <p>Please try again or request a new reset link.</p>
              <a href="/auth/login" class="btn">Back to Login</a>
          </div>
      </body>
      </html>
      ''',
      headers: {'Content-Type': 'text/html'},
    );
  }
}

Future<Response> _processResetPassword(RequestContext context) async {
  try {
    print('🔥 RESET PASSWORD API HIT');

    final bodyString = await context.request.body();

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

    final token = body['token']?.toString().trim() ?? '';
    final newPassword = body['newPassword']?.toString().trim() ?? '';
    final confirmPassword = body['confirmPassword']?.toString().trim() ?? '';

    if (token.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Reset token is required'},
      );
    }

    if (newPassword.isEmpty) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'New password is required'},
      );
    }

    if (newPassword.length < 6) {
      return Response.json(
        statusCode: 400,
        body: {
          'success': false,
          'message': 'Password must be at least 6 characters long',
        },
      );
    }

    if (newPassword != confirmPassword) {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Passwords do not match'},
      );
    }

    final resetSuccess = await PasswordResetService.resetPassword(
      token: token,
      newPassword: newPassword,
    );

    if (resetSuccess) {
      return Response.json(
        statusCode: 200,
        body: {
          'success': true,
          'message': 'Your password has been changed successfully.',
        },
      );
    } else {
      return Response.json(
        statusCode: 400,
        body: {'success': false, 'message': 'Invalid or expired reset token.'},
      );
    }
  } catch (e, stackTrace) {
    print('❌ RESET PASSWORD ERROR: $e');
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

// ignore_for_file: use_build_context_synchronously

import 'package:app_frontend_customer/features/auth/bloc/auth_bloc.dart';
import 'package:app_frontend_customer/features/auth/bloc/auth_event.dart';
import 'package:app_frontend_customer/features/auth/bloc/auth_state.dart';
import 'package:app_frontend_customer/features/auth/model/login_model.dart';
import 'package:app_frontend_customer/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onToggleToRegister;
  const LoginForm({super.key, required this.onToggleToRegister});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess && !state.isRegistration) {
          // Only navigate for login success, not for registration
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else if (state is AuthSuccess && state.isRegistration) {
          // Registration success - stay on auth screen, show message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          // Clear form fields
          emailController.clear();
          passwordController.clear();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Email/Username/Mobile Field
              AppTextField(
                controller: emailController,
                hintText: 'Email / Username / Mobile',
                hugeIcon: HugeIcons.strokeRoundedMail01,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email/Username/Mobile required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password Field
              AppTextField(
                controller: passwordController,
                hintText: 'Password',
                hugeIcon: HugeIcons.strokeRoundedLockPassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reset password link sent!'),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationColor: Colors.black,
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      state is AuthLoading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              final model = LoginModel(
                                identifier: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              context.read<AuthBloc>().add(LoginEvent(model));
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      state is AuthLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black87,
                            ),
                          )
                          : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 24),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New to Velmora? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: widget.onToggleToRegister,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:app_frontend/features/auth/bloc/auth_bloc.dart';
import 'package:app_frontend/features/auth/bloc/auth_event.dart';
import 'package:app_frontend/features/auth/bloc/auth_state.dart';
import 'package:app_frontend/features/auth/model/register_model.dart';
import 'package:app_frontend/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onToggleToLogin;
  const RegisterForm({super.key, required this.onToggleToLogin});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
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
              // Full Name
              AppTextField(
                controller: fullNameController,
                hintText: "Full Name",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Full Name required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Username
              AppTextField(
                controller: usernameController,
                hintText: "Username",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email
              AppTextField(
                controller: emailController,
                hintText: "Email Address",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Mobile
              AppTextField(
                controller: mobileController,
                hintText: "Mobile Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile Number required';
                  }
                  if (value.length != 10) {
                    return 'Enter valid mobile (10 digits)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password
              AppTextField(
                controller: passwordController,
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Confirm Password
              AppTextField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Password required';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Terms Checkbox
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged:
                          (value) =>
                              setState(() => _agreeToTerms = value ?? false),
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Color(0xFFFFD700);
                        }
                        return Colors.transparent;
                      }),
                      checkColor: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => setState(() => _agreeToTerms = !_agreeToTerms),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            const TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            const TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _agreeToTerms && state is! AuthLoading
                          ? () {
                            if (_formKey.currentState!.validate()) {
                              final model = RegisterModel(
                                fullName: fullNameController.text.trim(),
                                username: usernameController.text.trim(),
                                email: emailController.text.trim(),
                                mobile: mobileController.text.trim(),
                                password: passwordController.text.trim(),
                                confirmPassword:
                                    confirmPasswordController.text.trim(),
                              );
                              context.read<AuthBloc>().add(
                                RegisterEvent(model),
                              );
                            }
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    disabledBackgroundColor: Colors.grey.shade600,
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
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: widget.onToggleToLogin,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.w600,
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
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

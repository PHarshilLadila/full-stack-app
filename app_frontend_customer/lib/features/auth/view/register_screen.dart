// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app_frontend_customer/features/auth/bloc/auth_bloc.dart';
import 'package:app_frontend_customer/features/auth/bloc/auth_event.dart';
import 'package:app_frontend_customer/features/auth/bloc/auth_state.dart';
import 'package:app_frontend_customer/features/auth/model/register_model.dart';
import 'package:app_frontend_customer/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

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

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess && state.isRegistration) {
          // Registration success - show message and switch to login mode
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );

          // Clear all form fields
          fullNameController.clear();
          usernameController.clear();
          emailController.clear();
          mobileController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          setState(() {
            _agreeToTerms = false;
            _profileImage = null;
          });

          // Switch to login mode
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              widget.onToggleToLogin();
            }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                    child:
                        _profileImage == null
                            ? const Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.black54,
                            )
                            : null,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Full Name"),
              const SizedBox(height: 4),

              // Full Name
              AppTextField(
                controller: fullNameController,
                hintText: "Full Name",
                hugeIcon: HugeIcons.strokeRoundedUser03,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Full Name required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),
              const Text("User Name"),
              const SizedBox(height: 4),
              // Username
              AppTextField(
                controller: usernameController,
                hintText: "Username",
                hugeIcon: HugeIcons.strokeRoundedUserMinus01,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username required";
                  }
                  if (value.length < 3) {
                    return "Username must be at least 3 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),
              const Text("Email"),
              const SizedBox(height: 4),
              // Email
              AppTextField(
                controller: emailController,
                hintText: "Email Address",
                hugeIcon: HugeIcons.strokeRoundedMail01,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email required';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),
              const Text("Mobile Number"),
              const SizedBox(height: 4),
              // Mobile
              AppTextField(
                controller: mobileController,
                hintText: "Mobile Number",
                hugeIcon: HugeIcons.strokeRoundedAiPhone01,
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

              const SizedBox(height: 12),
              const Text("Password"),
              const SizedBox(height: 4),

              // Password
              AppTextField(
                controller: passwordController,
                hintText: "Password",
                hugeIcon: HugeIcons.strokeRoundedCirclePassword,
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

              const SizedBox(height: 12),

              const Text("Confirm Password"),
              const SizedBox(height: 4),

              // Confirm Password
              AppTextField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                hugeIcon: HugeIcons.strokeRoundedPasswordValidation,
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

              const SizedBox(height: 24),

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
                          return Colors.lightGreenAccent;
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
                                profileImage: _profileImage,
                                fullName: fullNameController.text.trim(),
                                username: usernameController.text.trim(),
                                email: emailController.text.trim(),
                                mobile: mobileController.text.trim(),
                                password: passwordController.text.trim(),
                                confirmPassword:
                                    confirmPasswordController.text.trim(),
                                role: "customer",
                              );
                              context.read<AuthBloc>().add(
                                RegisterEvent(model),
                              );
                            }
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                        color: Colors.black,
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

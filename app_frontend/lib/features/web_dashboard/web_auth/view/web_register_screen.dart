// lib/features/auth/web_register_screen.dart
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_frontend/features/auth/bloc/auth_bloc.dart';
import 'package:app_frontend/features/auth/bloc/auth_event.dart';
import 'package:app_frontend/features/auth/bloc/auth_state.dart';
import 'package:app_frontend/features/auth/model/register_model.dart';
import 'package:app_frontend/utils/responsive.dart';

class WebRegisterForm extends StatefulWidget {
  final VoidCallback onToggleToLogin;
  const WebRegisterForm({super.key, required this.onToggleToLogin});

  @override
  State<WebRegisterForm> createState() => _WebRegisterFormState();
}

class _WebRegisterFormState extends State<WebRegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSellerBadge(),
              const SizedBox(height: 24),
              // Responsive Field Layout
              if (r.isDesktop) _buildDesktopFields() else _buildMobileFields(),
              const SizedBox(height: 20),
              _buildTerms(),
              const SizedBox(height: 24),
              _buildButton(isLoading),
              const SizedBox(height: 20),
              _buildLoginLink(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSellerBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF7C3AED).withOpacity(0.08), const Color(0xFFA855F7).withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storefront_rounded, color: Color(0xFF7C3AED), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seller Account Registration',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7C3AED)),
                ),
                SizedBox(height: 2),
                Text(
                  'You will be registered as a seller',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildFullNameField()),
            const SizedBox(width: 16),
            Expanded(child: _buildUsernameField()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildEmailField()),
            const SizedBox(width: 16),
            Expanded(child: _buildMobileField()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPasswordField()),
            const SizedBox(width: 16),
            Expanded(child: _buildConfirmPasswordField()),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFullNameField(),
        const SizedBox(height: 16),
        _buildUsernameField(),
        const SizedBox(height: 16),
        _buildEmailField(),
        const SizedBox(height: 16),
        _buildMobileField(),
        const SizedBox(height: 16),
        _buildPasswordField(),
        const SizedBox(height: 16),
        _buildConfirmPasswordField(),
      ],
    );
  }

  Widget _buildFullNameField() {
    return _buildField(
      label: "Full Name",
      controller: _fullNameController,
      hint: "John Doe",
      icon: Icons.person_outline,
      validator: (v) => v == null || v.isEmpty ? "Full name is required" : null,
    );
  }

  Widget _buildUsernameField() {
    return _buildField(
      label: "Username",
      controller: _usernameController,
      hint: "john_doe",
      icon: Icons.alternate_email,
      validator: (v) => v == null || v.isEmpty ? "Username is required" : null,
    );
  }

  Widget _buildEmailField() {
    return _buildField(
      label: "Email Address",
      controller: _emailController,
      hint: "seller@example.com",
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (v) {
        if (v == null || v.isEmpty) return "Email is required";
        if (!v.contains("@") || !v.contains(".")) return "Enter a valid email";
        return null;
      },
    );
  }

  Widget _buildMobileField() {
    return _buildField(
      label: "Mobile Number",
      controller: _mobileController,
      hint: "9876543210",
      icon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      validator: (v) {
        if (v == null || v.isEmpty) return "Mobile number is required";
        if (v.length != 10) return "Enter a valid 10-digit number";
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildField(
      label: "Password",
      controller: _passwordController,
      hint: "Create a strong password",
      icon: Icons.lock_outline,
      obscureText: !_isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, size: 20),
        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "Password is required";
        if (v.length < 6) return "Password must be at least 6 characters";
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildField(
      label: "Confirm Password",
      controller: _confirmPasswordController,
      hint: "Confirm your password",
      icon: Icons.lock_outline,
      obscureText: !_isConfirmPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility, size: 20),
        onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "Please confirm your password";
        if (v != _passwordController.text) return "Passwords do not match";
        return null;
      },
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildTerms() {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
            activeColor: const Color(0xFF7C3AED),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w500),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading || !_agreeToTerms
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  final registerModel = RegisterModel(
                    fullName: _fullNameController.text.trim(),
                    username: _usernameController.text.trim(),
                    email: _emailController.text.trim(),
                    mobile: _mobileController.text.trim(),
                    password: _passwordController.text.trim(),
                    confirmPassword: _confirmPasswordController.text.trim(),
                    role: "seller",
                  );
                  context.read<AuthBloc>().add(RegisterEvent(registerModel));
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
          elevation: 0,
          disabledBackgroundColor: const Color(0xFFC4B5FD),
        ),
        child: isLoading
            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Text('Create Seller Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ", style: TextStyle(color: Colors.grey[600])),
        GestureDetector(
          onTap: widget.onToggleToLogin,
          child: const Text(
            'Sign in',
            style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
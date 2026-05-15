// lib/features/auth/web_auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_frontend/features/auth/bloc/auth_bloc.dart';
import 'package:app_frontend/features/auth/service/auth_service.dart';
import 'package:app_frontend/utils/responsive.dart';
import 'web_login_screen.dart';
import 'web_register_screen.dart';

class WebAuthScreen extends StatefulWidget {
  const WebAuthScreen({super.key});

  @override
  State<WebAuthScreen> createState() => _WebAuthScreenState();
}

class _WebAuthScreenState extends State<WebAuthScreen> {
  bool _isLoginMode = true;

  void _toggleMode(bool isLogin) {
    setState(() {
      _isLoginMode = isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return BlocProvider(
      create: (_) => AuthBloc(AuthService()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(r.isMobileSmall ? 16 : 24),
              child:
                  r.isDesktop ? _buildDesktopLayout(r) : _buildMobileLayout(r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(Responsive r) {
    return Container(
      width: r.containerWidth,
      constraints: const BoxConstraints(maxWidth: 1200, minWidth: 800),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // LEFT SIDE - Branding Section
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(32),
          //       bottomLeft: Radius.circular(32),
          //     ),
          //   ),
          //   child: const Center(
          //     child: Padding(
          //       padding: EdgeInsets.all(32.0),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Icon(
          //             Icons.storefront_rounded,
          //             size: 64,
          //             color: Colors.white,
          //           ),
          //           SizedBox(height: 24),
          //           Text(
          //             "Velmora",
          //             style: TextStyle(
          //               fontSize: 36,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.white,
          //             ),
          //           ),
          //           SizedBox(height: 12),
          //           Text(
          //             "Seller Dashboard",
          //             style: TextStyle(fontSize: 18, color: Colors.white70),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // RIGHT SIDE - Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(r.containerPadding),
              child: _buildForm(r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(Responsive r) {
    return Container(
      width: r.containerWidth,
      constraints: const BoxConstraints(maxWidth: 520),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(r.containerPadding),
        child: _buildForm(r),
      ),
    );
  }

  Widget _buildForm(Responsive r) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Velmora",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        // Title
        Text(
          _isLoginMode ? "Welcome back" : "Create account",
          style: TextStyle(
            fontSize: r.titleSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isLoginMode
              ? "Sign in to access your seller dashboard"
              : "Join as a seller and start selling today",
          style: TextStyle(fontSize: r.bodySize, color: Colors.grey[600]),
        ),
        const SizedBox(height: 28),
        // Toggle Buttons
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggleMode(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isLoginMode ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow:
                          _isLoginMode
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                ),
                              ]
                              : null,
                    ),
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color:
                              _isLoginMode
                                  ? const Color(0xFF7C3AED)
                                  : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggleMode(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_isLoginMode ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow:
                          !_isLoginMode
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                ),
                              ]
                              : null,
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color:
                              !_isLoginMode
                                  ? const Color(0xFF7C3AED)
                                  : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Dynamic Form
        _isLoginMode
            ? WebLoginForm(onToggleToRegister: () => _toggleMode(false))
            : WebRegisterForm(onToggleToLogin: () => _toggleMode(true)),
      ],
    );
  }
}

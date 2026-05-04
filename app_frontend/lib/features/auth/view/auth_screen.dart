import 'dart:ui';
import 'dart:ui' as ui;

import 'package:app_frontend/features/auth/bloc/auth_bloc.dart';
import 'package:app_frontend/features/auth/service/auth_service.dart';
import 'package:app_frontend/features/auth/view/login_screen.dart';
import 'package:app_frontend/features/auth/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginMode = true; // true = Login, false = Register

  void toggleMode(bool isLoginMode) {
    setState(() {
      _isLoginMode = isLoginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthService()),
      child: Scaffold(
        backgroundColor: Colors.white,  
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 200,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.transparent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(60),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.09),
                          blurRadius: 80,
                          spreadRadius: 80,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 200,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.transparent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.07),
                          blurRadius: 50,
                          spreadRadius: 40,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 200,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.transparent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.04),
                          blurRadius: 80,
                          spreadRadius: 80,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Dynamic Header
                      if (_isLoginMode) ...[
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Icon(
                                Icons.person_2,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: const Text(
                            'Welcome Back, Driver',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Center(
                          child: const Text(
                            'Ready to hit the road? Sign in to start accepting rides and earning.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54, // ✅ changed
                              height: 1.4,
                            ),
                          ),
                        ),
                      ] else ...[
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Icon(
                                Icons.electric_rickshaw,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        Center(
                          child: const Text(
                            'Join the Fleet',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: const Text(
                              'Create your driver account and start earning on your own schedule.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54, // ✅ changed
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 36),

                      // Toggle Buttons
                      // Container(
                      //   padding: EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,

                      //     borderRadius: BorderRadius.circular(100),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             toggleMode(true);
                      //           },
                      //           child: Container(
                      //             padding: const EdgeInsets.symmetric(
                      //               vertical: 12,
                      //             ),
                      //             decoration: BoxDecoration(
                      //               color:
                      //                   _isLoginMode
                      //                       ? Colors.white
                      //                       : Colors.white,
                      //               borderRadius: BorderRadius.circular(30),
                      //               border: Border.all(
                      //                 color:
                      //                     _isLoginMode
                      //                         ? Colors.black12
                      //                         : Colors.white,
                      //               ),
                      //             ),
                      //             child: Center(
                      //               child: Text(
                      //                 'Sign In',
                      //                 style: TextStyle(
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w600,
                      //                   color:
                      //                       _isLoginMode
                      //                           ? Colors.black
                      //                           : Colors.black,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(width: 12),
                      //       Expanded(
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             toggleMode(false);
                      //           },
                      //           child: Container(
                      //             padding: const EdgeInsets.symmetric(
                      //               vertical: 12,
                      //             ),
                      //             decoration: BoxDecoration(
                      //               color:
                      //                   !_isLoginMode
                      //                       ? Colors.white
                      //                       : Colors.white,
                      //               borderRadius: BorderRadius.circular(30),
                      //               border: Border.all(
                      //                 color:
                      //                     !_isLoginMode
                      //                         ? Colors.black12
                      //                         : Colors.white,
                      //               ),
                      //             ),
                      //             child: Center(
                      //               child: Text(
                      //                 'Sign Up',
                      //                 style: TextStyle(
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w600,
                      //                   color:
                      //                       !_isLoginMode
                      //                           ? Colors.black
                      //                           : Colors.black,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.withOpacity(0.06),
                        ),
                        child: Stack(
                          children: [
                            // 🔥 MOVING BACKGROUND
                            AnimatedAlign(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              alignment:
                                  _isLoginMode
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),

                            // 🔘 FULL CLICKABLE AREA (SIGN IN)
                            Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () => toggleMode(true),
                                      child: Container(
                                        height: 45,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // 🔘 FULL CLICKABLE AREA (SIGN UP)
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () => toggleMode(false),
                                      child: Container(
                                        height: 45,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Forms
                      Expanded(
                        child:
                            _isLoginMode
                                ? LoginForm(
                                  onToggleToRegister: () => toggleMode(false),
                                )
                                : RegisterForm(
                                  onToggleToLogin: () => toggleMode(true),
                                ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlurContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget? child;
  final double blur;

  const BlurContainer({
    super.key,
    this.height = 60,
    this.width = 60,
    this.child,
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15), // glass effect
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

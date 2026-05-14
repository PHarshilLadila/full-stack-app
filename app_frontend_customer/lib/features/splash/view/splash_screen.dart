// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = SplashBloc();
    _splashBloc.add(CheckAuthStatus());
  }

  @override
  void dispose() {
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _splashBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // User is logged in - navigate to home (bottom navigation)
              log("User authenticated - Navigating to Home");
              log("User Role: ${state.userRole}");
              log("User ID: ${state.userId}");
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is Unauthenticated) {
              // User not logged in - navigate to auth screen
              log("User not authenticated - Navigating to Auth Screen");
              Navigator.pushReplacementNamed(context, '/auth');
            } else if (state is SplashApiError) {
              // API error but still check auth
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('API Error: ${state.error}'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 2),
                ),
              );
              // Still check auth status after API error
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  // Re-check auth status
                  _splashBloc.add(CheckAuthStatus());
                }
              });
            }
          },
          child: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              return Stack(
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
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedShoppingBag02,
                            color: Colors.black,
                            size: 60.0,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Shopping With Velmora',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Your Trusted Shopping Destination',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 40),
                        if (state is SplashLoading || state is SplashInitial)
                          const CircularProgressIndicator(color: Colors.amber),
                        if (state is SplashApiError)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              '⚠️ ${state.error}',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

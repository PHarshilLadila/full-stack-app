// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              // Navigate based on role
              if (state.role == 'seller') {
                log("Navigating to Seller Dashboard");
                // Navigate to home which will handle role-based screens
                Navigator.pushReplacementNamed(context, '/home');
              } else if (state.role == 'customer') {
                log("Navigating to Customer Dashboard");
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                // Default to home
                Navigator.pushReplacementNamed(context, '/home');
              }
            } else if (state is Unauthenticated) {
              Navigator.pushReplacementNamed(context, '/auth');
            } else if (state is SplashApiError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('API Error: ${state.error}'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 2),
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/auth');
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
                          child: const Icon(
                            Icons.electric_rickshaw,
                            size: 60,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Driver Fleet',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Your Ride, Your Earnings',
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

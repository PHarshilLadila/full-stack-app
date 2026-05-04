import 'package:flutter/material.dart';
import 'package:app_frontend/features/auth/view/auth_screen.dart';
import 'package:app_frontend/features/home/view/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Fleet App',
      debugShowCheckedModeBanner: false,

      // ✅ GLOBAL NUNITO FONT
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),

        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
      ),

      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app_frontend/features/auth/view/auth_screen.dart';
import 'package:app_frontend/features/home/view/home_screen.dart';
import 'package:app_frontend/features/home/bloc/user_bloc.dart';
import 'package:app_frontend/features/home/service/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc(userService: UserService())),
      ],
      child: MaterialApp(
        title: 'Driver Fleet App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
        ),
        initialRoute: '/auth',
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:app_frontend/features/bottom_navbar/view/bottom_navbar_screen.dart';
import 'package:app_frontend/features/customer/home/bloc/product_bloc.dart';
import 'package:app_frontend/features/customer/home/service/product_service.dart';
import 'package:app_frontend/features/web_dashboard/web_auth/view/web_auth_screen.dart';
import 'package:app_frontend/features/web_dashboard/web_dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_frontend/features/auth/view/auth_screen.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:app_frontend/features/splash/view/splash_screen.dart';
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
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(
          create: (context) => ProductBloc(productService: ProductService()),
        ),
      ],
      child: MaterialApp(
        title: 'Velmora Vendor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          textTheme:
              kIsWeb
                  ? GoogleFonts.interTextTheme(ThemeData.light().textTheme)
                  : GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: false,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/auth': (context) => isSkiaWeb ? WebAuthScreen() : AuthScreen(),
          '/home':
              (context) =>
                  isSkiaWeb ? WebDashboardScreen() : BottomNavBarScreen(),
        },
      ),
    );
  }
}

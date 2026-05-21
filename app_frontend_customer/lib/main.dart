import 'package:app_frontend_customer/features/auth/view/auth_screen.dart';
import 'package:app_frontend_customer/features/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:app_frontend_customer/features/bottom_navbar/view/bottom_navbar_screen.dart';
import 'package:app_frontend_customer/features/customer/favorite/bloc/favorites_bloc.dart';
import 'package:app_frontend_customer/features/customer/favorite/service/favorites_service.dart';
import 'package:app_frontend_customer/features/customer/home/bloc/product_bloc.dart';
import 'package:app_frontend_customer/features/customer/home/service/product_service.dart';
import 'package:app_frontend_customer/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend_customer/features/customer/profile/service/user_service.dart';
import 'package:app_frontend_customer/features/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';
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
        BlocProvider(
          create:
              (context) => FavoritesBloc(favoritesService: FavoritesService()),
        ),
      ],
      child: MaterialApp(
        title: 'Velmora Shopping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreenAccent,
            primary: Colors.lightGreenAccent,
          ),
          primaryColor: Colors.lightGreenAccent,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.nunitoTextTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.lightGreenAccent,
            foregroundColor: Colors.white,
          ),
          useMaterial3: false,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const BottomNavBarScreen(),
        },
      ),
    );
  }
}

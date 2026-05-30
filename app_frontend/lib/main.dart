import 'package:app_frontend/features/analytics/bloc/analytics_bloc.dart';
import 'package:app_frontend/features/seller/home/bloc/product_bloc.dart';
import 'package:app_frontend/features/seller/home/service/product_service.dart';
import 'package:app_frontend/features/seller/seller_profile/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/seller/seller_profile/profile/service/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_frontend/features/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:app_frontend/features/bottom_navbar/view/bottom_navbar_screen.dart';
import 'package:app_frontend/features/web_dashboard/order/bloc/seller_order_bloc.dart';
import 'package:app_frontend/features/web_dashboard/order/service/seller_order_service.dart';
import 'package:app_frontend/features/web_dashboard/web_auth/view/web_auth_screen.dart';
import 'package:app_frontend/features/web_dashboard/web_dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/service/auth_service.dart';
import 'features/auth/view/auth_screen.dart';
import 'features/splash/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options:
        kIsWeb
            ? const FirebaseOptions(
              apiKey: "AIzaSyCT7twkCGudSOiePsgsSlsDZgWKHT3gxG8",
              authDomain: "full-stack-app-92e61.firebaseapp.com",
              projectId: "full-stack-app-92e61",
              storageBucket: "full-stack-app-92e61.firebasestorage.app",
              messagingSenderId: "33258933921",
              appId: "1:33258933921:web:ebf26cb174cc3f4f7ceae0",
              measurementId: "G-ZEBW21S3KF",
            )
            : null,
  );

  // Initialize FCM for Seller
  // await FCMNotificationService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthService())),
        BlocProvider(create: (context) => UserBloc(userService: UserService())),
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(
          create: (context) => ProductBloc(productService: ProductService()),
        ),
        BlocProvider(
          create:
              (context) => SellerOrderBloc(orderService: SellerOrderService()),
        ),
        BlocProvider(create: (context) => AnalyticsBloc()),
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
          '/auth':
              (context) => kIsWeb ? const WebAuthScreen() : const AuthScreen(),
          '/home':
              (context) =>
                  kIsWeb ? WebDashboardScreen() : const BottomNavBarScreen(),
        },
      ),
    );
  }
}

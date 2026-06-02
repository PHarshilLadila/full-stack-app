// main.dart
import 'package:app_frontend_customer/features/auth/view/auth_screen.dart';
import 'package:app_frontend_customer/features/customer/reviews/bloc/review_bloc.dart';
import 'package:app_frontend_customer/features/customer/reviews/service/review_service.dart';
import 'package:app_frontend_customer/service/fcm_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'features/bottom_navbar/view/bottom_navbar_screen.dart';
import 'features/customer/address/bloc/address_bloc.dart';
import 'features/customer/address/service/address_service.dart';
import 'features/customer/cart/bloc/cart_bloc.dart';
import 'features/customer/cart/service/cart_service.dart';
import 'features/customer/checkout/bloc/checkout_bloc.dart';
import 'features/customer/checkout/service/checkout_service.dart';
import 'features/customer/favorite/bloc/favorites_bloc.dart';
import 'features/customer/favorite/service/favorites_service.dart';
import 'features/customer/home/bloc/product_bloc.dart';
import 'features/customer/home/service/product_service.dart';
import 'features/customer/order/bloc/order_bloc.dart';
import 'features/customer/order/service/order_service.dart';
import 'features/customer/profile/bloc/user_bloc.dart';
import 'features/customer/profile/service/user_service.dart';
import 'features/splash/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize FCM Notifications
  await FCMNotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = "";

  void getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userToken = preferences.getString("auth_token") ?? "";
    setState(() {
      token = userToken;
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

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
        BlocProvider(create: (context) => CartBloc(cartService: CartService())),
        BlocProvider(
          create: (context) => AddressBloc(addressService: AddressService()),
        ),
        BlocProvider(
          create:
              (context) => OrderBloc(orderService: OrderService(token: token)),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(checkoutService: CheckoutService()),
        ),
        BlocProvider(
          create: (context) => ReviewBloc(reviewService: ReviewService()),
        ),
      ],
      child: MaterialApp(
        title: 'Velmora Shopping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            primary: Colors.lightGreenAccent,
          ),
          primaryColor: Colors.amber,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.nunitoTextTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.amber,
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

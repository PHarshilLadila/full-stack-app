// lib/features/customer/customer_web/customer_home_screen.dart (Updated)
import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/velmora_appbar.dart';
import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/velmora_footer.dart';
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/bloc/categories/categories_bloc.dart';
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/bloc/categories/categories_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/best_sellers_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/featured_products_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/flash_deal_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/home_hero_banner.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/promo_banner_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/recently_viewed_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/shop_categories_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/trending_now.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ... other imports

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  CategoryBloc(customerWebService: CustomerWebService())
                    ..add(LoadCategories()),
        ),
      ],
      child: const CustomerHomeScreenContent(),
    );
  }
}

class CustomerHomeScreenContent extends StatefulWidget {
  const CustomerHomeScreenContent({super.key});

  @override
  State<CustomerHomeScreenContent> createState() =>
      _CustomerHomeScreenContentState();
}

class _CustomerHomeScreenContentState extends State<CustomerHomeScreenContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          VelmoraAppBar(scaffoldKey: _scaffoldKey),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const HeroBanner(),
                  const SizedBox(height: 40),
                  const ShopCategoriesSection(),
                  const FeaturedProductsSection(),
                  const FlashDealsSection(),
                  const TrendingNowSection(),
                  const BestSellersSection(),
                  const PromoBannerSection(),
                  const RecentlyViewedSection(),
                  const CommonFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

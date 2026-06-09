// lib/features/customer/customer_web/common_widgets/base_scaffold.dart
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/best_sellers_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/featured_products_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/flash_deal_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/home_hero_banner.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/promo_banner_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/recently_viewed_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/shop_categories_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/trending_now.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'velmora_appbar.dart';
import 'velmora_footer.dart';
import '../bloc/categories/categories_bloc.dart';
import '../bloc/categories/categories_event.dart';
import '../bloc/featured_products/featured_products_bloc.dart';
import '../bloc/featured_products/featured_products_event.dart';
import '../bloc/flash_deals/flash_deals_bloc.dart';
import '../bloc/flash_deals/flash_deals_event.dart';
import '../bloc/trending_products/trending_products_bloc.dart';
import '../bloc/trending_products/trending_products_event.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showFooter;

  const BaseScaffold({
    super.key,
    required this.child,
    this.scaffoldKey,
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          VelmoraAppBar(scaffoldKey: scaffoldKey),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [child, if (showFooter) const CommonFooter()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Main Home Screen with MultiBlocProvider
class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

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
        BlocProvider(
          create:
              (context) =>
                  FeaturedProductsBloc(customerWebService: CustomerWebService())
                    ..add(const LoadFeaturedProducts()),
        ),
        BlocProvider(
          create:
              (context) =>
                  FlashDealsBloc(customerWebService: CustomerWebService())
                    ..add(const LoadFlashDeals()),
        ),
        BlocProvider(
          create:
              (context) =>
                  TrendingProductsBloc(customerWebService: CustomerWebService())
                    ..add(const LoadTrendingProducts()),
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
    return BaseScaffold(
      scaffoldKey: _scaffoldKey,
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
        ],
      ),
    );
  }
}

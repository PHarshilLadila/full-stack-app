import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/velmora_appbar.dart';
import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/velmora_footer.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/best_sellers_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/featured_products_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/flash_deal_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/home_hero_banner.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/promo_banner_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/recently_viewed_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/shop_categories_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/trending_now.dart';
import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(), // For mobile drawer
      body: Column(
        children: [
          // Custom Appbar
          VelmoraAppBar(scaffoldKey: _scaffoldKey),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Banner
                  const HeroBanner(),
                  const SizedBox(height: 40),
                  CategorySection(
                    browseTitle: 'Browse By',
                    mainTitle: 'Shop Categories',
                    categories: [
                      CategoryItem(
                        icon: Icons.threesixty_rounded,
                        title: "Women's Fashion",
                        itemsCount: "2,400+ items",
                        backgroundColor: Colors.pink.shade50,
                        iconColor: Colors.pink.shade400,
                        onTap: () {},
                      ),
                      CategoryItem(
                        icon: Icons.man,
                        title: "Men's Fashion",
                        itemsCount: "1,800+ items",
                        backgroundColor: Colors.blue.shade50,
                        iconColor: Colors.blue.shade400,
                        onTap: () {},
                      ),
                      CategoryItem(
                        icon: Icons.shopping_bag,
                        title: "Footwear",
                        itemsCount: "900+ items",
                        backgroundColor: Colors.green.shade50,
                        iconColor: Colors.green.shade400,
                        onTap: () {},
                      ),
                      CategoryItem(
                        icon: Icons.spa,
                        title: "Beauty & Skincare",
                        itemsCount: "1,000+ items",
                        backgroundColor: Colors.purple.shade50,
                        iconColor: Colors.purple.shade400,
                        onTap: () {},
                      ),
                      CategoryItem(
                        icon: Icons.watch,
                        title: "Accessories",
                        itemsCount: "760+ items",
                        backgroundColor: Colors.orange.shade50,
                        iconColor: Colors.orange.shade400,
                        onTap: () {},
                      ),
                      CategoryItem(
                        icon: Icons.home,
                        title: "Home & Living",
                        itemsCount: "1,320+ items",
                        backgroundColor: Colors.teal.shade50,
                        iconColor: Colors.teal.shade400,
                        onTap: () {},
                      ),
                    ],
                    onViewAll: () {
                      // Navigate to all categories
                    },
                  ),

                  FeaturedProductsSection(),
                  FlashDealsSection(),
                  TrendingNowSection(),
                  BestSellersSection(),
                  PromoBannerSection(),
                  RecentlyViewedSection(),
                  // Category Section

                  // Footer
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

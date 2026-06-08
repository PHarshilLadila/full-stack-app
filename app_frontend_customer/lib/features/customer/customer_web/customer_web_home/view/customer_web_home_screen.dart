import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/velmora_appbar.dart';
import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/velmora_footer.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/featured_products_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/flash_deal_section.dart';
import 'package:app_frontend_customer/features/customer/customer_web/web_widgets/home_hero_banner.dart';
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

                  // Category Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SectionHeader(
                      title: "Shop by Category",
                      subtitle: "Explore our curated collections",
                    ),
                  ),
                  const SizedBox(height: 24),
                  CategoryGrid(),
                  const SizedBox(height: 60),

                  // Featured Products Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SectionHeader(
                      title: "Featured Products",
                      subtitle: "Best selling items this week",
                      showViewAll: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const FeaturedProductsCarousel(),
                  const SizedBox(height: 60),

                  // Promo Banner
                  const PromoBanner(),
                  const SizedBox(height: 60),

                  // New Arrivals Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SectionHeader(
                      title: "New Arrivals",
                      subtitle: "Fresh styles just for you",
                      showViewAll: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const NewArrivalsGrid(),
                  const SizedBox(height: 60),

                  // Testimonials
                  const TestimonialsSection(),
                  const SizedBox(height: 60),

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

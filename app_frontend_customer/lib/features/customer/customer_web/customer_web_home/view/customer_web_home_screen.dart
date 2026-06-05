import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/velmora_appbar.dart';
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

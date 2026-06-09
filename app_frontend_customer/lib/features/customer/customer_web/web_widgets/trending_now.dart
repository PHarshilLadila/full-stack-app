// lib/features/customer/customer_web/web_widgets/trending_now.dart
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/trending_products/trending_products_bloc.dart';
import '../bloc/trending_products/trending_products_event.dart';
import '../bloc/trending_products/trending_products_state.dart';
import '../models/product_model.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';

class TrendingNowSection extends StatelessWidget {
  const TrendingNowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrendingProductsBloc(
        customerWebService: CustomerWebService(),
      )..add(const LoadTrendingProducts()),
      child: const _TrendingNowContent(),
    );
  }
}

class _TrendingNowContent extends StatefulWidget {
  const _TrendingNowContent();

  @override
  State<_TrendingNowContent> createState() => _TrendingNowContentState();
}

class _TrendingNowContentState extends State<_TrendingNowContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return BlocBuilder<TrendingProductsBloc, TrendingProductsState>(
      builder: (context, state) {
        if (state is TrendingProductsLoading) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : isTablet ? 40 : 60,
              vertical: 60,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [Color(0xff090e1e), Color(0xff0c1526), Color(0xff0b142a)],
              ),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is TrendingProductsError) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : isTablet ? 40 : 60,
              vertical: 60,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [Color(0xff090e1e), Color(0xff0c1526), Color(0xff0b142a)],
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrendingProductsBloc>().add(const LoadTrendingProducts());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is TrendingProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : isTablet ? 40 : 60,
                vertical: 60,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [Color(0xff090e1e), Color(0xff0c1526), Color(0xff0b142a)],
                ),
              ),
              child: const Center(
                child: Text(
                  'No trending products available',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          }

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : isTablet ? 40 : 60,
              vertical: isMobile ? 30 : 60,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [Color(0xff090e1e), Color(0xff0c1526), Color(0xff0b142a)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section: "What's Hot" + "Trending Now" + "See All →"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's Hot",
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff4f46e5),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Trending Now',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: isMobile ? 28 : isTablet ? 36 : 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAllTrending(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            'See All',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 13 : 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff4f46e5),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Color(0xff4f46e5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Trending Items Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine number of items per row based on width
                    int itemsPerRow = 1;
                    if (constraints.maxWidth >= 1200) {
                      itemsPerRow = 5;
                    } else if (constraints.maxWidth >= 1000) {
                      itemsPerRow = 4;
                    } else if (constraints.maxWidth >= 750) {
                      itemsPerRow = 3;
                    } else if (constraints.maxWidth >= 500) {
                      itemsPerRow = 2;
                    } else {
                      itemsPerRow = 1;
                    }

                    final spacing = 20.0;
                    final itemWidth = (constraints.maxWidth - (itemsPerRow - 1) * spacing) / itemsPerRow;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: 24,
                      children: List.generate(products.length, (index) {
                        final product = products[index];
                        return SizedBox(
                          width: itemWidth,
                          child: TrendingItemCard(
                            rank: index + 1,
                            product: product,
                            onAddTap: () {
                              _addToCart(context, product);
                            },
                            onTap: () {
                              _navigateToProductDetail(context, product);
                            },
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

void _navigateToProductDetail(BuildContext context, ProductData product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailsScreen(productId: product.id),
    ),
  );
}

  void _addToCart(BuildContext context, ProductData product) {
    debugPrint('Add to cart: ${product.productName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToAllTrending(BuildContext context) {
    debugPrint('Navigate to all trending products');
  }
}

// Trending Item Card Widget
class TrendingItemCard extends StatelessWidget {
  final int rank;
  final ProductData product;
  final VoidCallback onAddTap;
  final VoidCallback? onTap;

  const TrendingItemCard({
    super.key,
    required this.rank,
    required this.product,
    required this.onAddTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final double imageHeight = isMobile ? 180.0 : 200.0;

    // Get display tag (other than Trending)
    String displayTag = '';
    for (var tag in product.tags) {
      if (tag != 'Trending') {
        displayTag = tag;
        break;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container with Badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius:   BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    product.mainBannerImage,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: imageHeight,
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: imageHeight,
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
                // Rank Badge - #1, #2, etc.
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff4f46e5), Color(0xff6366f1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '#$rank',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tag Badge - Top Right
                if (displayTag.isNotEmpty)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        displayTag,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                // Discount Badge - Bottom Left
                if (product.discountPercentage > 0)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.redAccent],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${product.discountPercentage}% OFF",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Name
                  Text(
                    product.sellerName,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Product Name
                  Text(
                    product.productName,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Rating Stars
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: index < product.rating.floor()
                              ? Colors.amber.shade600
                              : Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.rating.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (product.totalReviews > 0)
                        Text(
                          " (${product.totalReviews})",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price and Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${product.discountPrice.toInt()}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff4f46e5),
                            ),
                          ),
                          if (product.price > product.discountPrice)
                            Text(
                              '₹${product.price.toInt()}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                              ),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: onAddTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xff4f46e5), Color(0xff6366f1)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
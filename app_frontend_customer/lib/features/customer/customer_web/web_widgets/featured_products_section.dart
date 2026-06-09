// lib/features/customer/customer_web/web_widgets/featured_products_section.dart
import 'package:app_frontend_customer/features/customer/customer_web/bloc/featured_products/featured_products_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/featured_products/featured_products_state.dart';
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/view/product_details_screen.dart';
import 'package:app_frontend_customer/features/customer/customer_web/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/featured_products/featured_products_bloc.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              FeaturedProductsBloc(customerWebService: CustomerWebService())
                ..add(const LoadFeaturedProducts()),
      child: const _FeaturedProductsContent(),
    );
  }
}

class _FeaturedProductsContent extends StatefulWidget {
  const _FeaturedProductsContent();

  @override
  State<_FeaturedProductsContent> createState() =>
      _FeaturedProductsContentState();
}

class _FeaturedProductsContentState extends State<_FeaturedProductsContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return BlocBuilder<FeaturedProductsBloc, FeaturedProductsState>(
      builder: (context, state) {
        if (state is FeaturedProductsLoading) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 20
                      : isTablet
                      ? 40
                      : 60,
              vertical: 60,
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is FeaturedProductsError) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 20
                      : isTablet
                      ? 40
                      : 60,
              vertical: 60,
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
                      context.read<FeaturedProductsBloc>().add(
                        const LoadFeaturedProducts(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is FeaturedProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal:
                    isMobile
                        ? 20
                        : isTablet
                        ? 40
                        : 60,
                vertical: 60,
              ),
              child: const Center(child: Text('No featured products found')),
            );
          }

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 20
                      : isTablet
                      ? 40
                      : 60,
              vertical: isMobile ? 40 : 60,
            ),
            color: const Color(0xfff1f5f9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section (Without Filters)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Handpicked For You',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Featured Products',
                      style: GoogleFonts.playfairDisplay(
                        fontSize:
                            isMobile
                                ? 28
                                : isTablet
                                ? 36
                                : 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Products Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth =
                        isMobile
                            ? 280.0
                            : isTablet
                            ? 260.0
                            : 280.0;
                    final spacing = isMobile ? 16.0 : 24.0;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      alignment: WrapAlignment.start,
                      children:
                          products.map((product) {
                            return SizedBox(
                              width: cardWidth,
                              child: FeaturedProductCard(
                                product: product,
                                onTap: () {
                                  // Navigate to product detail
                                  _navigateToProductDetail(context, product);
                                },
                                onShopTap: () {
                                  // Add to cart
                                  _addToCart(context, product);
                                },
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 48),

                // View All Products Button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to all products
                      _navigateToAllProducts(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff4f46e5), Color(0xff6366f1)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff4f46e5).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View All Products',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
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
    // TODO: Implement add to cart functionality
    debugPrint('Add to cart: ${product.productName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToAllProducts(BuildContext context) {
    // TODO: Navigate to all products page
    debugPrint('Navigate to all products');
  }
}

// Featured Product Card Widget
class FeaturedProductCard extends StatelessWidget {
  final ProductData product;
  final VoidCallback? onTap;
  final VoidCallback? onShopTap;

  const FeaturedProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onShopTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final imageHeight = isMobile ? 180.0 : 200.0;

    // Get display tag (other than Featured)
    String displayTag = '';
    for (var tag in product.tags) {
      if (tag != 'Featured') {
        displayTag = tag;
        break;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image with Badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
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
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: imageHeight,
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Discount Badge - Top Right
                if (product.discountPercentage > 0)
                  Positioned(
                    top: 8,
                    right: 8,
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                // Tag Badge - Top Left (New, Trending, etc.)
                if (displayTag.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff4f46e5), Color(0xff6366f1)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        displayTag,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                // Wishlist Button
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                        size: 18,
                      ),
                      onPressed: () {
                        // TODO: Add to wishlist
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to wishlist'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Seller/Brand Name
            Text(
              product.sellerName,
              style: GoogleFonts.poppins(
                fontSize: 11,
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
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Rating Stars
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    size: 14,
                    color:
                        index < product.rating.floor()
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
            const SizedBox(height: 10),

            // Price and Add to Cart Button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "₹${product.discountPrice.toInt()}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff4f46e5),
                        ),
                      ),
                      if (product.price > product.discountPrice)
                        Text(
                          "₹${product.price.toInt()}",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onShopTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff4f46e5), Color(0xff6366f1)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

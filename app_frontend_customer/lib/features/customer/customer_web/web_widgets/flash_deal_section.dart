// lib/features/customer/customer_web/web_widgets/flash_deal_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../customer_web_home/bloc/flash_deals/flash_deals_bloc.dart';
import '../customer_web_home/bloc/flash_deals/flash_deals_event.dart';
import '../customer_web_home/bloc/flash_deals/flash_deals_state.dart';
import '../models/product_model.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';

class FlashDealsSection extends StatelessWidget {
  const FlashDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              FlashDealsBloc(customerWebService: CustomerWebService())
                ..add(const LoadFlashDeals()),
      child: const _FlashDealsContent(),
    );
  }
}

class _FlashDealsContent extends StatefulWidget {
  const _FlashDealsContent();

  @override
  State<_FlashDealsContent> createState() => _FlashDealsContentState();
}

class _FlashDealsContentState extends State<_FlashDealsContent> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return BlocBuilder<FlashDealsBloc, FlashDealsState>(
      builder: (context, state) {
        if (state is FlashDealsLoading) {
          return Container(
            width: double.infinity,
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

        if (state is FlashDealsError) {
          return Container(
            width: double.infinity,
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
                      context.read<FlashDealsBloc>().add(
                        const LoadFlashDeals(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is FlashDealsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal:
                    isMobile
                        ? 20
                        : isTablet
                        ? 40
                        : 60,
                vertical: 60,
              ),
              child: const Center(child: Text('No flash deals available')),
            );
          }

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 20
                      : isTablet
                      ? 40
                      : 60,
              vertical: isMobile ? 30 : 40,
            ),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Flash Deals and Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.red, size: 16),
                        Text(
                          'Limited Time',
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all deals
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff4f46e5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'View All Deals',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 13 : 14,
                              fontWeight: FontWeight.w600,
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
                // Timer Row
                Row(
                  children: [
                    Text(
                      'Flash Deals',
                      style: GoogleFonts.playfairDisplay(
                        fontSize:
                            isMobile
                                ? 24
                                : isTablet
                                ? 28
                                : 36,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Row(
                      children: [
                        _buildTimerDigit('02'),
                        const SizedBox(width: 4),
                        const _ColonDot(),
                        const SizedBox(width: 4),
                        _buildTimerDigit('14'),
                        const SizedBox(width: 4),
                        const _ColonDot(),
                        const SizedBox(width: 4),
                        _buildTimerDigit('38'),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Hrs',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Min',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Products Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 1;
                    if (constraints.maxWidth >= 1200) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth >= 800) {
                      crossAxisCount = 3;
                    } else if (constraints.maxWidth >= 550) {
                      crossAxisCount = 2;
                    } else {
                      crossAxisCount = 1;
                    }

                    final spacing = 24.0;
                    final itemWidth =
                        (constraints.maxWidth -
                            (crossAxisCount - 1) * spacing) /
                        crossAxisCount;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children:
                          products.map((product) {
                            return SizedBox(
                              width: itemWidth,
                              child: FlashProductCard(
                                product: product,
                                onTap: () {
                                  _navigateToProductDetail(context, product);
                                },
                                onShopTap: () {
                                  _addToCart(context, product);
                                },
                              ),
                            );
                          }).toList(),
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

  Widget _buildTimerDigit(String digit) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        digit,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, ProductData product) {
    debugPrint('Navigate to product: ${product.productName}');
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
}

class _ColonDot extends StatelessWidget {
  const _ColonDot();

  @override
  Widget build(BuildContext context) {
    return const Text(
      ':',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

// Flash Product Card Widget
class FlashProductCard extends StatelessWidget {
  final ProductData product;
  final VoidCallback? onTap;
  final VoidCallback? onShopTap;

  const FlashProductCard({
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

    // Get display tag (other than Sale)
    String displayTag = '';
    for (var tag in product.tags) {
      if (tag != 'Sale') {
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
                // Discount Badge - Top Left
                if (product.discountPercentage > 0)
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
                // Tag Badge - Top Right (if any)
                if (displayTag.isNotEmpty)
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
                          offset: const Offset(0, 2),
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

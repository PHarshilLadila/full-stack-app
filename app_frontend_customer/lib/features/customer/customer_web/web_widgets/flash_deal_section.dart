import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashDealsSection extends StatelessWidget {
  const FlashDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

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
          // Header Section with Flash Deals and Timer (Exactly as in image)
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
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 12,
              //     vertical: 6,
              //   ),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFFDF1F0),
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   child: Row(
              //     children: [
              //       const Icon(
              //         Icons.flash_on,
              //         color: Color(0xFFE67E22),
              //         size: 16,
              //       ),
              //       const SizedBox(width: 6),
              //       Text(
              //         'Flash Deals',
              //         style: GoogleFonts.inter(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 13,
              //           color: const Color(0xFFE67E22),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              TextButton(
                onPressed: () {},
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
          // Timer Row (Exactly as in image)
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
              SizedBox(width: 24),
              Row(
                children: [
                  TimerDigit(digit: '02'),
                  const SizedBox(width: 4),
                  const ColonDot(),
                  const SizedBox(width: 4),
                  TimerDigit(digit: '14'),
                  const SizedBox(width: 4),
                  const ColonDot(),
                  const SizedBox(width: 4),
                  TimerDigit(digit: '38'),
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
          // Product Cards Layout - Fully Responsive, No GridView, Using ProductCard UI from FeaturedProducts
          LayoutBuilder(
            builder: (context, constraints) {
              // Determine number of columns based on width
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

              // Product data matching the image exactly
              final flashDealProducts = [
                FlashProductData(
                  imageUrl:
                      "https://images.unsplash.com/photo-1600269452121-4f2416e55c28?w=400&h=400&fit=crop", // Sneakers
                  brandName: "Puma",
                  productName: "Cloud Comfort Sneakers",
                  rating: 4.0,
                  reviewCount: 538,
                  currentPrice: 2999,
                  originalPrice: 5499,
                  tag: "",
                  discountPercentage: 45,
                ),
                FlashProductData(
                  imageUrl:
                      "https://images.unsplash.com/photo-1591561954557-26941169b49e?w=400&h=400&fit=crop", // Canvas Tote Bag
                  brandName: "Velmora Studio",
                  productName: "Canvas Tote Bag",
                  rating: 4.0,
                  reviewCount: 21,
                  currentPrice: 899,
                  originalPrice: 1499,
                  tag: "",
                  discountPercentage: 40,
                ),
                FlashProductData(
                  imageUrl:
                      "https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&h=400&fit=crop", // Structured Mini Bag
                  brandName: "Caprese",
                  productName: "Structured Mini Bag",
                  rating: 4.0,
                  reviewCount: 187,
                  currentPrice: 2499,
                  originalPrice: 3999,
                  tag: "",
                  discountPercentage: 37,
                ),
                FlashProductData(
                  imageUrl:
                      "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400&h=400&fit=crop", // High-Rise Skinny Jeans
                  brandName: "Levi's",
                  productName: "High-Rise Skinny Jeans",
                  rating: 4.0,
                  reviewCount: 629,
                  currentPrice: 1999,
                  originalPrice: 3499,
                  tag: "",
                  discountPercentage: 42,
                ),
              ];

              return Column(
                children: [
                  for (
                    int i = 0;
                    i < flashDealProducts.length;
                    i += crossAxisCount
                  )
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          (i + crossAxisCount <= flashDealProducts.length)
                              ? crossAxisCount
                              : flashDealProducts.length - i,
                          (index) {
                            final product = flashDealProducts[i + index];
                            final itemWidth =
                                (constraints.maxWidth -
                                    (crossAxisCount - 1) * 24) /
                                crossAxisCount;
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index != crossAxisCount - 1 ? 24 : 0,
                              ),
                              child: SizedBox(
                                width: itemWidth,
                                child: FlashProductCard(
                                  imageUrl: product.imageUrl,
                                  brandName: product.brandName,
                                  productName: product.productName,
                                  rating: product.rating,
                                  reviewCount: product.reviewCount,
                                  currentPrice: product.currentPrice,
                                  originalPrice: product.originalPrice,
                                  tag: product.tag,
                                  discountPercentage:
                                      product.discountPercentage,
                                  onTap: () {},
                                  onShopTap: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class FlashProductData {
  final String imageUrl;
  final String brandName;
  final String productName;
  final double rating;
  final int reviewCount;
  final int currentPrice;
  final int originalPrice;
  final String tag;
  final int discountPercentage;

  FlashProductData({
    required this.imageUrl,
    required this.brandName,
    required this.productName,
    required this.rating,
    required this.reviewCount,
    required this.currentPrice,
    required this.originalPrice,
    required this.tag,
    required this.discountPercentage,
  });
}

// Product Card matching the style from your FeaturedProductsSection (exactly same UI)
class FlashProductCard extends StatelessWidget {
  final String imageUrl;
  final String brandName;
  final String productName;
  final double rating;
  final int reviewCount;
  final int currentPrice;
  final int originalPrice;
  final String tag;
  final int discountPercentage;
  final VoidCallback? onTap;
  final VoidCallback? onShopTap;

  const FlashProductCard({
    super.key,
    required this.imageUrl,
    required this.brandName,
    required this.productName,
    this.rating = 4.5,
    this.reviewCount = 0,
    required this.currentPrice,
    required this.originalPrice,
    this.tag = "",
    this.discountPercentage = 0,
    this.onTap,
    this.onShopTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final imageHeight = isMobile ? 180.0 : 200.0;

    final int displayDiscount =
        discountPercentage > 0
            ? discountPercentage
            : ((originalPrice - currentPrice) / originalPrice * 100).round();

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
                    imageUrl,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                if (displayDiscount > 0)
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
                        "${displayDiscount}% OFF",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                // Tag Badge - Top Left (if any)
                if (tag.isNotEmpty)
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
                        tag,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        // isFavorite ? Icons.favorite : Icons.favorite_border,
                        // color: isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                      onPressed: () {
                        // setState(() {
                        //   isFavorite = !isFavorite;
                        // });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Brand Name
            Text(
              brandName,
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
              productName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
              maxLines: 1,
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
                        index < rating.floor()
                            ? Colors.amber.shade600
                            : Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  rating.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (reviewCount > 0)
                  Text(
                    " ($reviewCount)",
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
                        "₹$currentPrice",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff4f46e5),
                        ),
                      ),
                      if (originalPrice > currentPrice)
                        Text(
                          "₹$originalPrice",
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

class TimerDigit extends StatelessWidget {
  final String digit;
  const TimerDigit({super.key, required this.digit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
}

class ColonDot extends StatelessWidget {
  const ColonDot({super.key});

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

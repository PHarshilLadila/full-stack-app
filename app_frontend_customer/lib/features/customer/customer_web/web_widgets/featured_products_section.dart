// lib/widgets/featured_products_section.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedProductsSection extends StatefulWidget {
  const FeaturedProductsSection({super.key});

  @override
  State<FeaturedProductsSection> createState() =>
      _FeaturedProductsSectionState();
}

class _FeaturedProductsSectionState extends State<FeaturedProductsSection> {
  String selectedFilter = 'All';

  final List<String> filters = ['All', 'Women', 'Men', 'Accessories'];

  final List<ProductData> allProducts = [
    ProductData(
      imageUrl: "https://www.motiwalaperfumes.com/cdn/shop/files/veluro-4.png",
      brandName: "The Label Life",
      productName: "Oversized Linen Blazer",
      rating: 4.5,
      reviewCount: 234,
      currentPrice: 3299,
      originalPrice: 4999,
      tag: "Premium",
      discountPercentage: 34,
    ),
    ProductData(
      imageUrl:
          "https://www.motiwalaperfumes.com/cdn/shop/files/Fanatic-attire-blue-12_5f594cc0-9473-401c-bec2-b29e50b91aed.png",
      brandName: "Urbano Fashion",
      productName: "Slim Fit Chinos",
      rating: 4.3,
      reviewCount: 189,
      currentPrice: 1599,
      originalPrice: 2299,
      tag: "",
      discountPercentage: 30,
    ),
    ProductData(
      imageUrl:
          "https://res.cloudinary.com/dyorzq6ir/image/upload/v1780501149/ecommerce/products/fk53ydxeoxchqygcuko1.webp",
      brandName: "Accessorize",
      productName: "Pearl Drop Earrings",
      rating: 4.7,
      reviewCount: 412,
      currentPrice: 799,
      originalPrice: 1999,
      tag: "Bestseller",
      discountPercentage: 33,
    ),
    ProductData(
      imageUrl: "https://www.motiwalaperfumes.com/cdn/shop/files/veluro-4.png",
      brandName: "Velmora Studio",
      productName: "Floral Midi Dress",
      rating: 4.6,
      reviewCount: 316,
      currentPrice: 2199,
      originalPrice: 2999,
      tag: "",
      discountPercentage: 26,
    ),
    ProductData(
      imageUrl:
          "https://www.motiwalaperfumes.com/cdn/shop/files/Fanatic-attire-blue-12_5f594cc0-9473-401c-bec2-b29e50b91aed.png",
      brandName: "The Label Life",
      productName: "Wool Blend Coat",
      rating: 4.8,
      reviewCount: 567,
      currentPrice: 4599,
      originalPrice: 6999,
      tag: "Premium",
      discountPercentage: 34,
    ),
    ProductData(
      imageUrl:
          "https://res.cloudinary.com/dyorzq6ir/image/upload/v1780501149/ecommerce/products/fk53ydxeoxchqygcuko1.webp",
      brandName: "Urbano Fashion",
      productName: "Leather Jacket",
      rating: 4.4,
      reviewCount: 278,
      currentPrice: 3499,
      originalPrice: 5499,
      tag: "Trending",
      discountPercentage: 36,
    ),
    ProductData(
      imageUrl: "https://www.motiwalaperfumes.com/cdn/shop/files/veluro-4.png",
      brandName: "Accessorize",
      productName: "Designer Handbag",
      rating: 4.9,
      reviewCount: 892,
      currentPrice: 2899,
      originalPrice: 3999,
      tag: "Bestseller",
      discountPercentage: 27,
    ),
    ProductData(
      imageUrl:
          "https://www.motiwalaperfumes.com/cdn/shop/files/Fanatic-attire-blue-12_5f594cc0-9473-401c-bec2-b29e50b91aed.png",
      brandName: "Velmora Studio",
      productName: "Silk Scarf",
      rating: 4.2,
      reviewCount: 145,
      currentPrice: 599,
      originalPrice: 1299,
      tag: "",
      discountPercentage: 54,
    ),
  ];

  List<ProductData> get filteredProducts {
    if (selectedFilter == 'All') {
      return allProducts;
    }
    return allProducts.where((product) {
      if (selectedFilter == 'Women') {
        return product.productName.contains('Dress') ||
            product.productName.contains('Blazer') ||
            product.productName.contains('Scarf');
      } else if (selectedFilter == 'Men') {
        return product.productName.contains('Chinos') ||
            product.productName.contains('Jacket') ||
            product.productName.contains('Coat');
      } else if (selectedFilter == 'Accessories') {
        return product.productName.contains('Earrings') ||
            product.productName.contains('Handbag') ||
            product.productName.contains('Scarf');
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

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
      color: Color(0xfff1f5f9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  // Ultra Clean Filter Chips - Minimalist Design
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children:
                            filters.map((filter) {
                              final isSelected = selectedFilter == filter;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedFilter = filter;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? const Color(0xff4f46e5)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? const Color(0xff4f46e5)
                                              : Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    filter,
                                    style: GoogleFonts.inter(
                                      fontSize: isMobile ? 11 : 13,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Filter Chips
          const SizedBox(height: 32),

          // Products using Wrap (No GridView)
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
                    filteredProducts.map((product) {
                      return SizedBox(
                        width: cardWidth,
                        child: ProductCard(
                          imageUrl: product.imageUrl,
                          brandName: product.brandName,
                          productName: product.productName,
                          rating: product.rating,
                          reviewCount: product.reviewCount,
                          currentPrice: product.currentPrice,
                          originalPrice: product.originalPrice,
                          tag: product.tag,
                          discountPercentage: product.discountPercentage,
                          onTap: () {},
                          onShopTap: () {},
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
              onTap: () {},
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
}

class ProductData {
  final String imageUrl;
  final String brandName;
  final String productName;
  final double rating;
  final int reviewCount;
  final int currentPrice;
  final int originalPrice;
  final String tag;
  final int discountPercentage;

  ProductData({
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

// Your existing ProductCard widget here (keep as is)
class ProductCard extends StatelessWidget {
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

  const ProductCard({
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
                        "${displayDiscount}% OFF",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                // Tag Badge - Top Left
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

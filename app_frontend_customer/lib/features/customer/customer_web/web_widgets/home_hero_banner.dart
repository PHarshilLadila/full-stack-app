import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff090e1e), Color(0xff0c1526), Color(0xff0b142a)],
        ),
      ),
      child:
          isMobile
              ? _buildMobileLayout()
              : isTablet
              ? _buildTabletLayout()
              : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SeasonHeroBanner(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ProductCard(
                    imageUrl:
                        "https://www.motiwalaperfumes.com/cdn/shop/files/veluro-4.png",
                    brandName: "Motiwal Perfumes",
                    productName: "Fanatic Musk Veluro EDP",
                    rating: 4.8,
                    reviewCount: 245,
                    currentPrice: 1400,
                    originalPrice: 1660,
                    tag: "Trending",
                    discountPercentage: 25,
                    onTap: () {},
                    onShopTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCard(
                    imageUrl:
                        "https://res.cloudinary.com/dyorzq6ir/image/upload/v1780501149/ecommerce/products/fk53ydxeoxchqygcuko1.webp",
                    brandName: "Palmonas",
                    productName: "Classic Emerald Necklace",
                    rating: 5,
                    reviewCount: 5234,
                    currentPrice: 2223,
                    originalPrice: 3541,
                    tag: "Hot",
                    discountPercentage: 37,
                    onTap: () {},
                    onShopTap: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 5, child: SeasonHeroBanner()),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 260,
                    child: ProductCard(
                      imageUrl:
                          "https://www.motiwalaperfumes.com/cdn/shop/files/veluro-4.png",
                      brandName: "Motiwal Perfumes",
                      productName: "Fanatic Musk Veluro EDP",
                      rating: 4.8,
                      reviewCount: 245,
                      currentPrice: 1400,
                      originalPrice: 1660,
                      tag: "Trending",
                      discountPercentage: 25,
                      onTap: () {},
                      onShopTap: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 260,
                    child: ProductCard(
                      imageUrl:
                          "https://res.cloudinary.com/dyorzq6ir/image/upload/v1780501149/ecommerce/products/fk53ydxeoxchqygcuko1.webp",
                      brandName: "Palmonas",
                      productName: "Classic Emerald Necklace",
                      rating: 5,
                      reviewCount: 5234,
                      currentPrice: 2223,
                      originalPrice: 3541,
                      tag: "Hot",
                      discountPercentage: 37,
                      onTap: () {},
                      onShopTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 5, child: SeasonHeroBanner()),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 260,
                  child: ProductCard(
                    imageUrl:
                        "https://www.motiwalaperfumes.com/cdn/shop/files/veluro-4.png",
                    brandName: "Motiwal Perfumes",
                    productName: "Fanatic Musk Veluro EDP",
                    rating: 4.8,
                    reviewCount: 245,
                    currentPrice: 1400,
                    originalPrice: 1660,
                    tag: "Trending",
                    discountPercentage: 25,
                    onTap: () {},
                    onShopTap: () {},
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 260,
                  child: ProductCard(
                    imageUrl:
                        "https://res.cloudinary.com/dyorzq6ir/image/upload/v1780501149/ecommerce/products/fk53ydxeoxchqygcuko1.webp",
                    brandName: "Palmonas",
                    productName: "Classic Emerald Necklace",
                    rating: 5,
                    reviewCount: 5234,
                    currentPrice: 2223,
                    originalPrice: 3541,
                    tag: "Hot",
                    discountPercentage: 37,
                    onTap: () {},
                    onShopTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SeasonHeroBanner extends StatelessWidget {
  const SeasonHeroBanner({super.key});

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
                ? 30
                : 40,
        vertical:
            isMobile
                ? 30
                : isTablet
                ? 40
                : 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade600,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'NEW SEASON',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 10 : 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff090e1e),
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                'Summer 2025 Collection',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Elevate Your',
            style: GoogleFonts.playfairDisplay(
              fontSize:
                  isMobile
                      ? 28
                      : isTablet
                      ? 38
                      : 44,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          Text(
            'Style Game',
            style: GoogleFonts.playfairDisplay(
              fontSize:
                  isMobile
                      ? 32
                      : isTablet
                      ? 44
                      : 50,
              fontWeight: FontWeight.bold,
              color: const Color(0xff4f46e5),
              height: 1.1,
            ),
          ),
          Text(
            'This Season',
            style: GoogleFonts.playfairDisplay(
              fontSize:
                  isMobile
                      ? 28
                      : isTablet
                      ? 38
                      : 44,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover curated collections from the world\'s most coveted brands',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 12 : 13,
                    color: Colors.grey.shade400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Premium quality, delivered to your door.',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _buildShopNowButton(isMobile, "Shop Now"),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatColumn("50K+", "Happy Customers", isMobile),
              Container(width: 1, height: 35, color: Colors.grey.shade800),
              _buildStatColumn("200+", "Premium Brands", isMobile),
              Container(width: 1, height: 35, color: Colors.grey.shade800),
              _buildStatColumn("10K+", "Products", isMobile),
            ],
          ),
          const SizedBox(height: 24),
          if (!isMobile)
            Row(
              children: [
                _buildDot(true),
                const SizedBox(width: 8),
                _buildDot(false),
                const SizedBox(width: 8),
                _buildDot(false),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.grey.shade500,
            fontSize: isMobile ? 9 : 11,
          ),
        ),
      ],
    );
  }

  Widget _buildShopNowButton(bool isMobile, String buttonName) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 30,
          vertical: isMobile ? 10 : 12,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff4f46e5), Color(0xff6366f1)],
          ),
          borderRadius: BorderRadius.circular(10),
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
              buttonName,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 13 : 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: isActive ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff4f46e5) : Colors.grey.shade600,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

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
    final imageHeight = isMobile ? 160.0 : 180.0;

    // Calculate discount percentage if not provided
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
            // Product Image with Discount Badge using Stack
            Stack(
              children: [
                // Product Image
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

                // Discount Badge - Top Right Corner
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
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
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

                // Tag Badge - Top Left Corner (Trending/Hot/New)
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
                fontSize: 10,
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
                fontSize: 13,
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
                    size: 12,
                    color:
                        index < rating.floor()
                            ? Colors.amber.shade600
                            : Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (reviewCount > 0)
                  Text(
                    " ($reviewCount)",
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Price and Shop Now Button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            "₹$currentPrice",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff4f46e5),
                            ),
                          ),
                          if (originalPrice > currentPrice) ...[
                            const SizedBox(width: 8),
                            Text(
                              "₹$originalPrice",
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onShopTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff4f46e5), Color(0xff6366f1)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Shop",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 10,
                        ),
                      ],
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

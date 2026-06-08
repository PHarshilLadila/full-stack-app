import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BestSellersSection extends StatelessWidget {
  const BestSellersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : isTablet ? 40 : 60,
        vertical: isMobile ? 30 : 40,
      ),
      color: const Color(0xFFF8F9FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section: Top Picks + Best Sellers + View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Top Picks",
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Best Sellers',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isMobile ? 28 : isTablet ? 36 : 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'View All',
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

          // Best Sellers List - Fully Responsive using Wrap (No GridView)
          LayoutBuilder(
            builder: (context, constraints) {
              // Determine number of items per row based on width
              int itemsPerRow = 1;
              if (constraints.maxWidth >= 1200) {
                itemsPerRow = 4;
              } else if (constraints.maxWidth >= 900) {
                itemsPerRow = 3;
              } else if (constraints.maxWidth >= 600) {
                itemsPerRow = 2;
              } else {
                itemsPerRow = 1;
              }

              final bestSellers = [
                BestSellerItem(
                  rank: 1,
                  brand: "Marks & Spencer",
                  productName: "Ribbed Turtleneck",
                  rating: 4.9,
                  reviews: 847,
                  currentPrice: 1899,
                  originalPrice: 2599,
                  soldCount: "2.4k sold",
                  imageUrl: "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=400&h=400&fit=crop",
                ),
                BestSellerItem(
                  rank: 2,
                  brand: "Tommy Hilfiger",
                  productName: "Oxford Button-Down",
                  rating: 4.8,
                  reviews: 631,
                  currentPrice: 2499,
                  originalPrice: 3299,
                  soldCount: "1.9k sold",
                  imageUrl: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=400&fit=crop",
                ),
                BestSellerItem(
                  rank: 3,
                  brand: "Biba",
                  productName: "Ethnic Kurta Set",
                  rating: 4.7,
                  reviews: 528,
                  currentPrice: 1599,
                  originalPrice: 2299,
                  soldCount: "1.7k sold",
                  imageUrl: "https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=400&h=400&fit=crop",
                ),
                BestSellerItem(
                  rank: 4,
                  brand: "Fossil",
                  productName: "Leather Bifold Wallet",
                  rating: 4.6,
                  reviews: 412,
                  currentPrice: 1299,
                  originalPrice: 1999,
                  soldCount: "1.2k sold",
                  imageUrl: "https://images.unsplash.com/photo-1627123424574-724758594e93?w=400&h=400&fit=crop",
                ),
              ];

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: List.generate(bestSellers.length, (index) {
                  final item = bestSellers[index];
                  final itemWidth = (constraints.maxWidth - (itemsPerRow - 1) * 24) / itemsPerRow;
                  return SizedBox(
                    width: itemWidth,
                    child: BestSellerCard(
                      rank: item.rank,
                      brand: item.brand,
                      productName: item.productName,
                      rating: item.rating,
                      reviews: item.reviews,
                      currentPrice: item.currentPrice,
                      originalPrice: item.originalPrice,
                      soldCount: item.soldCount,
                      imageUrl: item.imageUrl,
                      onAddToCart: () {},
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
}

class BestSellerItem {
  final int rank;
  final String brand;
  final String productName;
  final double rating;
  final int reviews;
  final int currentPrice;
  final int originalPrice;
  final String soldCount;
  final String imageUrl;

  BestSellerItem({
    required this.rank,
    required this.brand,
    required this.productName,
    required this.rating,
    required this.reviews,
    required this.currentPrice,
    required this.originalPrice,
    required this.soldCount,
    required this.imageUrl,
  });
}

class BestSellerCard extends StatelessWidget {
  final int rank;
  final String brand;
  final String productName;
  final double rating;
  final int reviews;
  final int currentPrice;
  final int originalPrice;
  final String soldCount;
  final String imageUrl;
  final VoidCallback onAddToCart;

  const BestSellerCard({
    super.key,
    required this.rank,
    required this.brand,
    required this.productName,
    required this.rating,
    required this.reviews,
    required this.currentPrice,
    required this.originalPrice,
    required this.soldCount,
    required this.imageUrl,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section with Rank and Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  height: isMobile ? 180 : 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: isMobile ? 180 : 200,
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
              // Rank Badge - 01, 02, etc.
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rank < 10 ? '0$rank' : '$rank',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // "View All ➡" Badge - Top Right
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff4f46e5),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: Color(0xff4f46e5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Name
                Text(
                  brand,
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
                  productName,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Rating Row - ⭐️⭐️⭐️⭐️⭐️ 4.9 (847)
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: index < rating.floor()
                            ? const Color(0xFFFFB800)
                            : Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rating.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviews)',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Price Row
                Row(
                  children: [
                    Text(
                      '₹$currentPrice',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff4f46e5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹$originalPrice',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Sold Count
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      soldCount,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4f46e5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
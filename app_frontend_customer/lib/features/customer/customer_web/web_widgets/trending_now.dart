import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingNowSection extends StatelessWidget {
  const TrendingNowSection({super.key});

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
        vertical: isMobile ? 30 : 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff090e1e), Color(0xff0c1526), Color(0xff0b142a)],
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
                      color: Color(0xff4f46e5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trending Now',
                    style: GoogleFonts.playfairDisplay(
                      fontSize:
                          isMobile
                              ? 28
                              : isTablet
                              ? 36
                              : 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
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

          // Trending Items List - Fully Responsive using Row/Wrap (No GridView)
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

              final trendingItems = [
                TrendingItem(
                  rank: 1,
                  brand: "H&M",
                  productName: "Relaxed Fit Shirt",
                  price: 1299,
                  imageUrl:
                      "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=300&h=300&fit=crop",
                ),
                TrendingItem(
                  rank: 2,
                  brand: "Velmora Home",
                  productName: "Satin Sleep Set",
                  price: 1899,
                  imageUrl:
                      "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=300&h=300&fit=crop",
                ),
                TrendingItem(
                  rank: 3,
                  brand: "Raymond",
                  productName: "Leather Belt",
                  price: 699,
                  imageUrl:
                      "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=300&fit=crop",
                ),
                TrendingItem(
                  rank: 4,
                  brand: "Zaveri Pearls",
                  productName: "Gold Hoop Earrings",
                  price: 549,
                  imageUrl:
                      "https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=300&h=300&fit=crop",
                ),
                TrendingItem(
                  rank: 5,
                  brand: "Global Desi",
                  productName: "Printed Kaftan",
                  price: 1599,
                  imageUrl:
                      "https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=300&h=300&fit=crop",
                ),
              ];

              return Wrap(
                spacing: 20,
                runSpacing: 24,
                children: List.generate(trendingItems.length, (index) {
                  final item = trendingItems[index];
                  // Calculate width based on items per row
                  final itemWidth =
                      (constraints.maxWidth - (itemsPerRow - 1) * 20) /
                      itemsPerRow;
                  return SizedBox(
                    width: itemWidth,
                    child: TrendingItemCard(
                      rank: item.rank,
                      brand: item.brand,
                      productName: item.productName,
                      price: item.price,
                      imageUrl: item.imageUrl,
                      onAddTap: () {},
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

class TrendingItem {
  final int rank;
  final String brand;
  final String productName;
  final int price;
  final String imageUrl;

  TrendingItem({
    required this.rank,
    required this.brand,
    required this.productName,
    required this.price,
    required this.imageUrl,
  });
}

class TrendingItemCard extends StatelessWidget {
  final int rank;
  final String brand;
  final String productName;
  final int price;
  final String imageUrl;
  final VoidCallback onAddTap;

  const TrendingItemCard({
    super.key,
    required this.rank,
    required this.brand,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with Rank Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
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
                    color: Colors.black.withOpacity(0.75),
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
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
                // Price and Add Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹$price',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff4f46e5),
                      ),
                    ),
                    GestureDetector(
                      onTap: onAddTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xff4f46e5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.add,
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
    );
  }
}

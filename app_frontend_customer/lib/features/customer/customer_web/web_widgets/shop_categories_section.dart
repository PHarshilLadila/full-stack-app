// lib/widgets/category_section.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySection extends StatelessWidget {
  final String browseTitle;
  final String mainTitle;
  final List<CategoryItem> categories;
  final VoidCallback? onViewAll;

  const CategorySection({
    super.key,
    this.browseTitle = 'Browse By',
    this.mainTitle = 'Shop Categories',
    required this.categories,
    this.onViewAll,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    browseTitle,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff8882ec),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mainTitle,
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
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xff4f46e5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View All',
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

          const SizedBox(height: 32),

          // Categories using Wrap - Fully Responsive
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = isMobile ? 160.0 : 220.0;
              final spacing = isMobile ? 12.0 : 20.0;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.start,
                children:
                    categories.map((category) {
                      return SizedBox(
                        width: cardWidth,
                        child: _buildCategoryCard(category, isMobile),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryItem category, bool isMobile) {
    return GestureDetector(
      onTap: category.onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: category.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                category.icon,
                size: isMobile ? 28 : 32,
                color: category.iconColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category.title,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 13 : 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              category.itemsCount,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 10 : 11,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String title;
  final String itemsCount;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const CategoryItem({
    required this.icon,
    required this.title,
    required this.itemsCount,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
  });
}

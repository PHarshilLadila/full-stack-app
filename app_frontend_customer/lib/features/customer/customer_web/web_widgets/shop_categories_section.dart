// lib/features/customer/customer_web/web_widgets/shop_categories_section_simple.dart
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_bloc.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_state.dart';
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/view/all_categories_screen.dart';
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/view/category_products_screen.dart';
import 'package:app_frontend_customer/utils/helper/category_style_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopCategoriesSection extends StatelessWidget {
  final String browseTitle;
  final String mainTitle;

  const ShopCategoriesSection({
    super.key,
    this.browseTitle = 'Browse By',
    this.mainTitle = 'Shop Categories',
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CategoriesLoaded) {
          return Container(
            padding: EdgeInsets.all(isMobile ? 20 : 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile, context),
                const SizedBox(height: 32),
                _buildCategoriesGrid(state.categories, isMobile, context),
              ],
            ),
          );
        }

        if (state is CategoriesError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader(bool isMobile, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse By',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 12 : 14,
                color: const Color(0xff8882ec),
              ),
            ),
            Text(
              'Shop Categories',
              style: GoogleFonts.playfairDisplay(
                fontSize: isMobile ? 28 : 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AllCategoriesScreen(),
              ),
            );
          },
          child: Text(
            'View All',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xff4f46e5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(
    List<CategoryData> categories,
    bool isMobile,
    BuildContext context,
  ) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children:
          categories.map((category) {
            return SizedBox(
              width: isMobile ? 160 : 220,
              child: _buildCategoryCard(category, isMobile, context),
            );
          }).toList(),
    );
  }

  Widget _buildCategoryCard(
    CategoryData category,
    bool isMobile,
    BuildContext context,
  ) {
    // ⭐⭐⭐ MAGIC HAPPENS HERE - Using Extension Methods ⭐⭐⭐
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    CategoryProductsScreen(initialCategory: category.name),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          // 👈 Automatically gets color based on category name
          color: category.name.categoryBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                // 👈 Automatically gets icon based on category name
                category.name.categoryIcon,
                size: isMobile ? 28 : 32,
                // 👈 Automatically gets color based on category name
                color: category.name.categoryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category.name,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${category.productCount}+ items',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

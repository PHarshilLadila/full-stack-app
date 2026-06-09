// lib/features/customer/customer_web/screens/all_categories_screen.dart
import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/base_scaffold.dart';
import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/velmora_appbar.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_bloc.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_state.dart';
import 'package:app_frontend_customer/utils/helper/category_style_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_products_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BaseScaffold(
      scaffoldKey: scaffoldKey,
      showFooter: true,
      child: _AllCategoriesContent(),
    );
  }
}

class _AllCategoriesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CategoriesLoaded) {
          final categories = state.categories;

          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No categories found',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return _buildCategoriesGrid(categories, context);
        }

        if (state is CategoriesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CategoryBloc>().add(LoadCategories());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCategoriesGrid(
    List<CategoryData> categories,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Categories',
            style: GoogleFonts.playfairDisplay(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${categories.length} categories available',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              if (constraints.maxWidth >= 1200) {
                crossAxisCount = 6;
              } else if (constraints.maxWidth >= 900) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth >= 600) {
                crossAxisCount = 3;
              } else {
                crossAxisCount = 2;
              }

              final spacing = 16.0;
              final itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children:
                    categories.map((category) {
                      return SizedBox(
                        width: itemWidth,
                        child: _buildCategoryCard(category, isMobile, context),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    CategoryData category,
    bool isMobile,
    BuildContext context,
  ) {
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
        padding: EdgeInsets.all(isMobile ? 20 : 24),
        decoration: BoxDecoration(
          color: category.name.categoryBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                category.name.categoryIcon,
                size: isMobile ? 32 : 40,
                color: category.name.categoryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 14 : 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: category.name.categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${category.productCount} items',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: category.name.categoryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

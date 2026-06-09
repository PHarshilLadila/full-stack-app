// lib/features/customer/customer_web/screens/category_products_screen.dart
import 'package:app_frontend_customer/features/customer/customer_web/common_widgets/base_scaffold.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_bloc.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/categories/categories_state.dart';
import 'package:app_frontend_customer/features/customer/customer_web/customer_web_home/view/product_details_screen.dart';
import 'package:app_frontend_customer/features/customer/customer_web/models/product_model.dart';
import 'package:app_frontend_customer/utils/helper/category_style_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String? initialCategory;

  const CategoryProductsScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BaseScaffold(
      scaffoldKey: scaffoldKey,
      showFooter: true,
      child: _CategoryProductsContent(initialCategory: initialCategory),
    );
  }
}

class _CategoryProductsContent extends StatefulWidget {
  final String? initialCategory;

  const _CategoryProductsContent({this.initialCategory});

  @override
  State<_CategoryProductsContent> createState() =>
      _CategoryProductsContentState();
}

class _CategoryProductsContentState extends State<_CategoryProductsContent> {
  String? _selectedCategory;
  String? _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    if (_selectedCategory != null) {
      _loadProductsByCategory(_selectedCategory!);
    }
  }

  void _loadProductsByCategory(String category) {
    context.read<CategoryBloc>().add(
      LoadProductsByCategory(categoryName: category),
    );
  }

  // void _loadProductsBySubCategory(String subCategory) {
  //   context.read<CategoryBloc>().add(
  //     LoadProductsBySubCategory(subCategoryName: subCategory),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        // Show categories list when no category selected
        if (_selectedCategory == null && state is CategoriesLoaded) {
          return _buildAllCategoriesView(state.categories, isMobile);
        }

        // Show products for selected category
        if (state is ProductsByCategoryLoaded) {
          return _buildProductsView(state.products, isMobile);
        }

        if (state is ProductsByCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CategoriesLoaded) {
          return _buildAllCategoriesView(state.categories, isMobile);
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

  Widget _buildAllCategoriesView(List<CategoryData> categories, bool isMobile) {
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

  Widget _buildCategoryCard(CategoryData category, bool isMobile) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category.name;
          _selectedSubCategory = null;
        });
        _loadProductsByCategory(category.name);
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
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
                category.name.categoryIcon,
                size: isMobile ? 28 : 32,
                color: category.name.categoryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 13 : 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${category.productCount} items',
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

  Widget _buildProductsView(List<ProductData> products, bool isMobile) {
    return Column(
      children: [
        // Category Header with Back Button
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 16,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = null;
                    _selectedSubCategory = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_back, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedSubCategory ?? _selectedCategory ?? '',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 18 : 22,
                      ),
                    ),
                    Text(
                      '${products.length} products found',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.filter_list, size: 20),
              ),
            ],
          ),
        ),

        // Products Grid
        products.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No products found',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
            : Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  if (constraints.maxWidth >= 1200) {
                    crossAxisCount = 5;
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
                        products.map((product) {
                          return SizedBox(
                            width: itemWidth,
                            child: _buildProductCard(product, isMobile),
                          );
                        }).toList(),
                  );
                },
              ),
            ),
      ],
    );
  }

  Widget _buildProductCard(ProductData product, bool isMobile) {
    final imageHeight = isMobile ? 150.0 : 180.0;

    String displayTag = '';
    for (var tag in product.tags) {
      if (tag != 'Featured' && tag != 'Trending' && tag != 'Sale') {
        displayTag = tag;
        break;
      }
    }

    return GestureDetector(
      onTap: () {
        _navigateToProductDetail(context, product);
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    product.mainBannerImage,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: imageHeight,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      );
                    },
                  ),
                ),
                if (product.discountPercentage > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${product.discountPercentage}% OFF',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (displayTag.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff4f46e5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        displayTag,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.sellerName,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.productName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          size: 12,
                          color:
                              index < product.rating.floor()
                                  ? Colors.amber.shade600
                                  : Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: GoogleFonts.inter(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${product.discountPrice.toInt()}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff4f46e5),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.price > product.discountPrice)
                        Text(
                          '₹${product.price.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}

// ignore_for_file: deprecated_member_use

import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:app_frontend/utils/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() {
    categories = [
      CategoryModel(
        name: "Electronics",
        icon: HugeIcons.strokeRoundedComputer,
        color: Colors.blue.shade100,
        iconColor: Colors.blue.shade700,
        subcategories: ["Smartphones", "Laptops", "Accessories", "Audio"],
        productCount: 1248,
      ),
      CategoryModel(
        name: "Fashion",
        icon: HugeIcons.strokeRoundedTShirt,
        color: Colors.pink.shade100,
        iconColor: Colors.pink.shade700,
        subcategories: ["Men", "Women", "Kids", "Accessories"],
        productCount: 3240,
      ),
      CategoryModel(
        name: "Home & Living",
        icon: HugeIcons.strokeRoundedHome04,
        color: Colors.orange.shade100,
        iconColor: Colors.orange.shade700,
        subcategories: ["Furniture", "Decor", "Kitchen", "Lighting"],
        productCount: 1892,
      ),
      CategoryModel(
        name: "Sports",
        icon: HugeIcons.strokeRoundedFootball,
        color: Colors.green.shade100,
        iconColor: Colors.green.shade700,
        subcategories: ["Outdoor", "Fitness", "Team Sports", "Cycling"],
        productCount: 956,
      ),
      CategoryModel(
        name: "Beauty",
        icon: HugeIcons.strokeRoundedAiBeautify,
        color: Colors.purple.shade100,
        iconColor: Colors.purple.shade700,
        subcategories: ["Makeup", "Skincare", "Hair Care", "Fragrances"],
        productCount: 2154,
      ),
      CategoryModel(
        name: "Books",
        icon: HugeIcons.strokeRoundedBook02,
        color: Colors.brown.shade100,
        iconColor: Colors.brown.shade700,
        subcategories: ["Fiction", "Non-Fiction", "Educational", "Comics"],
        productCount: 3421,
      ),
      CategoryModel(
        name: "Toys & Games",
        icon: HugeIcons.strokeRoundedToyTrain,
        color: Colors.yellow.shade100,
        iconColor: Colors.yellow.shade700,
        subcategories: ["Action Figures", "Board Games", "Puzzles", "Outdoor"],
        productCount: 763,
      ),
      CategoryModel(
        name: "Automotive",
        icon: HugeIcons.strokeRoundedCar01,
        color: Colors.red.shade100,
        iconColor: Colors.red.shade700,
        subcategories: ["Accessories", "Tools", "Parts", "Cleaning"],
        productCount: 543,
      ),
      CategoryModel(
        name: "Health",
        icon: HugeIcons.strokeRoundedHealth,
        color: Colors.teal.shade100,
        iconColor: Colors.teal.shade700,
        subcategories: ["Supplements", "Medical", "Fitness", "Wellness"],
        productCount: 1321,
      ),
      CategoryModel(
        name: "Groceries",
        icon: HugeIcons.strokeRoundedGraduationScroll,
        color: Colors.lime.shade100,
        iconColor: Colors.lime.shade800,
        subcategories: ["Fresh Food", "Beverages", "Snacks", "Household"],
        productCount: 2845,
      ),
      CategoryModel(
        name: "Pets",
        icon: HugeIcons.strokeRoundedDoughnut,
        color: Colors.amber.shade100,
        iconColor: Colors.amber.shade700,
        subcategories: ["Dog", "Cat", "Bird", "Fish"],
        productCount: 892,
      ),
      CategoryModel(
        name: "Jewelry",
        icon: HugeIcons.strokeRoundedDiamond,
        color: Colors.deepPurple.shade100,
        iconColor: Colors.deepPurple.shade700,
        subcategories: ["Rings", "Necklaces", "Earrings", "Bracelets"],
        productCount: 678,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Categories",
        onMenuTap: () {
          Scaffold.of(context).openDrawer();
        },
        onNotificationTap: () {},
        onFavouriteTap: () {},
        showMenu: true,
        showNotification: true,
        showFavourite: true,
      ),
      body: Stack(
        children: [
          YellowCorner(),
          BlueCenter(),
          RedCorner(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Banner
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.purple.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Shop by Category",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${categories.length} Categories • ${_getTotalProducts()} Products",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedCatalogue,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Featured Categories Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Featured Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.take(6).length,
                            itemBuilder: (context, index) {
                              return _buildFeaturedCategoryCard(
                                categories[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // All Categories List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "All Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return _buildCategoryListItem(categories[index]);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCategoryCard(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        _showCategoryDetails(category);
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              category.iconColor.withOpacity(0.1),
              category.iconColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: category.iconColor.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: category.icon,
                size: 32,
                color: category.iconColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: category.iconColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListItem(CategoryModel category) {
    return GestureDetector(
      onTap: () {
        _showCategoryDetails(category);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: HugeIcon(
                icon: category.icon,
                size: 28,
                color: category.iconColor,
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${category.subcategories.length} Subcategories • ${category.productCount} Products",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            // Arrow icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: category.iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryDetails(CategoryModel category) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                    child: HugeIcon(
                      icon: category.icon,
                      size: 32,
                      color: category.iconColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${category.productCount}+ Products",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Subcategories
              const Text(
                "Subcategories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    category.subcategories.map((sub) {
                      return Chip(
                        label: Text(sub),
                        backgroundColor: category.color,
                        labelStyle: TextStyle(color: category.iconColor),
                        side: BorderSide.none,
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              // View All Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to products screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: category.iconColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "View All Products",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  int _getTotalProducts() {
    return categories.fold(0, (sum, category) => sum + category.productCount);
  }
}

class CategoryModel {
  final String name;
  final List<List<dynamic>> icon;
  final Color color;
  final Color iconColor;
  final List<String> subcategories;
  final int productCount;

  CategoryModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.subcategories,
    required this.productCount,
  });
}

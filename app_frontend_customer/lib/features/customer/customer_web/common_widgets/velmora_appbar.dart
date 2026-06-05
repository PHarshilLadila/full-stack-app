import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class VelmoraAppBar extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const VelmoraAppBar({super.key, this.scaffoldKey});

  @override
  State<VelmoraAppBar> createState() => _VelmoraAppBarState();
}

class _VelmoraAppBarState extends State<VelmoraAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'Women';
  int _cartCount = 3;
  int _wishlistCount = 2;

  final List<String> _categories = [
    'Women',
    'Men',
    'Kids',
    'Beauty',
    'Home & Living',
    'Sale',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Column(
      children: [
        // Top promo banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Text(
            '✨ Free shipping on orders over ₹999 · Use code VELMORA20 for 20% off',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),

        // Main header
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: isMobile ? 12 : 16,
            ),
            child:
                isMobile ? _buildMobileHeader() : _buildDesktopHeader(isMobile),
          ),
        ),

        // Category Navigation Bar
      ],
    );
  }

  Widget _buildDesktopHeader(bool isMobile) {
    return Row(
      children: [
        // Logo
        GestureDetector(
          onTap: () {
            // Navigate to home
          },
          child: Text(
            'VELMORA',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.deepPurple.shade900,
            ),
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children:
                    _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 16,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                  color:
                                      isSelected
                                          ? Colors.deepPurple.shade700
                                          : Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (isSelected)
                                Container(
                                  height: 2,
                                  width: 20,
                                  color: Colors.deepPurple.shade700,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
        // Search Bar - Expanded
        Flexible(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.grey.shade500,
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey.shade500),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Icons
        Row(
          children: [
            _buildIconWithBadge(
              Icons.favorite_outline,
              'Wishlist',
              _wishlistCount,
            ),
            const SizedBox(width: 20),
            _buildIconWithBadge(
              Icons.shopping_bag_outlined,
              'Cart',
              _cartCount,
            ),
            const SizedBox(width: 20),
            _buildIcon(Icons.person_outline, 'Account'),
            const SizedBox(width: 20),
            Container(width: 1, height: 30, color: Colors.grey.shade300),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.deepPurple.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Menu Button
            IconButton(
              icon: Icon(Icons.menu, size: 28, color: Colors.grey.shade800),
              onPressed: () {
                widget.scaffoldKey?.currentState?.openDrawer();
              },
            ),

            // Logo
            Text(
              'VELMORA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.deepPurple.shade900,
              ),
            ),

            // Icons Row
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite_outline,
                    size: 24,
                    color: Colors.grey.shade800,
                  ),
                  onPressed: () {},
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        size: 24,
                        color: Colors.grey.shade800,
                      ),
                      onPressed: () {},
                    ),
                    if (_cartCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade700,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$_cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Search Bar
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.grey.shade500,
              ),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.grey.shade500,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 24, color: Colors.grey.shade700),
      ),
    );
  }

  Widget _buildIconWithBadge(IconData icon, String label, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 24, color: Colors.grey.shade700),
          ),
        ),
        if (count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade700,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// ==================== CUSTOM DRAWER ====================
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.deepPurple.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VELMORA',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back!',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.girl, 'Women', () {}),
                _buildDrawerItem(Icons.man, 'Men', () {}),
                _buildDrawerItem(Icons.child_care, 'Kids', () {}),
                _buildDrawerItem(Icons.spa, 'Beauty', () {}),
                _buildDrawerItem(Icons.home, 'Home & Living', () {}),
                _buildDrawerItem(Icons.local_offer, 'Sale', () {}),
                const Divider(),
                _buildDrawerItem(Icons.favorite_border, 'Wishlist', () {}),
                _buildDrawerItem(
                  Icons.shopping_bag_outlined,
                  'My Orders',
                  () {},
                ),
                _buildDrawerItem(Icons.person_outline, 'Account', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
    );
  }
}

// ==================== HERO BANNER ====================
class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      height: isMobile ? 300 : 500,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.shopping_bag,
                size: isMobile ? 150 : 300,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summer Collection 2026',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isMobile
                      ? 'Elevate Your\nStyle'
                      : 'Elevate Your Style\nWith Velmora',
                  style: TextStyle(
                    fontSize: isMobile ? 36 : 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Discover the latest trends in fashion, beauty, and home decor',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 32,
                      vertical: isMobile ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Shop Now →',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
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

// ==================== SECTION HEADER ====================
class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showViewAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        if (showViewAll)
          TextButton(
            onPressed: () {},
            child: Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Colors.deepPurple.shade700,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ==================== CATEGORY GRID ====================
class CategoryGrid extends StatelessWidget {
  CategoryGrid({super.key});

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.girl, 'name': 'Women', 'color': 0xFFFCE4EC},
    {'icon': Icons.man, 'name': 'Men', 'color': 0xFFE3F2FD},
    {'icon': Icons.child_care, 'name': 'Kids', 'color': 0xFFF3E5F5},
    {'icon': Icons.spa, 'name': 'Beauty', 'color': 0xFFE8F5E9},
    {'icon': Icons.home, 'name': 'Home', 'color': 0xFFFFF3E0},
    {'icon': Icons.local_offer, 'name': 'Sale', 'color': 0xFFFFEBEE},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 3 : (screenWidth < 1000 ? 4 : 6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(
            icon: category['icon'],
            name: category['name'],
            color: Color(category['color']),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;

  const _CategoryCard({
    required this.icon,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple.shade700),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== FEATURED PRODUCTS CAROUSEL ====================
class FeaturedProductsCarousel extends StatelessWidget {
  const FeaturedProductsCarousel({super.key});

  final List<Map<String, dynamic>> products = const [
    {'name': 'Elegant Dress', 'price': 2499, 'image': '👗', 'rating': 4.5},
    {'name': 'Casual Shoes', 'price': 1999, 'image': '👟', 'rating': 4.3},
    {'name': 'Leather Bag', 'price': 3499, 'image': '👜', 'rating': 4.7},
    {'name': 'Sunglasses', 'price': 1299, 'image': '🕶️', 'rating': 4.4},
    {'name': 'Watch', 'price': 3999, 'image': '⌚', 'rating': 4.8},
    {'name': 'Perfume', 'price': 1799, 'image': '🧴', 'rating': 4.6},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth =
        screenWidth < 600 ? 200.0 : (screenWidth < 1000 ? 220.0 : 260.0);

    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: itemWidth,
            margin: const EdgeInsets.only(right: 16),
            child: _ProductCard(
              name: product['name'],
              price: product['price'],
              image: product['image'],
              rating: product['rating'],
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final double rating;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Text(image, style: const TextStyle(fontSize: 60)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber.shade600),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹$price',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
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

// ==================== PROMO BANNER ====================
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Limited Time Offer',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isMobile ? 12 : 14,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isMobile
                      ? 'Get 20% OFF\non orders above ₹1999'
                      : 'Get 20% OFF on orders above ₹1999',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 20 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Use code: VELMORA20',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 32,
                      vertical: isMobile ? 10 : 14,
                    ),
                  ),
                  child: const Text(
                    'Shop Now →',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_offer,
                size: 60,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== NEW ARRIVALS GRID ====================
class NewArrivalsGrid extends StatelessWidget {
  const NewArrivalsGrid({super.key});

  final List<Map<String, dynamic>> newArrivals = const [
    {
      'name': 'Floral Summer Dress',
      'price': 2999,
      'image': '👗',
      'rating': 4.6,
      'isNew': true,
    },
    {
      'name': 'Cotton T-Shirt',
      'price': 999,
      'image': '👕',
      'rating': 4.4,
      'isNew': true,
    },
    {
      'name': 'Denim Jacket',
      'price': 4499,
      'image': '🧥',
      'rating': 4.7,
      'isNew': false,
    },
    {
      'name': 'Sports Shoes',
      'price': 3499,
      'image': '👟',
      'rating': 4.5,
      'isNew': true,
    },
    {
      'name': 'Handbag',
      'price': 3999,
      'image': '👜',
      'rating': 4.8,
      'isNew': false,
    },
    {
      'name': 'Sunglasses',
      'price': 1499,
      'image': '🕶️',
      'rating': 4.3,
      'isNew': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 1000 ? 3 : 4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.7,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: newArrivals.length,
        itemBuilder: (context, index) {
          final product = newArrivals[index];
          return _NewArrivalCard(
            name: product['name'],
            price: product['price'],
            image: product['image'],
            rating: product['rating'],
            isNew: product['isNew'],
          );
        },
      ),
    );
  }
}

class _NewArrivalCard extends StatelessWidget {
  final String name;
  final int price;
  final String image;
  final double rating;
  final bool isNew;

  const _NewArrivalCard({
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Text(image, style: const TextStyle(fontSize: 70)),
                ),
              ),
              if (isNew)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.grey.shade600,
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
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber.shade600),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹$price',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
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

// ==================== TESTIMONIALS SECTION ====================
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  final List<Map<String, dynamic>> testimonials = const [
    {
      'name': 'Priya Sharma',
      'review':
          'Amazing quality products! The fabric is premium and shipping was super fast. Highly recommend Velmora!',
      'rating': 5,
      'image': '👩',
    },
    {
      'name': 'Rahul Mehta',
      'review':
          'Best online shopping experience. The customer service is excellent and return policy is great.',
      'rating': 5,
      'image': '👨',
    },
    {
      'name': 'Anjali Patel',
      'review':
          'Love their collection! The dresses are stylish and comfortable. Will shop again.',
      'rating': 4,
      'image': '👩',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const SectionHeader(
            title: "What Our Customers Say",
            subtitle: "Join thousands of happy customers",
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child:
                isMobile
                    ? Column(
                      children:
                          testimonials
                              .map((t) => _TestimonialCard(data: t))
                              .toList(),
                    )
                    : Row(
                      children:
                          testimonials
                              .map(
                                (t) =>
                                    Expanded(child: _TestimonialCard(data: t)),
                              )
                              .toList(),
                    ),
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _TestimonialCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(data['image'], style: const TextStyle(fontSize: 50)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                index < data['rating'] ? Icons.star : Icons.star_border,
                size: 18,
                color: Colors.amber.shade600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['review'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['name'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class CommonFooter extends StatelessWidget {
  const CommonFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final isTablet =
        MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width < 1200;

    return Container(
      color: Color(0xFF0F172A),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal:
            isMobile
                ? 20
                : isTablet
                ? 40
                : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Footer Content
          if (isMobile)
            _buildMobileFooter()
          else if (isTablet)
            _buildTabletFooter()
          else
            _buildDesktopFooter(),

          const SizedBox(height: 48),

          // Divider
          Divider(color: Colors.grey.shade800, height: 1),

          const SizedBox(height: 24),

          // Bottom Bar
          _buildBottomBar(isMobile),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Column
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "V",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'VELMORA',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Your destination for premium fashion,\nbeauty, and lifestyle. Discover the best\nbrands, curated just for you.',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              // Social Icons
              Row(
                children: [
                  _buildSocialIcon(HugeIcons.strokeRoundedFacebook01),
                  const SizedBox(width: 12),
                  _buildSocialIcon(HugeIcons.strokeRoundedInstagram),
                  const SizedBox(width: 12),
                  _buildSocialIcon(HugeIcons.strokeRoundedTwitter),
                  const SizedBox(width: 12),
                  _buildSocialIcon(HugeIcons.strokeRoundedYoutube),
                ],
              ),
            ],
          ),
        ),

        // Company Column
        Expanded(
          child: _FooterColumn(
            title: 'Company',
            items: const ['About Us', 'Careers', 'Press', 'Blog', 'Investors'],
          ),
        ),

        // Help Column
        Expanded(
          child: _FooterColumn(
            title: 'Help',
            items: const [
              'Customer Support',
              'Track Order',
              'Returns & Exchanges',
              'FAQs',
              'Accessibility',
            ],
          ),
        ),

        // Legal Column
        Expanded(
          child: _FooterColumn(
            title: 'Legal',
            items: const [
              'Privacy Policy',
              'Terms of Service',
              'Cookie Policy',
              'Size Guide',
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletFooter() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VELMORA',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your destination for premium fashion, beauty, and lifestyle. Discover the best brands, curated just for you.',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Social Icons
                  Row(
                    children: [
                      _buildSocialIcon(HugeIcons.strokeRoundedFacebook01),
                      const SizedBox(width: 12),
                      _buildSocialIcon(HugeIcons.strokeRoundedInstagram),
                      const SizedBox(width: 12),
                      _buildSocialIcon(HugeIcons.strokeRoundedTwitter),
                    ],
                  ),
                ],
              ),
            ),

            // Company Column
            Expanded(
              child: _FooterColumn(
                title: 'Company',
                items: const [
                  'About Us',
                  'Careers',
                  'Press',
                  'Blog',
                  'Investors',
                ],
              ),
            ),

            // Help Column
            Expanded(
              child: _FooterColumn(
                title: 'Help',
                items: const [
                  'Customer Support',
                  'Track Order',
                  'Returns & Exchanges',
                  'FAQs',
                  'Size Guide',
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: _FooterColumn(
                title: 'Legal',
                items: const [
                  'Privacy Policy',
                  'Terms of Service',
                  'Cookie Policy',
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Section
        Center(
          child: Column(
            children: [
              Text(
                'VELMORA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your destination for premium fashion,\nbeauty, and lifestyle. Discover the best\nbrands, curated just for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              // Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(HugeIcons.strokeRoundedFacebook01),
                  const SizedBox(width: 16),
                  _buildSocialIcon(HugeIcons.strokeRoundedInstagram),
                  const SizedBox(width: 16),
                  _buildSocialIcon(HugeIcons.strokeRoundedTwitter),
                  const SizedBox(width: 16),
                  _buildSocialIcon(HugeIcons.strokeRoundedYoutube),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Company Section
        _FooterColumn(
          title: 'Company',
          items: const ['About Us', 'Careers', 'Press', 'Blog', 'Investors'],
        ),

        const SizedBox(height: 32),

        // Help Section
        _FooterColumn(
          title: 'Help',
          items: const [
            'Customer Support',
            'Track Order',
            'Returns & Exchanges',
            'FAQs',
            'Accessibility',
            'Size Guide',
          ],
        ),

        const SizedBox(height: 32),

        // Legal Section
        _FooterColumn(
          title: 'Legal',
          items: const ['Privacy Policy', 'Terms of Service', 'Cookie Policy'],
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isMobile) {
    return Column(
      children: [
        if (isMobile) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '© 2026 Velmora. All rights reserved.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 Velmora. All rights reserved.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              Row(
                children: [
                  _buildFooterLink('Privacy Policy'),
                  const SizedBox(width: 24),
                  _buildFooterLink('Terms of Service'),
                  const SizedBox(width: 24),
                  _buildFooterLink('Cookie Policy'),
                  const SizedBox(width: 24),
                  _buildFooterLink('Sitemap'),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {
        // Handle navigation
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
    );
  }

  Widget _buildSocialIcon(List<List<dynamic>> icon) {
    return InkWell(
      onTap: () {
        // Handle social media navigation
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: HugeIcon(icon: icon, size: 18, color: Colors.grey.shade400),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 18 : 16,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GestureDetector(
              onTap: () {
                // Handle footer item navigation
              },
              child: Text(
                item,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: isMobile ? 14 : 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

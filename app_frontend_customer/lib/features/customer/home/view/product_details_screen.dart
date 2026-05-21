// lib/features/customer/home/screen/product_details_screen.dart

import 'dart:async';

import 'package:app_frontend_customer/features/customer/favorite/bloc/favorites_bloc.dart';
import 'package:app_frontend_customer/features/customer/favorite/bloc/favorites_event.dart';
import 'package:app_frontend_customer/features/customer/favorite/bloc/favorites_state.dart';
import 'package:app_frontend_customer/features/customer/favorite/service/favorites_service.dart';
import 'package:app_frontend_customer/features/customer/home/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:app_frontend_customer/features/customer/home/bloc/product_details_bloc/product_details_event.dart';
import 'package:app_frontend_customer/features/customer/home/bloc/product_details_bloc/product_details_state.dart';
import 'package:app_frontend_customer/utils/common/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_frontend_customer/features/customer/home/model/product_model.dart';
import 'package:app_frontend_customer/features/customer/home/service/product_details_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => ProductDetailsBloc(
                productDetailsService: ProductDetailsService(),
              )..add(FetchProductDetails(productId: productId)),
        ),
        BlocProvider(
          create:
              (context) => FavoritesBloc(favoritesService: FavoritesService()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: const ProductDetailsView(),
      ),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const CustomLoader(loadingPageName: 'Details');
        } else if (state is ProductDetailsLoaded) {
          return _ProductDetailsContent(product: state.product);
        } else if (state is ProductDetailsError) {
          return _ErrorView(message: state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final ProductDetails product;
  const _ProductDetailsContent({Key? key, required this.product})
    : super(key: key);

  @override
  State<_ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<_ProductDetailsContent>
    with SingleTickerProviderStateMixin {
  int _selectedImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  StreamSubscription<FavoritesState>? _favoritesSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Check if product is already in favorites
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _favoritesSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkFavoriteStatus() async {
    final favoritesBloc = context.read<FavoritesBloc>();
    final currentState = favoritesBloc.state;

    if (currentState is FavoritesLoaded) {
      setState(() {
        _isFavorite = currentState.favorites.any(
          (item) => item.productId == widget.product.id,
        );
      });
    } else {
      // Fetch favorites if not loaded
      favoritesBloc.add(const FetchFavorites());

      // Listen for state changes
      _favoritesSubscription = favoritesBloc.stream.listen((state) {
        if (state is FavoritesLoaded && mounted) {
          setState(() {
            _isFavorite = state.favorites.any(
              (item) => item.productId == widget.product.id,
            );
          });
          _favoritesSubscription?.cancel();
        }
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final favoritesBloc = context.read<FavoritesBloc>();

    // Start animation
    _animationController.forward(from: 0.0);

    // Store the previous state for potential rollback
    final previousFavoriteState = _isFavorite;

    // Optimistically update UI
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Declare subscription outside the if-else blocks
    StreamSubscription<FavoritesState>? subscription;

    if (previousFavoriteState) {
      // Remove from favorites
      favoritesBloc.add(RemoveFromFavorites(productId: widget.product.id));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Removed from favorites'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.grey[800],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Listen for errors to revert if needed
      subscription = favoritesBloc.stream.listen((state) {
        if (state is ToggleFavoriteError &&
            state.productId == widget.product.id &&
            mounted) {
          setState(() {
            _isFavorite = previousFavoriteState;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          subscription?.cancel();
        } else if (state is ToggleFavoriteSuccess &&
            state.productId == widget.product.id &&
            mounted) {
          subscription?.cancel();
        }
      });
    } else {
      // Add to favorites
      favoritesBloc.add(AddToFavorites(productId: widget.product.id));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Added to favorites'),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Listen for errors to revert if needed
      subscription = favoritesBloc.stream.listen((state) {
        if (state is ToggleFavoriteError &&
            state.productId == widget.product.id &&
            mounted) {
          setState(() {
            _isFavorite = previousFavoriteState;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          subscription?.cancel();
        } else if (state is ToggleFavoriteSuccess &&
            state.productId == widget.product.id &&
            mounted) {
          subscription?.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // App Bar with Back Button and Actions
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.45,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black87,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      final isToggling =
                          state is ToggleFavoriteLoading &&
                          state.productId == widget.product.id;

                      if (isToggling) {
                        return Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFFF6B6B),
                              ),
                            ),
                          ),
                        );
                      }

                      return ScaleTransition(
                        scale: _scaleAnimation,
                        child: IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              _isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey(_isFavorite),
                              color: _isFavorite ? Colors.red : Colors.black87,
                              size: 26,
                            ),
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      );
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(background: _buildImageGallery()),
            ),

            // Product Details Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(),
                  const Divider(
                    height: 32,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildPriceSection(),
                  const Divider(
                    height: 32,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildQuantitySelector(),
                  const Divider(
                    height: 32,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildTags(),
                  const Divider(
                    height: 32,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildDescription(),
                  const Divider(
                    height: 32,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildSpecifications(),
                  const SizedBox(height: 100), // Bottom padding for FAB
                ],
              ),
            ),
          ],
        ),
        // Bottom Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ProductDetailsBottomBar(
            product: widget.product,
            quantity: _quantity,
            onAddToCart: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to cart!'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color(0xFFFF6B6B),
                ),
              );
            },
            onBuyNow: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Buy now feature coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    final List<String> allImages = [
      widget.product.mainBannerImage,
      ...widget.product.multipleImages,
    ];

    return Column(
      children: [
        // Main Image
        Expanded(
          flex: 4,
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 4.0,
            child: Image.network(
              allImages[_selectedImageIndex],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),

        // Thumbnails
        if (allImages.length > 1)
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedImageIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImageIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFFFF6B6B)
                                : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF6B6B,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                ),
                              ]
                              : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        allImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.image, size: 30),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category & Subcategory
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.product.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.product.subCategory,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Product Name
          Text(
            widget.product.productName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // Seller Info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.store_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.sellerName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      'Seller',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              if (widget.product.rating > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.product.totalReviews})',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.product.formattedPrice,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(width: 12),
              if (widget.product.discountPrice > 0)
                Text(
                  widget.product.formattedOriginalPrice,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const Spacer(),
              if (widget.product.discountPercentage > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.product.discountPercentage.toStringAsFixed(0)}% OFF',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.verified_rounded,
                size: 16,
                color: Colors.green.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Inclusive of all taxes',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quantity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove_rounded,
                      onTap: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                    Container(
                      width: 50,
                      child: Text(
                        _quantity.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add_rounded,
                      onTap: () {
                        if (_quantity < widget.product.stock) {
                          setState(() {
                            _quantity++;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (!widget.product.stockAvailable)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 18,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Out of Stock',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.product.stock} items available',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildTags() {
    if (widget.product.tags.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tags',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                widget.product.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF6B6B).withOpacity(0.1),
                          const Color(0xFFFF8E53).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFF6B6B).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF6B6B),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.shortDescription,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.product.detailedDescription,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    if (widget.product.specifications.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.product.specifications.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final key = widget.product.specifications.keys.elementAt(index);
                final value = widget.product.specifications[key];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          key,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          value.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom FAB for Add to Cart/Buy Now
class ProductDetailsBottomBar extends StatelessWidget {
  final ProductDetails product;
  final int quantity;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductDetailsBottomBar({
    Key? key,
    required this.product,
    required this.quantity,
    required this.onAddToCart,
    required this.onBuyNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total Price
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                TweenAnimationBuilder(
                  tween: Tween<double>(
                    begin: 0,
                    end: product.discountedPrice * quantity,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Text(
                      '₹${value.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B6B),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: product.stockAvailable ? onAddToCart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFF6B6B),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: const Color(0xFFFF6B6B), width: 1.5),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Buy Now Button
          Expanded(
            child: ElevatedButton(
              onPressed: product.stockAvailable ? onBuyNow : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

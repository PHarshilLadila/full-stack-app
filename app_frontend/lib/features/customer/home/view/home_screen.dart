// lib/features/customer/home/screen/home_screen.dart

import 'dart:developer';

import 'package:app_frontend/features/customer/home/bloc/product_bloc.dart';
import 'package:app_frontend/features/customer/home/bloc/product_event.dart';
import 'package:app_frontend/features/customer/home/bloc/product_state.dart';
import 'package:app_frontend/features/customer/home/model/product_model.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:app_frontend/utils/common/custom_appbar.dart';
import 'package:app_frontend/utils/common/custom_loader.dart';
import 'package:app_frontend/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  late UserBloc _userBloc;

  final TextEditingController _searchController = TextEditingController();

  String authToken = "";
  Set<String> favoriteProductIds = {};

  Future<void> getUserToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final token = preferences.getString("auth_token");

    setState(() {
      authToken = token ?? "";
    });

    log("Token ====> $authToken");

    if (authToken.isNotEmpty) {
      _userBloc.add(FetchUserProfile(authToken));
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    _userBloc = UserBloc(userService: UserService());

    context.read<ProductBloc>().add(const FetchProducts());

    getUserToken();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _userBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ProductBloc>().state;

      if (state is ProductLoaded && !state.hasReachedMax) {
        context.read<ProductBloc>().add(
          LoadMoreProducts(page: state.pagination.currentPage + 1),
        );
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Discover",
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
          const YellowCorner(),
          const BlueCenter(),
          const RedCorner(),
          SafeArea(
            child: Column(
              children: [
                BlocProvider.value(
                  value: _userBloc,
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedBox(
                            height: 40,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      if (state is UserLoaded) {
                        final greeting = _getGreeting();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$greeting,',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${state.user.fullName} 👋',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is UserError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome,',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Text(
                                  'Guest User 👋',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sign in to access more features',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()},',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                'Guest User 👋',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                _buildSearchBar(),

                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading ||
                          state is ProductSearchLoading) {
                        return const CustomLoader(loadingPageName: 'Products');
                      }

                      if (state is ProductLoaded) {
                        return _buildProductList(state.products);
                      }

                      if (state is ProductSearchLoaded) {
                        return _buildProductList(state.products);
                      }

                      if (state is ProductError) {
                        return _buildErrorWidget(state.message);
                      }

                      return const Center(child: Text('No products available'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 48,
        child: AppTextField(
          controller: _searchController,
          hintText: "Search products...",
          icon: Icons.search,
          contentPadding: const EdgeInsets.only(top: 12),
          onFieldSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              context.read<ProductBloc>().add(
                SearchProducts(query: value.trim()),
              );
            } else {
              context.read<ProductBloc>().add(const FetchProducts());
            }
          },
          sufixIcon: IconButton(
            onPressed: () {
              _searchController.clear();

              context.read<ProductBloc>().add(const FetchProducts());
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }

  // =========================
  // PRODUCT LIST
  // =========================

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children:
            products.map((product) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 36) / 2,
                child: _buildProductCard(product),
              );
            }).toList(),
      ),
    );
  }

  // =========================
  // PRODUCT CARD
  // =========================

  Widget _buildProductCard(Product product) {
    final bool isFavorite = favoriteProductIds.contains(product.id);
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    product.mainBannerImage,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 170,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      );
                    },
                  ),
                ),

                if (product.discountPrice > 0)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
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
                  // CATEGORY
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // PRODUCT NAME
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // PRICE
                  Row(
                    children: [
                      Text(
                        '₹${product.discountedPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 6),

                      if (product.discountPrice > 0)
                        Expanded(
                          child: Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // RATING
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.orange,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          '(${product.totalReviews})',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                      Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color:
                              isFavorite
                                  ? Colors.red.withOpacity(0.12)
                                  : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          splashRadius: 20,
                          onPressed: () {
                            setState(() {
                              if (isFavorite) {
                                favoriteProductIds.remove(product.id);
                              } else {
                                favoriteProductIds.add(product.id);
                              }
                            });
                          },
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey(isFavorite),
                              color:
                                  isFavorite
                                      ? Colors.red
                                      : Colors.grey.shade600,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // STOCK
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          product.stockAvailable
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        product.stockAvailable ? 'In Stock' : 'Out Of Stock',
                        style: TextStyle(
                          color:
                              product.stockAvailable
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // ERROR WIDGET
  // =========================

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),

          const SizedBox(height: 16),

          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(RefreshProducts());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

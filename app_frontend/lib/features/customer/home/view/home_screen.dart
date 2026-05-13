// lib/features/home/screen/home_screen.dart

import 'package:app_frontend/features/customer/home/bloc/product_bloc.dart';
import 'package:app_frontend/features/customer/home/bloc/product_event.dart';
import 'package:app_frontend/features/customer/home/bloc/product_state.dart';
import 'package:app_frontend/features/customer/home/model/product_model.dart';
import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:app_frontend/utils/common/custom_appbar.dart';
import 'package:app_frontend/utils/common/custom_loader.dart';
import 'package:app_frontend/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Fetch products when screen loads
    context.read<ProductBloc>().add(const FetchProducts());
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
                _buildSearchBar(),
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return CustomLoader(loadingPageName: 'Products');
                      } else if (state is ProductLoaded) {
                        return _buildProductList(state.products);
                      } else if (state is ProductError) {
                        return _buildErrorWidget(state.message);
                      } else if (state is ProductSearchLoading) {
                        return CustomLoader(loadingPageName: 'Products');
                      } else if (state is ProductSearchLoaded) {
                        return _buildProductList(state.products);
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
    TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 45,
        child: AppTextField(
          controller: controller,
          hintText: "Search products...",
          icon: Icons.search,
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              context.read<ProductBloc>().add(SearchProducts(query: value));
            } else {
              context.read<ProductBloc>().add(const FetchProducts());
            }
          },
          contentPadding: EdgeInsets.only(top: 12),
          sufixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              context.read<ProductBloc>().add(const FetchProducts());
            },
          ),
        ),

        // TextField(
        //   decoration: InputDecoration(
        //     hintText: 'Search products...',
        //     prefixIcon: const Icon(Icons.search),
        //     suffixIcon: IconButton(
        //       icon: const Icon(Icons.clear),
        //       onPressed: () {
        //         context.read<ProductBloc>().add(const FetchProducts());
        //       },
        //     ),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        //     filled: true,
        //     contentPadding: EdgeInsets.only(top: 14),
        //     fillColor: Colors.white,
        //   ),
        //   onSubmitted: (value) {
        //     if (value.isNotEmpty) {
        //       context.read<ProductBloc>().add(SearchProducts(query: value));
        //     } else {
        //       context.read<ProductBloc>().add(const FetchProducts());
        //     }
        //   },
        // ),
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details screen
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                product.mainBannerImage,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${product.discountedPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (product.discountPrice > 0) ...[
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          ' ${product.rating.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${product.totalReviews} reviews)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!product.stockAvailable)
                          const Text(
                            'Out of Stock',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

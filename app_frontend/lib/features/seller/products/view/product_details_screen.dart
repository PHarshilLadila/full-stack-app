// ignore_for_file: deprecated_member_use

import 'dart:ui' as ui;

import 'package:app_frontend/utils/common/custom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_frontend/features/seller/products/bloc/product_details_bloc.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:hugeicons/hugeicons.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              ProductDetailsBloc(ProductService())
                ..add(FetchProductDetailsEvent(productId)),
      child: const ProductDetailsView(),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const CustomLoader(loadingPageName: 'Product Details');
          }

          if (state is ProductDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedAlertCircle,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFDBB12),
                      foregroundColor: Colors.black,
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
            );
          }

          if (state is ProductDetailsLoaded) {
            return Stack(
              children: [
                RedCorner(),
                BlueCenter(),
                YellowCorner(),
                _ProductDetailsContent(product: state.product),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final ProductModel product;

  const _ProductDetailsContent({required this.product});

  @override
  State<_ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<_ProductDetailsContent> {
  late final PageController _pageController;
  int selectedImageIndex = 0;
  int quantity = 1;
  bool isFavorite = false;
  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [
      widget.product.mainBannerImage,
      ...widget.product.multipleImages,
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Expanded content that scrolls
          Expanded(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.45,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  leading: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowLeft01,
                        size: 18,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        icon: Icon(
                          isFavorite
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: isFavorite ? Colors.red : Colors.black,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Added to favorites'
                                    : 'Removed from favorites',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        // Main Image with PageView
                        Container(
                          color: Colors.grey.shade50,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                selectedImageIndex = index;
                              });
                            },
                            itemCount: allImages.length,
                            itemBuilder: (context, index) {
                              return Hero(
                                tag: 'product_${widget.product.id}_$index',
                                child: Image.network(
                                  allImages[index],
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          HugeIcon(
                                            icon:
                                                HugeIcons.strokeRoundedPassport,
                                            size: 80,
                                            color: Colors.grey.shade400,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Image not available',
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        // Image Counter
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${selectedImageIndex + 1}/${allImages.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        // Thumbnail Images
                        if (allImages.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 80,
                            child: SizedBox(
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: allImages.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImageIndex = index;
                                        // Animate to the selected image in PageView
                                        _pageController.animateToPage(
                                          index,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: 55,
                                      height: 55,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              selectedImageIndex == index
                                                  ? const Color(0xffFDBB12)
                                                  : Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          allImages[index],
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Colors.grey.shade200,
                                              child: HugeIcon(
                                                icon:
                                                    HugeIcons
                                                        .strokeRoundedBrokenBone,
                                                size: 30,
                                                color: Colors.grey.shade600,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Product Details
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Info Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Tags
                            Row(
                              children: [
                                _buildCategoryChip(
                                  widget.product.category,
                                  Colors.amber,
                                ),
                                const SizedBox(width: 8),
                                _buildCategoryChip(
                                  widget.product.subCategory,
                                  Colors.grey,
                                ),
                                const Spacer(),
                                if (widget.product.discountPrice <
                                    widget.product.price)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xffFDBB12),
                                          Color(0xffFF9800),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${((widget.product.price - widget.product.discountPrice) / widget.product.price * 100).toInt()}% OFF',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
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
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Seller & Rating Row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedStore03,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.product.sellerName,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedStar,
                                        size: 14,
                                        color: const Color(0xffFDBB12),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.product.rating}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        ' (${widget.product.totalReviews})',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Price Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber.shade100.withOpacity(0.3),
                                    Colors.amber.shade100,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${widget.product.discountPrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  if (widget.product.discountPrice <
                                      widget.product.price)
                                    Text(
                                      '₹${widget.product.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Save ₹${widget.product.price - widget.product.discountPrice}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Stock Status
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    widget.product.stockAvailable
                                        ? Colors.green.shade50
                                        : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  HugeIcon(
                                    icon:
                                        widget.product.stockAvailable
                                            ? HugeIcons
                                                .strokeRoundedCheckmarkCircle01
                                            : HugeIcons
                                                .strokeRoundedCancelCircle,
                                    color:
                                        widget.product.stockAvailable
                                            ? Colors.green
                                            : Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      widget.product.stockAvailable
                                          ? 'In Stock • ${widget.product.stock} units available'
                                          : 'Out of Stock',
                                      style: TextStyle(
                                        color:
                                            widget.product.stockAvailable
                                                ? Colors.green
                                                : Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Quantity Selector
                            if (widget.product.stockAvailable)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Total Quantity',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: HugeIcon(
                                              icon:
                                                  HugeIcons
                                                      .strokeRoundedMinusSign,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              // if (_quantity > 1) {
                                              //   setState(() => _quantity--);
                                              // }
                                            },
                                          ),
                                          Container(
                                            width: 40,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${widget.product.stock}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: HugeIcon(
                                              icon:
                                                  HugeIcons
                                                      .strokeRoundedPlusSign,
                                              size: 18,
                                              color: const Color(0xffFDBB12),
                                            ),
                                            onPressed: () {
                                              // if (_quantity <
                                              //     widget.product.stock) {
                                              //   setState(() => _quantity++);
                                              // }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 24),

                            // Description Section
                            _buildSectionTitle(
                              'Description',
                              HugeIcons.strokeRoundedNote01,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.product.shortDescription,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Detailed Description
                            if (widget
                                .product
                                .detailedDescription
                                .isNotEmpty) ...[
                              _buildSectionTitle(
                                'Product Details',
                                HugeIcons.strokeRoundedFolderDetailsReference,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.product.detailedDescription,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Specifications
                            if (widget.product.specifications.isNotEmpty) ...[
                              _buildSectionTitle(
                                'Specifications',
                                HugeIcons.strokeRoundedSetting07,
                              ),
                              const SizedBox(height: 12),
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey.shade50,
                              //     borderRadius: BorderRadius.circular(20),
                              //   ),
                              //   child: ListView.separated(
                              //     shrinkWrap: true,
                              //     physics: const NeverScrollableScrollPhysics(),
                              //     itemCount:
                              //         widget.product.specifications.length,
                              //     separatorBuilder:
                              //         (context, index) => Divider(
                              //           color: Colors.grey.shade200,
                              //           height: 0,
                              //         ),
                              //     itemBuilder: (context, index) {
                              //       final entry = widget
                              //           .product
                              //           .specifications
                              //           .entries
                              //           .elementAt(index);
                              //       return Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //           horizontal: 16,
                              //           vertical: 14,
                              //         ),
                              //         child: Row(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           children: [
                              //             SizedBox(
                              //               width: 110,
                              //               child: Text(
                              //                 entry.key,
                              //                 style: const TextStyle(
                              //                   fontWeight: FontWeight.w600,
                              //                   color: Colors.black,
                              //                   fontSize: 14,
                              //                 ),
                              //               ),
                              //             ),
                              //             Expanded(
                              //               child: Text(
                              //                 entry.value.toString(),
                              //                 style: const TextStyle(
                              //                   color: Colors.grey,
                              //                   fontSize: 14,
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ui.ImageFilter.blur(
                                      sigmaX: 99.0,
                                      sigmaY: 99.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            widget
                                                .product
                                                .specifications
                                                .length,
                                        separatorBuilder:
                                            (context, index) => Divider(
                                              color: Colors.grey.shade200
                                                  .withOpacity(0.5),
                                              height: 0,
                                            ),
                                        itemBuilder: (context, index) {
                                          final entry = widget
                                              .product
                                              .specifications
                                              .entries
                                              .elementAt(index);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    entry.key,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    entry.value.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Tags
                            if (widget.product.tags.isNotEmpty) ...[
                              _buildSectionTitle(
                                'Tags',
                                HugeIcons.strokeRoundedTag01,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    widget.product.tags.map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          '#$tag',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ],

                            // Add bottom padding to prevent content from hiding behind bottom bar
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Fixed Bottom Bar (doesn't scroll)
          // _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            (color == Colors.amber
                ? Colors.amber.shade50
                : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color:
              color == Colors.amber
                  ? Colors.amber.shade800
                  : Colors.grey.shade600,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, List<List<dynamic>> icon) {
    return Row(
      children: [
        HugeIcon(icon: icon, size: 20, color: const Color(0xffFDBB12)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Widget _buildBottomBar() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.08),
  //           blurRadius: 20,
  //           offset: const Offset(0, -4),
  //         ),
  //       ],
  //     ),
  //     child: SafeArea(
  //       child: Row(
  //         children: [
  //           // Cart Button
  //           Expanded(
  //             flex: 1,
  //             child: GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   isAddedToCart = !isAddedToCart;
  //                 });
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text(
  //                       isAddedToCart
  //                           ? 'Added to cart • Quantity: $quantity'
  //                           : 'Removed from cart',
  //                     ),
  //                     duration: const Duration(seconds: 1),
  //                     backgroundColor:
  //                         isAddedToCart ? Colors.green : Colors.red,
  //                   ),
  //                 );
  //               },
  //               child: Container(
  //                 height: 52,
  //                 decoration: BoxDecoration(
  //                   color:
  //                       isAddedToCart
  //                           ? Colors.green.shade50
  //                           : Colors.grey.shade100,
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(
  //                     color: isAddedToCart ? Colors.green : Colors.transparent,
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     HugeIcon(
  //                       icon: HugeIcons.strokeRoundedShoppingCart01,
  //                       color:
  //                           isAddedToCart
  //                               ? Colors.green
  //                               : Colors.grey.shade600,
  //                       size: 22,
  //                     ),
  //                     const SizedBox(height: 2),
  //                     Text(
  //                       isAddedToCart ? 'Added' : 'Cart',
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         color:
  //                             isAddedToCart
  //                                 ? Colors.green
  //                                 : Colors.grey.shade600,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: 12),

  //           // Buy Now Button
  //           Expanded(
  //             flex: 2,
  //             child: ElevatedButton(
  //               onPressed:
  //                   widget.product.stockAvailable
  //                       ? () {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(
  //                             content: Text(
  //                               'Proceeding to checkout with $quantity item(s)',
  //                             ),
  //                             duration: const Duration(seconds: 1),
  //                           ),
  //                         );
  //                       }
  //                       : null,
  //               style: ElevatedButton.styleFrom(
  //                 elevation: 0,
  //                 backgroundColor: const Color(0xffFDBB12),
  //                 foregroundColor: Colors.black,
  //                 disabledBackgroundColor: Colors.grey.shade300,
  //                 padding: const EdgeInsets.symmetric(vertical: 14),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(16),
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   HugeIcon(
  //                     icon: HugeIcons.strokeRoundedFlash,
  //                     size: 20,
  //                     color: Colors.black,
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Text(
  //                     widget.product.stockAvailable
  //                         ? 'Buy Now'
  //                         : 'Out of Stock',
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 16,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

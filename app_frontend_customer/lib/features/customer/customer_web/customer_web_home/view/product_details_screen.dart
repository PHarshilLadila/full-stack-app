// lib/features/customer/customer_web/screens/product_details_screen.dart
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_details/product_details_bloc.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_details/product_details_event.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_details/product_details_model.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_details/product_details_state.dart';
import 'package:app_frontend_customer/features/customer/customer_web/bloc/product_review/product_reviews_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_frontend_customer/service/customer_web_service.dart';

// ─── Velmora colour tokens ───────────────────────────────────────────────────
const _kPrimary = Color(0xFF5B21B6); // deep-purple brand
const _kPrimaryLight = Color(0xFFF5F3FF);
// const _kAccent = Color(0xFFFF6B35); // discount badge orange
const _kBg = Color(0xFFF8F9FA);
const _kSurface = Colors.white;
const _kBorder = Color(0xFFE5E7EB);
const _kTextPrimary = Color(0xFF111827);
const _kTextSecondary = Color(0xFF6B7280);
const _kGold = Color(0xFFF59E0B);
const _kGreen = Color(0xFF059669);
const _kRed = Color(0xFFDC2626);

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ProductDetailsBloc(customerWebService: CustomerWebService())
                ..add(LoadProductDetails(productId: productId)),
      child: _ProductDetailsContent(productId: productId),
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final String productId;
  const _ProductDetailsContent({required this.productId});

  @override
  State<_ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<_ProductDetailsContent> {
  int _selectedTab = 0;
  int _quantity = 1;
  String _selectedColor = 'Midnight Navy';
  String _selectedSize = 'M';

  final List<String> _colors = [
    '#1e293b',
    '#3b82f6',
    '#6b7280',
    '#9ca3af',
    '#7c3aed',
  ];
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final isTablet = w >= 768 && w < 1200;

    return Scaffold(
      backgroundColor: _kBg,
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _kPrimary),
            );
          }
          if (state is ProductDetailsError) {
            return _ErrorView(
              message: state.message,
              onRetry:
                  () => context.read<ProductDetailsBloc>().add(
                    LoadProductDetails(productId: widget.productId),
                  ),
            );
          }
          if (state is ProductDetailsLoaded) {
            return _buildBody(context, state, isMobile, isTablet);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProductDetailsLoaded state,
    bool isMobile,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Breadcrumb ──────────────────────────────────────────────────
          _Breadcrumb(isMobile: isMobile),

          // ── Main product section ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 16
                      : isTablet
                      ? 32
                      : 80,
              vertical: 24,
            ),
            child:
                isMobile
                    ? _MobileProductTop(
                      state: state,
                      quantity: _quantity,
                      selectedColor: _selectedColor,
                      selectedSize: _selectedSize,
                      colors: _colors,
                      sizes: _sizes,
                      onColorChanged: (c) => setState(() => _selectedColor = c),
                      onSizeChanged: (s) => setState(() => _selectedSize = s),
                      onQuantityChanged: (q) => setState(() => _quantity = q),
                      onAddToCart: () => _addToCart(context, state.product),
                      onBuyNow: () {},
                      onBloc: context.read<ProductDetailsBloc>(),
                    )
                    : _DesktopProductTop(
                      state: state,
                      quantity: _quantity,
                      selectedColor: _selectedColor,
                      selectedSize: _selectedSize,
                      colors: _colors,
                      sizes: _sizes,
                      onColorChanged: (c) => setState(() => _selectedColor = c),
                      onSizeChanged: (s) => setState(() => _selectedSize = s),
                      onQuantityChanged: (q) => setState(() => _quantity = q),
                      onAddToCart: () => _addToCart(context, state.product),
                      onBuyNow: () {},
                      bloc: context.read<ProductDetailsBloc>(),
                    ),
          ),

          // ── Tab bar ───────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 16
                      : isTablet
                      ? 32
                      : 80,
            ),
            child: _TabBar(
              selected: _selectedTab,
              totalReviews: state.totalReviews,
              onTap: (i) => setState(() => _selectedTab = i),
            ),
          ),

          // ── Tab content ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 16
                      : isTablet
                      ? 32
                      : 80,
              vertical: 24,
            ),
            child: _buildTabContent(state, isMobile),
          ),

          // ── Seller card ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isMobile
                      ? 16
                      : isTablet
                      ? 32
                      : 80,
              vertical: 8,
            ),
            child: _SellerCard(sellerName: state.product.sellerName),
          ),

          const SizedBox(height: 40),

          // ── Customer Reviews ──────────────────────────────────────────────
          _ReviewsSection(state: state, isMobile: isMobile),

          const SizedBox(height: 40),

          // ── Related Products ──────────────────────────────────────────────
          _RelatedProducts(isMobile: isMobile, isTablet: isTablet),

          const SizedBox(height: 40),

          // ── Footer ────────────────────────────────────────────────────────
          const _Footer(),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProductDetailsLoaded state, bool isMobile) {
    switch (_selectedTab) {
      case 0:
        return _DescriptionTab(product: state.product);
      case 1:
        return _SpecificationsTab(product: state.product);
      case 2:
        return _ReviewsTab(state: state, isMobile: isMobile);
      case 3:
        return _RelatedProductsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  void _addToCart(BuildContext context, ProductDetailsData product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: _kPrimary,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BREADCRUMB
// ─────────────────────────────────────────────────────────────────────────────
class _Breadcrumb extends StatelessWidget {
  final bool isMobile;
  const _Breadcrumb({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    if (isMobile) return const SizedBox.shrink();
    return Container(
      color: _kSurface,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
      child: Row(
        children: [
          _crumb('Home'),
          _sep(),
          _crumb('Women'),
          _sep(),
          _crumb('Tops & Tees'),
          _sep(),
          Text(
            'Ribbed Turtleneck',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: _kTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _crumb(String label) => GestureDetector(
    onTap: () {},
    child: Text(
      label,
      style: GoogleFonts.inter(fontSize: 13, color: _kTextSecondary),
    ),
  );

  Widget _sep() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 6),
    child: Icon(Icons.chevron_right, size: 14, color: _kTextSecondary),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// DESKTOP PRODUCT TOP (left=gallery, right=info)
// ─────────────────────────────────────────────────────────────────────────────
class _DesktopProductTop extends StatelessWidget {
  final ProductDetailsLoaded state;
  final int quantity;
  final String selectedColor;
  final String selectedSize;
  final List<String> colors;
  final List<String> sizes;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final ProductDetailsBloc bloc;

  const _DesktopProductTop({
    required this.state,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
    required this.colors,
    required this.sizes,
    required this.onColorChanged,
    required this.onSizeChanged,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onBuyNow,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gallery
        SizedBox(width: 480, child: _ImageGallery(state: state, bloc: bloc)),
        const SizedBox(width: 48),
        // Info
        Expanded(
          child: _ProductInfo(
            state: state,
            quantity: quantity,
            selectedColor: selectedColor,
            selectedSize: selectedSize,
            colors: colors,
            sizes: sizes,
            onColorChanged: onColorChanged,
            onSizeChanged: onSizeChanged,
            onQuantityChanged: onQuantityChanged,
            onAddToCart: onAddToCart,
            onBuyNow: onBuyNow,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MOBILE PRODUCT TOP (stacked)
// ─────────────────────────────────────────────────────────────────────────────
class _MobileProductTop extends StatelessWidget {
  final ProductDetailsLoaded state;
  final int quantity;
  final String selectedColor;
  final String selectedSize;
  final List<String> colors;
  final List<String> sizes;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final ProductDetailsBloc onBloc;

  const _MobileProductTop({
    required this.state,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
    required this.colors,
    required this.sizes,
    required this.onColorChanged,
    required this.onSizeChanged,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onBuyNow,
    required this.onBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageGallery(state: state, bloc: onBloc),
        const SizedBox(height: 24),
        _ProductInfo(
          state: state,
          quantity: quantity,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
          colors: colors,
          sizes: sizes,
          onColorChanged: onColorChanged,
          onSizeChanged: onSizeChanged,
          onQuantityChanged: onQuantityChanged,
          onAddToCart: onAddToCart,
          onBuyNow: onBuyNow,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE GALLERY
// ─────────────────────────────────────────────────────────────────────────────
class _ImageGallery extends StatelessWidget {
  final ProductDetailsLoaded state;
  final ProductDetailsBloc bloc;

  const _ImageGallery({required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final allImages = [
      state.product.mainBannerImage,
      ...state.product.multipleImages,
    ];
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vertical thumbnails (desktop only)
        if (!isMobile) ...[
          SizedBox(
            width: 72,
            child: Column(
              children: List.generate(allImages.length, (i) {
                final isSelected = state.selectedImageIndex == i;
                return GestureDetector(
                  onTap: () => bloc.add(SelectProductImage(index: i)),
                  child: Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? _kPrimary : _kBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: _NetworkImageWidget(url: allImages[i]),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 12),
        ],

        // Main image
        Expanded(
          child: Column(
            children: [
              Container(
                height: isMobile ? 300 : 480,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _kBorder),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      _NetworkImageWidget(
                        url: allImages[state.selectedImageIndex],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      // Nav arrows
                      if (allImages.length > 1) ...[
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _ArrowButton(
                              icon: Icons.chevron_left,
                              onTap: () {
                                final prev =
                                    (state.selectedImageIndex -
                                        1 +
                                        allImages.length) %
                                    allImages.length;
                                bloc.add(SelectProductImage(index: prev));
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _ArrowButton(
                              icon: Icons.chevron_right,
                              onTap: () {
                                final next =
                                    (state.selectedImageIndex + 1) %
                                    allImages.length;
                                bloc.add(SelectProductImage(index: next));
                              },
                            ),
                          ),
                        ),
                      ],
                      // Zoom icon
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.zoom_in,
                            size: 18,
                            color: _kTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Mobile horizontal thumbnails
              if (isMobile && allImages.length > 1) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 64,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allImages.length,
                    itemBuilder: (_, i) {
                      final isSelected = state.selectedImageIndex == i;
                      return GestureDetector(
                        onTap: () => bloc.add(SelectProductImage(index: i)),
                        child: Container(
                          width: 58,
                          height: 58,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? _kPrimary : _kBorder,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: _NetworkImageWidget(url: allImages[i]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Icon(icon, size: 20, color: _kTextPrimary),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRODUCT INFO (right column)
// ─────────────────────────────────────────────────────────────────────────────
class _ProductInfo extends StatelessWidget {
  final ProductDetailsLoaded state;
  final int quantity;
  final String selectedColor;
  final String selectedSize;
  final List<String> colors;
  final List<String> sizes;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _ProductInfo({
    required this.state,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
    required this.colors,
    required this.sizes,
    required this.onColorChanged,
    required this.onSizeChanged,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final product = state.product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SmallTag(
              label: "Women's Fashion",
              color: _kPrimaryLight,
              textColor: _kPrimary,
            ),
            _SmallTag(
              label: "Tops & Tees",
              color: _kPrimaryLight,
              textColor: _kPrimary,
            ),
            _SmallTag(
              label: "⭐ Bestseller",
              color: const Color(0xFFFEF3C7),
              textColor: const Color(0xFF92400E),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Product name
        Text(
          product.productName,
          style: GoogleFonts.playfairDisplay(
            fontSize: isMobile ? 22 : 28,
            fontWeight: FontWeight.bold,
            color: _kTextPrimary,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),

        // Seller
        Row(
          children: [
            Icon(Icons.storefront_outlined, size: 15, color: _kTextSecondary),
            const SizedBox(width: 5),
            Text(
              'Sold by ',
              style: GoogleFonts.inter(fontSize: 13, color: _kTextSecondary),
            ),
            Text(
              product.sellerName,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: _kPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '✓ Verified Seller',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: _kGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Rating
        Row(
          children: [
            _StarRow(rating: product.rating),
            const SizedBox(width: 8),
            Text(
              '${product.rating}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _kTextPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${state.totalReviews} reviews)',
              style: GoogleFonts.inter(fontSize: 13, color: _kTextSecondary),
            ),
            const SizedBox(width: 12),
            Text(
              '2.4k+ Sold',
              style: GoogleFonts.inter(fontSize: 12, color: _kTextSecondary),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '₹${product.discountPrice.toInt()}',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 26 : 32,
                fontWeight: FontWeight.bold,
                color: _kTextPrimary,
              ),
            ),
            const SizedBox(width: 10),
            if (product.discountPercentage > 0) ...[
              Text(
                '₹${product.price.toInt()}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: _kTextSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.discountPercentage}% OFF',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),

        if (product.discountPercentage > 0) ...[
          const SizedBox(height: 4),
          Text(
            'You save ₹${(product.price - product.discountPrice).toInt()} on this order!',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: _kGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 8),

        // Promo code
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_offer_outlined,
                size: 14,
                color: Color(0xFF92400E),
              ),
              const SizedBox(width: 8),
              Text(
                'Apply code: ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF92400E),
                ),
              ),
              Text(
                'VELMORA20',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF92400E),
                ),
              ),
              Text(
                ' to save an extra 20%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Stock
        Row(
          children: [
            Icon(
              product.stockAvailable ? Icons.circle : Icons.cancel,
              size: 10,
              color: product.stockAvailable ? _kGreen : _kRed,
            ),
            const SizedBox(width: 6),
            Text(
              product.stockAvailable
                  ? '● In Stock  –  Only ${product.stock} left!'
                  : '● Out of Stock',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: product.stockAvailable ? _kGreen : _kRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Colour selector
        _SectionLabel(label: 'Colour – $selectedColor'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            _ColorSwatch(
              hexColor: '#1e293b',
              isSelected: selectedColor == 'Midnight Navy',
              onTap: () => onColorChanged('Midnight Navy'),
            ),
            _ColorSwatch(
              hexColor: '#3b82f6',
              isSelected: selectedColor == 'Cobalt Blue',
              onTap: () => onColorChanged('Cobalt Blue'),
            ),
            _ColorSwatch(
              hexColor: '#6b7280',
              isSelected: selectedColor == 'Slate Grey',
              onTap: () => onColorChanged('Slate Grey'),
            ),
            _ColorSwatch(
              hexColor: '#d1d5db',
              isSelected: selectedColor == 'Light Grey',
              onTap: () => onColorChanged('Light Grey'),
            ),
            _ColorSwatch(
              hexColor: '#7c3aed',
              isSelected: selectedColor == 'Violet',
              onTap: () => onColorChanged('Violet'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Size selector
        Row(
          children: [
            _SectionLabel(label: 'Size'),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.straighten, size: 14, color: _kPrimary),
              label: Text(
                'Size Guide',
                style: GoogleFonts.inter(fontSize: 12, color: _kPrimary),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              sizes.map((s) {
                final isSelected = selectedSize == s;
                return GestureDetector(
                  onTap: () => onSizeChanged(s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? _kPrimary : _kSurface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? _kPrimary : _kBorder,
                      ),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : _kTextPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 20),

        // Quantity
        _SectionLabel(label: 'Qty'),
        const SizedBox(height: 10),
        Row(
          children: [
            _QtyButton(
              icon: Icons.remove,
              onTap: () {
                if (quantity > 1) onQuantityChanged(quantity - 1);
              },
            ),
            Container(
              width: 48,
              alignment: Alignment.center,
              child: Text(
                '$quantity',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _QtyButton(
              icon: Icons.add,
              onTap: () => onQuantityChanged(quantity + 1),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // CTA buttons
        isMobile
            ? Column(
              children: [
                _AddToCartBtn(onTap: onAddToCart),
                const SizedBox(height: 12),
                _BuyNowBtn(onTap: onBuyNow),
              ],
            )
            : Row(
              children: [
                Expanded(child: _AddToCartBtn(onTap: onAddToCart)),
                const SizedBox(width: 12),
                Expanded(child: _BuyNowBtn(onTap: onBuyNow)),
                const SizedBox(width: 8),
                _IconCircleBtn(icon: Icons.favorite_border, onTap: () {}),
                const SizedBox(width: 8),
                _IconCircleBtn(icon: Icons.share_outlined, onTap: () {}),
              ],
            ),
        const SizedBox(height: 24),

        // Delivery & Services
        _DeliveryInfo(),
        const SizedBox(height: 16),

        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.tags.map((t) => _TagChip(label: t)).toList(),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: _kTextPrimary,
    ),
  );
}

class _SmallTag extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _SmallTag({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    ),
  );
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: _kBg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _kBorder),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(fontSize: 12, color: _kTextSecondary),
    ),
  );
}

class _ColorSwatch extends StatelessWidget {
  final String hexColor;
  final bool isSelected;
  final VoidCallback onTap;
  const _ColorSwatch({
    required this.hexColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(
      int.parse('FF${hexColor.replaceAll('#', '')}', radix: 16),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: isSelected ? _kPrimary : Colors.transparent,
            width: 2,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: _kPrimary.withOpacity(0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                  : [],
        ),
        child:
            isSelected
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: _kTextPrimary),
    ),
  );
}

class _AddToCartBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _AddToCartBtn({required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
      label: Text(
        'Add to Cart',
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}

class _BuyNowBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _BuyNowBtn({required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.flash_on, size: 18),
      label: Text(
        'Buy Now',
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _kTextPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}

class _IconCircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconCircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: _kTextSecondary),
    ),
  );
}

class _DeliveryInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery & Services',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _DeliveryRow(
            icon: Icons.local_shipping_outlined,
            color: _kGreen,
            title: 'Free Delivery',
            sub: 'Estimated delivery: Jan 31 - 21',
          ),
          const SizedBox(height: 8),
          _DeliveryRow(
            icon: Icons.replay_outlined,
            color: _kPrimary,
            title: '30-Day Returns',
            sub: 'Easy hassle-free returns & exchanges',
          ),
          const SizedBox(height: 8),
          _DeliveryRow(
            icon: Icons.verified_outlined,
            color: const Color(0xFF0EA5E9),
            title: 'Authenticity Guaranteed',
            sub: '100% genuine product, verified by Velmora',
          ),
        ],
      ),
    );
  }
}

class _DeliveryRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String sub;
  const _DeliveryRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$title  ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _kTextPrimary,
                ),
              ),
              TextSpan(
                text: sub,
                style: GoogleFonts.inter(fontSize: 12, color: _kTextSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB BAR
// ─────────────────────────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final int selected;
  final int totalReviews;
  final ValueChanged<int> onTap;

  const _TabBar({
    required this.selected,
    required this.totalReviews,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Description',
      'Specifications',
      'Reviews ($totalReviews)',
      'Related Products',
    ];
    return Container(
      decoration: const BoxDecoration(
        color: _kSurface,
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (i) {
            final isSelected = selected == i;
            return GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? _kPrimary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[i],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? _kPrimary : _kTextSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DESCRIPTION TAB
// ─────────────────────────────────────────────────────────────────────────────
class _DescriptionTab extends StatelessWidget {
  final ProductDetailsData product;
  const _DescriptionTab({required this.product});

  @override
  Widget build(BuildContext context) {
    const highlights = [
      'Premium 100% Marino Wool – naturally temperature-regulating and moisture-wicking',
      'Fine ribbed texture adds elegant visual depth and a tailored silhouette',
      'High turtleneck collar keeps you warm without extra layering',
      'Slim fit design flatters all body types, true to size',
      'Available in 5 versatile colourways for any wardrobe palette',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.detailedDescription.isNotEmpty
              ? product.detailedDescription
              : 'Crafted from 100% premium Marino wool, this ribbed turtleneck is the ultimate cold-weather wardrobe essential. Featuring a classic slim fit, full-length sleeves, and a high ribbed collar, it pairs effortlessly with everything from tailored trousers to denim.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.7,
            color: _kTextSecondary,
          ),
        ),
        const SizedBox(height: 20),
        ...highlights.map(
          (h) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, size: 16, color: _kGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    h,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: _kTextSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SPECIFICATIONS TAB
// ─────────────────────────────────────────────────────────────────────────────
class _SpecificationsTab extends StatelessWidget {
  final ProductDetailsData product;
  const _SpecificationsTab({required this.product});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> staticSpecs = {
      'Fabric': '100% Merino Wool',
      'Fit': 'Slim Fit',
      'Neck Style': 'Ribbed Turtleneck',
      'Sleeve Length': 'Full Sleeve',
      'Occasion': 'Casual, Formal, Office',
      'Pattern': 'Solid',
      'Care': 'Machine Wash Cold',
      'Country of Origin': 'India',
    };

    final specs =
        product.specifications.isNotEmpty
            ? product.specifications.map((k, v) => MapEntry(k, v.toString()))
            : staticSpecs;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children:
            specs.entries.toList().asMap().entries.map((entry) {
              final i = entry.key;
              final spec = entry.value;
              return Container(
                decoration: BoxDecoration(
                  color: i.isOdd ? const Color(0xFFF9FAFB) : _kSurface,
                  border: Border(
                    top: BorderSide(
                      color: i == 0 ? Colors.transparent : _kBorder,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 160,
                      child: Text(
                        spec.key,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _kTextSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        spec.value,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: _kTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REVIEWS TAB (inside tabs)
// ─────────────────────────────────────────────────────────────────────────────
class _ReviewsTab extends StatelessWidget {
  final ProductDetailsLoaded state;
  final bool isMobile;
  const _ReviewsTab({required this.state, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    if (state.reviews.isEmpty) {
      return const Center(child: Text('No reviews yet'));
    }
    return Column(
      children: state.reviews.map((r) => _ReviewCard(review: r)).toList(),
    );
  }
}

class _RelatedProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Related products coming soon…',
        style: GoogleFonts.inter(color: _kTextSecondary),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SELLER CARD
// ─────────────────────────────────────────────────────────────────────────────
class _SellerCard extends StatelessWidget {
  final String sellerName;
  const _SellerCard({required this.sellerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _kPrimaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.storefront_outlined, color: _kPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerName.isNotEmpty
                      ? sellerName
                      : 'Marks & Spencer Official Store',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _kTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 13, color: _kGold),
                    const SizedBox(width: 3),
                    Text(
                      '4.8 Seller Rating',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _kTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '1240 Products',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _kTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Ships within 24 hours',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _kTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _kPrimary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              'View Store',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: _kPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REVIEWS SECTION (full page section below tabs)
// ─────────────────────────────────────────────────────────────────────────────
class _ReviewsSection extends StatelessWidget {
  final ProductDetailsLoaded state;
  final bool isMobile;
  const _ReviewsSection({required this.state, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final hPad = isMobile ? 16.0 : (w < 1200 ? 32.0 : 80.0);

    return Container(
      color: _kSurface,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Reviews',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _kTextPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Rating summary
          isMobile
              ? _RatingSummaryMobile(state: state)
              : _RatingSummaryDesktop(state: state),

          const SizedBox(height: 32),

          // Individual reviews
          ...state.reviews.map((r) => _ReviewCard(review: r)),

          const SizedBox(height: 16),
          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _kBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: Text(
                'Load More Reviews',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: _kTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingSummaryDesktop extends StatelessWidget {
  final ProductDetailsLoaded state;
  const _RatingSummaryDesktop({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Big rating
        SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.averageRating.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: _kTextPrimary,
                ),
              ),
              _StarRow(rating: state.averageRating, size: 22),
              const SizedBox(height: 4),
              Text(
                '${state.averageRating} (${state.totalReviews} reviews)',
                style: GoogleFonts.inter(fontSize: 12, color: _kTextSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                'Based on ${state.totalReviews} reviews',
                style: GoogleFonts.inter(fontSize: 12, color: _kTextSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 48),
        // Bars
        Expanded(
          child: _RatingBars(
            distribution: state.ratingDistribution,
            total: state.totalReviews,
          ),
        ),
      ],
    );
  }
}

class _RatingSummaryMobile extends StatelessWidget {
  final ProductDetailsLoaded state;
  const _RatingSummaryMobile({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              state.averageRating.toStringAsFixed(1),
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: _kTextPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StarRow(rating: state.averageRating, size: 18),
                const SizedBox(height: 4),
                Text(
                  '${state.totalReviews} reviews',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _kTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _RatingBars(
          distribution: state.ratingDistribution,
          total: state.totalReviews,
        ),
      ],
    );
  }
}

class _RatingBars extends StatelessWidget {
  final Map<String, int> distribution;
  final int total;
  const _RatingBars({required this.distribution, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          [5, 4, 3, 2, 1].map((star) {
            final count = distribution['$star'] ?? 0;
            final pct = total > 0 ? count / total : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    child: Text(
                      '$star',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _kTextSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.star_rounded, size: 12, color: _kGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: const AlwaysStoppedAnimation<Color>(_kGold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '$count',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _kTextSecondary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewData review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: _kPrimaryLight,
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: _kPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: _kTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (review.isVerifiedPurchase)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '✓ Verified',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: _kGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _StarRow(rating: review.rating.toDouble(), size: 14),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StarRowRight(rating: review.rating.toDouble()),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(review.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: _kTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (review.comment.isNotEmpty) ...[
            Text(
              _getReviewTitle(review.comment),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _kTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              review.comment,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: _kTextSecondary,
              ),
            ),
          ],
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder:
                    (_, imgIdx) => Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _kBorder),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _NetworkImageWidget(url: review.images[imgIdx]),
                      ),
                    ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _ReviewAction(
                icon: Icons.thumb_up_outlined,
                label: 'Helpful (0)',
              ),
              const SizedBox(width: 16),
              _ReviewAction(icon: Icons.flag_outlined, label: 'Report'),
            ],
          ),
        ],
      ),
    );
  }

  String _getReviewTitle(String comment) {
    final words = comment.split(' ');
    return words.take(4).join(' ') + (words.length > 4 ? '!' : '');
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateString;
    }
  }
}

class _ReviewAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ReviewAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 14, color: _kTextSecondary),
      const SizedBox(width: 4),
      Text(
        label,
        style: GoogleFonts.inter(fontSize: 12, color: _kTextSecondary),
      ),
    ],
  );
}

class _StarRowRight extends StatelessWidget {
  final double rating;
  const _StarRowRight({required this.rating});

  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      5,
      (i) => Icon(
        i < rating.floor()
            ? Icons.star_rounded
            : i < rating
            ? Icons.star_half_rounded
            : Icons.star_border_rounded,
        size: 14,
        color: _kGold,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// RELATED PRODUCTS
// ─────────────────────────────────────────────────────────────────────────────
class _RelatedProducts extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  const _RelatedProducts({required this.isMobile, required this.isTablet});

  static const _products = [
    {
      'name': 'Cable Knit Pullover',
      'price': 2199,
      'original': 2999,
      'discount': 36,
      'brand': 'Marks & Spencer',
      'rating': 4.2,
      'reviews': 28,
      'badge': '36% OFF',
    },
    {
      'name': 'Mock Neck Long Tee',
      'price': 599,
      'original': 999,
      'discount': 45,
      'brand': 'H&M',
      'rating': 4.1,
      'reviews': 193,
      'badge': '45% OFF',
    },
    {
      'name': 'Thermal Turtleneck',
      'price': 1499,
      'original': 2099,
      'discount': 20,
      'brand': 'Zudio',
      'rating': 4.0,
      'reviews': 241,
      'badge': '20% OFF',
    },
    {
      'name': 'Cowl Neck Sweater',
      'price': 2499,
      'original': 3999,
      'discount': 0,
      'brand': 'Fabindia',
      'rating': 4.3,
      'reviews': 196,
      'badge': 'Premium',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // final w = MediaQuery.of(context).size.width;
    final hPad = isMobile ? 16.0 : (isTablet ? 32.0 : 80.0);
    final crossCount = isMobile ? 2 : (isTablet ? 3 : 4);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You May Also Like',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _kTextSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Related Products',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _kTextPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'View All →',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: _kPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              childAspectRatio: isMobile ? 0.6 : 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _products.length,
            itemBuilder: (_, i) => _RelatedProductCard(data: _products[i]),
          ),
        ],
      ),
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RelatedProductCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F0),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.checkroom_outlined,
                    size: 64,
                    color: Color(0xFFD1D5DB),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: data['badge'] == 'Premium' ? _kPrimary : _kRed,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    data['badge'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 14,
                      color: _kTextSecondary,
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
                Text(
                  data['brand'],
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: _kTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data['name'],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 12, color: _kGold),
                    const SizedBox(width: 3),
                    Text(
                      '${data['rating']}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: _kTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${data['reviews']})',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: _kTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '₹${data['price']}',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _kPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (data['discount'] > 0)
                      Text(
                        '₹${data['original']}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          color: _kTextSecondary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Add to Cart',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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

// ─────────────────────────────────────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: const Color(0xFF111827),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 48,
      ),
      child: isMobile ? _FooterMobile() : _FooterDesktop(),
    );
  }
}

class _FooterDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _kPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'V',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Velmora',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your destination for premium fashion, beauty, and lifestyle. Discover the best brands, curated just for you.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white60,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children:
                        [
                              Icons.facebook,
                              Icons.flutter_dash,
                              Icons.link,
                              Icons.photo_camera,
                            ]
                            .map(
                              (icon) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Icon(
                                  icon,
                                  size: 20,
                                  color: Colors.white54,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: _FooterCol(
                title: 'Company',
                items: ['About Us', 'Careers', 'Press', 'Blog', 'Investors'],
              ),
            ),
            Expanded(
              child: _FooterCol(
                title: 'Help',
                items: [
                  'Customer Support',
                  'Track Order',
                  'Returns & Exchanges',
                  'FAQs',
                  'Size Guide',
                ],
              ),
            ),
            Expanded(
              child: _FooterCol(
                title: 'Legal',
                items: [
                  'Privacy Policy',
                  'Terms of Service',
                  'Cookie Policy',
                  'Accessibility',
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Container(height: 1, color: Colors.white12),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2025 Velmora. All rights reserved.',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white38),
            ),
            Row(
              children: [
                Icon(Icons.payment, size: 24, color: Colors.white38),
                const SizedBox(width: 8),
                Icon(Icons.credit_card, size: 24, color: Colors.white38),
                const SizedBox(width: 8),
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 24,
                  color: Colors.white38,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _kPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'V',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Velmora',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Your destination for premium fashion & lifestyle.',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white60),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FooterCol(
              title: 'Company',
              items: ['About Us', 'Careers', 'Press', 'Blog'],
            ),
            _FooterCol(
              title: 'Help',
              items: ['Support', 'Track Order', 'Returns', 'FAQs'],
            ),
            _FooterCol(title: 'Legal', items: ['Privacy', 'Terms', 'Cookies']),
          ],
        ),
        const SizedBox(height: 24),
        Container(height: 1, color: Colors.white12),
        const SizedBox(height: 16),
        Text(
          '© 2025 Velmora. All rights reserved.',
          style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
        ),
      ],
    );
  }
}

class _FooterCol extends StatelessWidget {
  final String title;
  final List<String> items;
  const _FooterCol({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white54),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRow({required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (i) => Icon(
        i < rating.floor()
            ? Icons.star_rounded
            : i < rating
            ? Icons.star_half_rounded
            : Icons.star_border_rounded,
        size: size,
        color: _kGold,
      ),
    ),
  );
}

class _NetworkImageWidget extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const _NetworkImageWidget({
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        color: const Color(0xFFF5F5F0),
        child: const Icon(
          Icons.image_outlined,
          size: 48,
          color: Color(0xFFD1D5DB),
        ),
      );
    }
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value:
                progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
            strokeWidth: 2,
            color: _kPrimary,
          ),
        );
      },
      errorBuilder:
          (_, __, ___) => Container(
            color: const Color(0xFFF5F5F0),
            child: const Icon(
              Icons.image_not_supported_outlined,
              size: 40,
              color: Color(0xFFD1D5DB),
            ),
          ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: _kRed),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.inter(fontSize: 15, color: _kTextSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: _kPrimary),
              child: Text(
                'Retry',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/analytics/bloc/analytics_bloc.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_event.dart';
import 'package:app_frontend/features/analytics/bloc/analytics_state.dart';
import 'package:app_frontend/features/analytics/model/analytics_models.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/product_preview_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String Function(ProductModel) getProductStatus;
  final Color Function(String) getStatusColor;
  final String Function(double) formatPrice;
  final String Function(String) formatDate;
  final String userName;
  final String userEmail;
  final String? userProfileImage;

  const ProductDetailsView({
    super.key,
    required this.product,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
    required this.getProductStatus,
    required this.getStatusColor,
    required this.formatPrice,
    required this.formatDate,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
  });

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  ProductPerformance? _productAnalytics;

  @override
  void initState() {
    super.initState();
    _loadProductAnalytics();
  }

  void _loadProductAnalytics() {
    context.read<AnalyticsBloc>().add(FetchProductAnalytics(sortBy: 'revenue'));
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.getProductStatus(widget.product);
    final statusColor = widget.getStatusColor(status);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 800;
    final isTablet = screenSize.width >= 800 && screenSize.width < 1200;

    // Responsive padding and spacing
    final mainPadding = isSmallScreen ? 16.0 : 24.0;
    final contentSpacing = isSmallScreen ? 16.0 : 24.0;
    final fontSizeHeading = isSmallScreen ? 16.0 : 18.0;
    final fontSizeSubheading = isSmallScreen ? 13.0 : 14.0;
    final fontSizeBody = isSmallScreen ? 12.0 : 13.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, isSmallScreen),
            Padding(
              padding: EdgeInsets.all(mainPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductTitleSection(status, statusColor, isSmallScreen),
                  SizedBox(height: contentSpacing),
                  isSmallScreen
                      ? Column(
                        children: [
                          ProductImagePreview(product: widget.product),
                          SizedBox(height: contentSpacing),
                          _buildProductInfoSection(isSmallScreen, fontSizeBody),
                          SizedBox(height: contentSpacing),
                          _buildPricingAndInventorySection(
                            isSmallScreen,
                            fontSizeHeading,
                            fontSizeSubheading,
                            fontSizeBody,
                          ),
                          SizedBox(height: contentSpacing),
                          _buildReviewsSection(isSmallScreen, fontSizeBody),
                        ],
                      )
                      : Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: isTablet ? 5 : 4,
                                child: Column(
                                  children: [
                                    ProductImagePreview(
                                      product: widget.product,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildProductInfoSection(
                                      isSmallScreen,
                                      fontSizeBody,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: isTablet ? 16 : 24),
                              Expanded(
                                flex: isTablet ? 5 : 4,
                                child: Column(
                                  children: [
                                    _buildPricingCard(
                                      isSmallScreen,
                                      fontSizeHeading,
                                      fontSizeSubheading,
                                      fontSizeBody,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildInventoryCard(
                                      isSmallScreen,
                                      fontSizeHeading,
                                      fontSizeSubheading,
                                      fontSizeBody,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildProductCategoryCard(
                                      isSmallScreen,
                                      fontSizeHeading,
                                      fontSizeSubheading,
                                      fontSizeBody,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildAnalyticsCard(
                                      isSmallScreen,
                                      fontSizeHeading,
                                      fontSizeSubheading,
                                      fontSizeBody,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildOrganizationCard(
                                      isSmallScreen,
                                      fontSizeHeading,
                                      fontSizeSubheading,
                                      fontSizeBody,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildReviewsSection(
                                      isSmallScreen,
                                      fontSizeBody,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSpecificationsContainer(
                            isSmallScreen,
                            fontSizeHeading,
                            fontSizeBody,
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

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 24,
        vertical: isSmallScreen ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: Icon(Icons.arrow_back, size: isSmallScreen ? 20 : 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          Text(
            'Product Details',
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitleSection(
    String status,
    Color statusColor,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          isSmallScreen
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.productName,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${widget.product.category} > ${widget.product.subCategory}",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 13,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.product.isActive ? "Active" : "Inactive",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 11 : 12,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200, height: 1),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildActionButton(
                        icon: Icons.share,
                        label: "Share",
                        isSmallScreen: isSmallScreen,
                        onPressed: () {},
                      ),
                      _buildActionButton(
                        icon: Icons.delete,
                        label: "Delete",
                        isSmallScreen: isSmallScreen,
                        onPressed: widget.onDelete,
                        isDestructive: true,
                      ),
                      _buildActionButton(
                        icon: Icons.edit,
                        label: "Edit Product",
                        isSmallScreen: isSmallScreen,
                        onPressed: widget.onEdit,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.productName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "${widget.product.category} > ${widget.product.subCategory}",
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.product.isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        icon: Icons.share,
                        label: "Share",
                        isSmallScreen: isSmallScreen,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        icon: Icons.delete,
                        label: "Delete",
                        isSmallScreen: isSmallScreen,
                        onPressed: widget.onDelete,
                        isDestructive: true,
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        icon: Icons.edit,
                        label: "Edit Product",
                        isSmallScreen: isSmallScreen,
                        onPressed: widget.onEdit,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ],
              ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isSmallScreen,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: isSmallScreen ? 16 : 18),
        label: Text(label, style: TextStyle(fontSize: isSmallScreen ? 13 : 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 10 : 12,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: isSmallScreen ? 16 : 18),
      label: Text(label, style: TextStyle(fontSize: isSmallScreen ? 13 : 14)),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDestructive ? Colors.red : Colors.black87,
        side: BorderSide(
          color:
              isDestructive
                  ? Colors.red.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.3),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 10 : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPricingAndInventorySection(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
    double bodySize,
  ) {
    return Column(
      children: [
        _buildPricingCard(isSmallScreen, headingSize, subheadingSize, bodySize),
        const SizedBox(height: 16),
        _buildInventoryCard(
          isSmallScreen,
          headingSize,
          subheadingSize,
          bodySize,
        ),
        const SizedBox(height: 16),
        _buildProductCategoryCard(
          isSmallScreen,
          headingSize,
          subheadingSize,
          bodySize,
        ),
        const SizedBox(height: 16),
        _buildAnalyticsCard(
          isSmallScreen,
          headingSize,
          subheadingSize,
          bodySize,
        ),
        const SizedBox(height: 16),
        _buildOrganizationCard(
          isSmallScreen,
          headingSize,
          subheadingSize,
          bodySize,
        ),
        SizedBox(height: 16),
        _buildReviewsSection(isSmallScreen, bodySize),
      ],
    );
  }

  Widget _buildPricingCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
    double bodySize,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pricing Information",
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          _buildInfoRow(
            "Selling Price",
            widget.formatPrice(widget.product.discountPrice),
            bodySize,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            "Original Price",
            widget.formatPrice(widget.product.price),
            bodySize,
            isStrikethrough: true,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            "Discount",
            _calculateDiscount(),
            bodySize,
            valueColor: const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            "Estimated Margin",
            widget.formatPrice(widget.product.discountPrice * 0.2),
            bodySize,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
    double bodySize,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Inventory Details",
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          _buildInfoRow(
            "Available Stock",
            "${widget.product.stock} Units",
            bodySize,
            valueColor: widget.product.stock < 10 ? Colors.red : Colors.green,
          ),
          const SizedBox(height: 12),
          _buildInfoRow("SKU", "KPE560133SD", bodySize),
          const SizedBox(height: 12),
          _buildInfoRow("Barcode", "256102856495300256", bodySize),
        ],
      ),
    );
  }

  Widget _buildProductCategoryCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
    double bodySize,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category Information",
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          _buildInfoRow("Category", widget.product.category, bodySize),
          const SizedBox(height: 12),
          _buildInfoRow("Sub Category", widget.product.subCategory, bodySize),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
    double bodySize,
  ) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        String totalSales = "0";
        String totalRevenue = "₹0";
        String totalViews = "0";
        String rating = "0";
        String stockStatus = "In Stock";

        if (state is ProductAnalyticsLoaded) {
          final productAnalytics = state.productAnalytics.allProducts
              .firstWhere(
                (product) => product.productId == widget.product.id,
                orElse:
                    () => ProductPerformance(
                      productId: widget.product.id,
                      productName: widget.product.productName,
                      productImage: widget.product.mainBannerImage,
                      totalSold: 0,
                      totalRevenue: 0,
                      totalOrders: 0,
                      rating: widget.product.rating,
                      reviews: widget.product.totalReviews,
                      stockAvailable: widget.product.stock,
                      isLowStock: widget.product.stock < 10,
                      conversionRate: 0,
                      totalViews: 0,
                    ),
              );

          totalSales = productAnalytics.totalSold.toString();
          totalRevenue = "₹${productAnalytics.totalRevenue.toStringAsFixed(0)}";
          totalViews = productAnalytics.totalViews.toString();
          rating = productAnalytics.rating.toStringAsFixed(1);
          stockStatus =
              productAnalytics.isLowStock
                  ? "Low Stock"
                  : (productAnalytics.stockAvailable > 50
                      ? "In Stock"
                      : "Limited Stock");
        } else if (state is AnalyticsLoading) {
          return Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Performance Analytics",
                  style: TextStyle(
                    fontSize: headingSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 24),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Performance Analytics",
                    style: TextStyle(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          widget.product.stock < 10
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      stockStatus,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color:
                            widget.product.stock < 10
                                ? Colors.red
                                : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 16),
              _buildAnalyticsRow(
                HugeIcons.strokeRoundedShoppingBag01,
                Colors.deepPurple,
                "Total Sales",
                totalSales,
                isSmallScreen,
              ),
              const SizedBox(height: 12),
              _buildAnalyticsRow(
                HugeIcons.strokeRoundedDollar01,
                Colors.lightGreen,
                "Total Revenue",
                totalRevenue,
                isSmallScreen,
              ),
              const SizedBox(height: 12),
              // _buildAnalyticsRow(
              //   HugeIcons.strokeRoundedEye,
              //   Colors.amber,
              //   "Total Views",
              //   totalViews,
              //   isSmallScreen,
              // ),
              // const SizedBox(height: 12),
              _buildAnalyticsRow(
                HugeIcons.strokeRoundedStar,
                const Color(0xFFF59E0B),
                "Rating",
                "$rating ⭐",
                isSmallScreen,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrganizationCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
    double bodySize,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Organization Details",
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          Text(
            "Seller Information",
            style: TextStyle(
              fontSize: subheadingSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child:
                    widget.userProfileImage != null &&
                            widget.userProfileImage!.isNotEmpty
                        ? Image.network(
                          widget.userProfileImage!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 22,
                                color: Colors.grey.shade600,
                              ),
                            );
                          },
                        )
                        : Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 22,
                            color: Colors.grey.shade600,
                          ),
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontSize: bodySize + 1,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      widget.userEmail,
                      style: TextStyle(
                        fontSize: bodySize - 1,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          Text(
            'Product Tags',
            style: TextStyle(
              fontSize: subheadingSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                widget.product.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: bodySize - 1,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoSection(bool isSmallScreen, double bodySize) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Description',
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          Text(
            'Short Description',
            style: TextStyle(
              fontSize: bodySize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.shortDescription.isEmpty
                ? 'No description provided'
                : widget.product.shortDescription,
            style: TextStyle(
              fontSize: bodySize,
              color: const Color(0xFF475569),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          Text(
            'Detailed Description',
            style: TextStyle(
              fontSize: bodySize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.detailedDescription.isEmpty
                ? 'No description provided'
                : widget.product.detailedDescription,
            style: TextStyle(
              fontSize: bodySize,
              color: const Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsContainer(
    bool isSmallScreen,
    double headingSize,
    double bodySize,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Specifications',
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          if (widget.product.specifications.isNotEmpty)
            _buildSpecificationsTable(isSmallScreen, bodySize)
          else
            Container(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.settings, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      'No specifications available',
                      style: TextStyle(
                        fontSize: bodySize,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsTable(bool isSmallScreen, double bodySize) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children:
            widget.product.specifications.entries.map((entry) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 12 : 14,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: isSmallScreen ? 110 : 130,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: bodySize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: TextStyle(
                          fontSize: bodySize,
                          color: const Color(0xFF1E293B),
                          height: 1.4,
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

  Widget _buildReviewsSection(bool isSmallScreen, double bodySize) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Reviews',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                  letterSpacing: -0.3,
                ),
              ),
              if (!isSmallScreen)
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: bodySize,
                      color: const Color(0xFF7C3AED),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),
          if (isSmallScreen)
            Column(
              children: [
                _buildRatingSummary(isSmallScreen, bodySize),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFFD1D5DB),
                      width: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: Text(
                    'View All Reviews',
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: bodySize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: _buildRatingSummary(isSmallScreen, bodySize),
                ),
                VerticalDivider(color: Colors.grey.shade200),
                Flexible(
                  flex: 3,
                  child: _buildRatingBars(isSmallScreen, bodySize),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFD1D5DB),
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                    ),
                    child: Text(
                      'View All Reviews',
                      style: TextStyle(
                        color: const Color(0xFF1F2937),
                        fontSize: bodySize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary(bool isSmallScreen, double bodySize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.product.rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: isSmallScreen ? 32 : 40,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              index < widget.product.rating.floor()
                  ? Icons.star
                  : Icons.star_border,
              size: isSmallScreen ? 16 : 18,
              color: const Color(0xFFF59E0B),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Based on ${widget.product.totalReviews} reviews',
          style: TextStyle(fontSize: bodySize - 1, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildRatingBars(bool isSmallScreen, double bodySize) {
    return Column(
      children: [
        _buildRatingBarRow(5, 80, "225", isSmallScreen, bodySize),
        const SizedBox(height: 6),
        _buildRatingBarRow(4, 65, "165", isSmallScreen, bodySize),
        const SizedBox(height: 6),
        _buildRatingBarRow(3, 45, "42", isSmallScreen, bodySize),
        const SizedBox(height: 6),
        _buildRatingBarRow(2, 20, "18", isSmallScreen, bodySize),
        const SizedBox(height: 6),
        _buildRatingBarRow(1, 10, "8", isSmallScreen, bodySize),
      ],
    );
  }

  Widget _buildRatingBarRow(
    int rating,
    int percentage,
    String count,
    bool isSmallScreen,
    double bodySize,
  ) {
    return Row(
      children: [
        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: bodySize,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.star,
          size: isSmallScreen ? 12 : 14,
          color: const Color(0xFFF59E0B),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFFF59E0B),
            minHeight: isSmallScreen ? 4 : 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: bodySize - 1,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    double bodySize, {
    bool isStrikethrough = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bodySize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bodySize + 1,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1E293B),
            decoration: isStrikethrough ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsRow(
    List<List<dynamic>> icon,
    Color color,
    String label,
    String value,
    bool isSmallScreen,
  ) {
    return Row(
      children: [
        Container(
          width: isSmallScreen ? 36 : 40,
          height: isSmallScreen ? 36 : 40,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
            color: color.withOpacity(0.12),
          ),
          child: Center(
            child: HugeIcon(
              icon: icon,
              color: color,
              size: isSmallScreen ? 18 : 20,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _calculateDiscount() {
    if (widget.product.price > widget.product.discountPrice) {
      final discount =
          ((widget.product.price - widget.product.discountPrice) /
              widget.product.price *
              100);
      return '${discount.toStringAsFixed(0)}% OFF';
    }
    return 'No Discount';
  }
}

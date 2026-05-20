// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/product_preview_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProductDetailsView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final status = getProductStatus(product);
    final statusColor = getStatusColor(status);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 800;
    final isTablet = screenSize.width >= 800 && screenSize.width < 1200;
    // final isLargeScreen = screenSize.width >= 1200;

    // Responsive padding and spacing
    final mainPadding = isSmallScreen ? 16.0 : 24.0;
    final contentSpacing = isSmallScreen ? 16.0 : 24.0;
    // final containerPadding = isSmallScreen ? 16.0 : 24.0;
    final fontSizeHeading = isSmallScreen ? 18.0 : 22.0;
    final fontSizeSubheading = isSmallScreen ? 14.0 : 16.0;
    // final fontSizeBody = isSmallScreen ? 12.0 : 14.0;

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
                  // Responsive layout - changes from row to column on small screens
                  isSmallScreen
                      ? Column(
                        children: [
                          ProductImagePreview(product: product),
                          SizedBox(height: contentSpacing),
                          _buildProductInfoSection(isSmallScreen),
                          SizedBox(height: contentSpacing),
                          _buildPricingAndInventorySection(
                            isSmallScreen,
                            fontSizeHeading,
                            fontSizeSubheading,
                          ),
                          SizedBox(height: contentSpacing),
                          _buildReviewsSection(isSmallScreen),
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
                                    ProductImagePreview(product: product),
                                    SizedBox(height: contentSpacing),
                                    _buildProductInfoSection(isSmallScreen),
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
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildInventoryCard(
                                      isSmallScreen,
                                      fontSizeHeading,
                                      fontSizeSubheading,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildAnalyticsCard(
                                      isSmallScreen,
                                      fontSizeHeading,
                                      fontSizeSubheading,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildOrganizationCard(
                                      isSmallScreen,
                                      fontSizeHeading,
                                      fontSizeSubheading,
                                    ),
                                    SizedBox(height: contentSpacing),
                                    _buildReviewsSection(isSmallScreen),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Container(
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
                                  'Specifications',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (product.specifications.isNotEmpty)
                                  _buildSpecificationsTable(isSmallScreen)
                                else
                                  Text(
                                    'No specifications available',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                              ],
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
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, size: isSmallScreen ? 20 : 24),
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
          // Responsive Row - stacks on small screens
          isSmallScreen
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${product.category} > ${product.subCategory}",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: const Color(0xFF64748B),
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
                              product.isActive ? "Active" : "Inactive",
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.share, size: isSmallScreen ? 14 : 16),
                        label: Text(
                          "Share",
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete, size: isSmallScreen ? 14 : 16),
                        label: Text(
                          "Delete",
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red.withOpacity(0.4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: onEdit,
                        icon: Icon(Icons.edit, size: isSmallScreen ? 14 : 16),
                        label: Text(
                          "Edit Product",
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
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
                          product.productName,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "${product.category} > ${product.subCategory}",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: const Color(0xFF64748B),
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
                                product.isActive ? "Active" : "Inactive",
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
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.share, size: isSmallScreen ? 14 : 16),
                        label: Text(
                          "Share",
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete, size: isSmallScreen ? 14 : 16),
                        label: Text(
                          "Delete",
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red.withOpacity(0.4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: onEdit,
                        icon: Icon(Icons.edit, size: isSmallScreen ? 14 : 16),
                        label: Text(
                          "Edit Product",
                          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildPricingAndInventorySection(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
  ) {
    return Column(
      children: [
        _buildPricingCard(isSmallScreen, headingSize, subheadingSize),
        const SizedBox(height: 16),
        _buildInventoryCard(isSmallScreen, headingSize, subheadingSize),
        const SizedBox(height: 16),
        _buildAnalyticsCard(isSmallScreen, headingSize, subheadingSize),
        const SizedBox(height: 16),
        _buildOrganizationCard(isSmallScreen, headingSize, subheadingSize),
        SizedBox(height: 16),
        _buildReviewsSection(isSmallScreen),
      ],
    );
  }

  Widget _buildPricingCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
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
            "Pricing",
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            "Selling Price",
            formatPrice(product.discountPrice),
            isSmallScreen,
          ),

          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Original Price",
                  style: TextStyle(
                    fontSize: subheadingSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  formatPrice(product.price),
                  style: TextStyle(
                    fontSize: subheadingSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discount Price",
                  style: TextStyle(
                    fontSize: subheadingSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      formatPrice(product.price - product.discountPrice),
                      style: TextStyle(
                        fontSize: subheadingSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _calculateDiscount(),
                      style: TextStyle(
                        fontSize: subheadingSize,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cost / Margin",
                  style: TextStyle(
                    fontSize: subheadingSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  formatPrice(product.discountPrice * 0.2),
                  style: TextStyle(
                    fontSize: subheadingSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
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
            "Inventory",
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            "Available Stock",
            "${product.stock} Units",
            isSmallScreen,
          ),
          const SizedBox(height: 12),
          _buildInfoRow("SKU", "KHRkalkfdsf452sa", isSmallScreen),
          const SizedBox(height: 12),
          _buildInfoRow("Barcode", "03289465320531", isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
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
            "Product Analytics",
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnalyticsRow(
            HugeIcons.strokeRoundedShoppingBag01,
            Colors.deepPurple,
            "Total Sales",
            "254",
            isSmallScreen,
          ),
          const SizedBox(height: 12),
          _buildAnalyticsRow(
            HugeIcons.strokeRoundedDollar01,
            Colors.lightGreen,
            "Total Revenue",
            "₹845,652.00",
            isSmallScreen,
          ),
          const SizedBox(height: 12),
          _buildAnalyticsRow(
            HugeIcons.strokeRoundedEye,
            Colors.amber,
            "Views (30d)",
            "12,405",
            isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationCard(
    bool isSmallScreen,
    double headingSize,
    double subheadingSize,
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
            "Organization",
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Seller",
            style: TextStyle(
              fontSize: subheadingSize,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child:
                    userProfileImage != null && userProfileImage!.isNotEmpty
                        ? Image.network(
                          userProfileImage!,
                          height: 35,
                          width: 35,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person, size: 20),
                            );
                          },
                        )
                        : Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, size: 20),
                        ),
              ),
              const SizedBox(width: 12),
              Text(
                userName,
                style: TextStyle(
                  fontSize: subheadingSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Tags',
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                product.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10 : 11,
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

  Widget _buildProductInfoSection(bool isSmallScreen) {
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
            'Product Information',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Short Description',
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.shortDescription.isEmpty
                ? 'No description provided'
                : product.shortDescription,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: const Color(0xFF475569),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Detailed Description',
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.detailedDescription.isEmpty
                ? 'No description provided'
                : product.detailedDescription,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: const Color(0xFF475569),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSpecificationsTable(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children:
            product.specifications.entries.map((entry) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 10 : 12,
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
                      width: isSmallScreen ? 100 : 120,
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: const Color(0xFF1E293B),
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

  Widget _buildReviewsSection(bool isSmallScreen) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (!isSmallScreen)
                TextButton(
                  onPressed: () {},
                  child: const Text('View All Reviews'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (isSmallScreen)
            Column(
              children: [
                _buildRatingSummary(isSmallScreen),
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
                      vertical: 12.0,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'View All Reviews',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Flexible(flex: 2, child: _buildRatingSummary(isSmallScreen)),
                const VerticalDivider(),
                Flexible(flex: 3, child: _buildRatingBars(isSmallScreen)),
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
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View All Reviews',
                      style: TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 14.0,
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

  Widget _buildRatingSummary(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          product.rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: isSmallScreen ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              index < product.rating.floor() ? Icons.star : Icons.star_border,
              size: isSmallScreen ? 16 : 18,
              color: const Color(0xFFF59E0B),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Based on ${product.totalReviews} reviews',
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBars(bool isSmallScreen) {
    return Column(
      children: [
        _buildRatingBarRow(5, 80, "225", isSmallScreen),
        const SizedBox(height: 8),
        _buildRatingBarRow(4, 65, "165", isSmallScreen),
        const SizedBox(height: 8),
        _buildRatingBarRow(3, 45, "42", isSmallScreen),
        const SizedBox(height: 8),
        _buildRatingBarRow(2, 20, "18", isSmallScreen),
        const SizedBox(height: 8),
        _buildRatingBarRow(1, 10, "8", isSmallScreen),
      ],
    );
  }

  Widget _buildRatingBarRow(
    int rating,
    int percentage,
    String count,
    bool isSmallScreen,
  ) {
    return Row(
      children: [
        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(width: 4),
        HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: Colors.amber,
          size: isSmallScreen ? 14 : 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            color: Colors.amber,
            minHeight: isSmallScreen ? 4 : 6,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
          width: isSmallScreen ? 32 : 40,
          height: isSmallScreen ? 32 : 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
          ),
          child: Center(
            child: HugeIcon(
              icon: icon,
              color: color,
              size: isSmallScreen ? 18 : 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _calculateDiscount() {
    if (product.price > product.discountPrice) {
      final discount =
          ((product.price - product.discountPrice) / product.price * 100);
      return '(${discount.toStringAsFixed(0)}% OFF)';
    }
    return 'No Discount';
  }
}

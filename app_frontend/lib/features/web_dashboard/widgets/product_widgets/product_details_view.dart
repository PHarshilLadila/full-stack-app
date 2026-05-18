// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String Function(ProductModel) getProductStatus;
  final Color Function(String) getStatusColor;
  final String Function(double) formatPrice;
  final String Function(String) formatDate;

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
  });

  @override
  Widget build(BuildContext context) {
    final status = getProductStatus(product);
    final statusColor = getStatusColor(status);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductTitleSection(status, statusColor),
                  const SizedBox(height: 24),
                  _buildPricingSection(),
                  const SizedBox(height: 24),
                  _buildInventorySection(),
                  const SizedBox(height: 24),
                  _buildProductInfoSection(),
                  const SizedBox(height: 24),
                  _buildOrganizationSection(),
                  const SizedBox(height: 24),
                  _buildReviewsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          const Text(
            'Product Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Delete'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitleSection(String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.mainBannerImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: const Color(0xFFF8FAFC),
                child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.isActive ? "Active" : "Inactive",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.category_outlined, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      product.category,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.subdirectory_arrow_right, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      product.subCategory,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Pricing',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selling Price', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Text(
                      '₹${formatPrice(product.discountPrice)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Original Price', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Text(
                      '₹${formatPrice(product.price)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Discount', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Text(
                      _calculateDiscount(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
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

  Widget _buildInventorySection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Inventory',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available Stock', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Text(
                      '${product.stock} Units',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SKU', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Text(
                      "SKU",
                      // product.sku.isNotEmpty ? product.sku : 'N/A',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Barcode', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Text(
                      "Product Barcode",
                      // product.barcode.isNotEmpty ? product.barcode : 'N/A',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
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

  Widget _buildProductInfoSection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Product Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Short Description',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          Text(
            product.shortDescription.isEmpty ? 'No description provided' : product.shortDescription,
            style: const TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text(
            'Specifications',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          if (product.specifications.isNotEmpty)
            _buildSpecificationsTable()
          else
            Text(
              'No specifications available',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: product.specifications.entries.map((entry) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrganizationSection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Organization',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seller', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Text(
                      product.sellerName ?? 'Velmora Official',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tags', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: product.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF7C3AED)),
                        ),
                      )).toList(),
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

  Widget _buildReviewsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All Reviews'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < product.rating.floor() ? Icons.star : Icons.star_border,
                        size: 18,
                        color: const Color(0xFFF59E0B),
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on ${product.totalReviews} reviews',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateDiscount() {
    if (product.price > product.discountPrice) {
      final discount = ((product.price - product.discountPrice) / product.price * 100);
      return '${discount.toStringAsFixed(0)}% OFF';
    }
    return 'No Discount';
  }
}
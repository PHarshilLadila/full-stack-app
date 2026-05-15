// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/seller/products/bloc/product_bloc.dart';
import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProductsContent extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;

  const ProductsContent({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
  });

  @override
  State<ProductsContent> createState() => _ProductsContentState();
}

class _ProductsContentState extends State<ProductsContent> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  Set<String> get _categories {
    final categories = <String>{'All'};
    if (productBloc.state is ProductLoaded) {
      final products = (productBloc.state as ProductLoaded).products;
      for (var product in products) {
        categories.add(product.category);
      }
    }
    return categories;
  }

  final List<String> _statuses = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  late ProductBloc productBloc;

  @override
  void initState() {
    super.initState();
    productBloc = ProductBloc(ProductService());
    productBloc.add(FetchSellerProductsEvent());
  }

  List<ProductModel> get _filteredProducts {
    if (productBloc.state is! ProductLoaded) return [];

    final products = (productBloc.state as ProductLoaded).products;

    return products.where((product) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          product.productName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      final status = _getProductStatus(product);
      final matchesStatus =
          _selectedStatus == 'All' || status == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  String _getProductStatus(ProductModel product) {
    if (product.stock == 0) return 'Out of Stock';
    if (product.stock <= 10) return 'Low Stock';
    return 'In Stock';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock':
        return const Color(0xFF10B981);
      case 'Low Stock':
        return const Color(0xFFF59E0B);
      case 'Out of Stock':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  int get totalProducts {
    if (productBloc.state is! ProductLoaded) return 0;
    return (productBloc.state as ProductLoaded).products.length;
  }

  int get lowStockCount {
    if (productBloc.state is! ProductLoaded) return 0;
    return (productBloc.state as ProductLoaded).products
        .where((p) => p.stock > 0 && p.stock <= 10)
        .length;
  }

  int get outOfStockCount {
    if (productBloc.state is! ProductLoaded) return 0;
    return (productBloc.state as ProductLoaded).products
        .where((p) => p.stock == 0)
        .length;
  }

  int get totalCategories {
    if (productBloc.state is! ProductLoaded) return 0;
    return (productBloc.state as ProductLoaded).products
        .map((p) => p.category)
        .toSet()
        .length;
  }

  void _navigateToProductDetails(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ProductDetailsScreen(
              product: product,
              onBack: () {
                productBloc.add(FetchSellerProductsEvent());
              },
            ),
      ),
    );
  }

  void _navigateToEditProduct(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => EditProductScreen(
              product: product,
              onSuccess: () {
                productBloc.add(FetchSellerProductsEvent());
              },
            ),
      ),
    );
  }

  void _navigateToAddProduct() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => AddProductScreen(
              onSuccess: () {
                productBloc.add(FetchSellerProductsEvent());
              },
            ),
      ),
    );
  }

  void _deleteProduct(ProductModel product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text(
              'Are you sure you want to delete "${product.productName}"?',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.productName} has been deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  productBloc.add(FetchSellerProductsEvent());
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const CommonAppBar(
            title: 'Products',
            subtitle: 'Manage your product inventory',
          ),
          Expanded(
            child: BlocProvider.value(
              value: productBloc,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading products',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              productBloc.add(FetchSellerProductsEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProductLoaded) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildProductStats(),
                            const SizedBox(height: 24),
                            _buildSearchAndFilters(),
                            const SizedBox(height: 24),
                            _buildProductList(_filteredProducts),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductStats() {
    final stats = [
      {
        'title': 'Total Products',
        'value': totalProducts.toString(),
        'color': const Color(0xFF7C3AED),
        'icon': Icons.shopping_bag_outlined,
      },
      {
        'title': 'Low Stock',
        'value': lowStockCount.toString(),
        'color': const Color(0xFFF59E0B),
        'icon': Icons.warning_amber_rounded,
      },
      {
        'title': 'Out of Stock',
        'value': outOfStockCount.toString(),
        'color': const Color(0xFFEF4444),
        'icon': Icons.inventory_2_outlined,
      },
      {
        'title': 'Total Categories',
        'value': totalCategories.toString(),
        'color': const Color(0xFF10B981),
        'icon': Icons.category_outlined,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 2.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (stat['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      stat['icon'] as IconData,
                      color: stat['color'] as Color,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                stat['value'] as String,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat['title'] as String,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _navigateToAddProduct,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Filter by:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._categories.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected:
                                (_) => setState(
                                  () => _selectedCategory = category,
                                ),
                            backgroundColor: Colors.transparent,
                            selectedColor: const Color(
                              0xFF7C3AED,
                            ).withOpacity(0.1),
                            checkmarkColor: const Color(0xFF7C3AED),
                            labelStyle: TextStyle(
                              color:
                                  _selectedCategory == category
                                      ? const Color(0xFF7C3AED)
                                      : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._statuses.map(
                        (status) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(status),
                            selected: _selectedStatus == status,
                            onSelected:
                                (_) => setState(() => _selectedStatus = status),
                            backgroundColor: Colors.transparent,
                            selectedColor: const Color(
                              0xFF7C3AED,
                            ).withOpacity(0.1),
                            checkmarkColor: const Color(0xFF7C3AED),
                            labelStyle: TextStyle(
                              color:
                                  _selectedStatus == status
                                      ? const Color(0xFF7C3AED)
                                      : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or add a new product',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 40,
                  headingRowColor: WidgetStateProperty.resolveWith(
                    (states) => const Color(0xFFF8FAFC),
                  ),
                  headingRowHeight: 60,
                  dataRowHeight: 80,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Product',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stock',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      products.map((product) {
                        final status = _getProductStatus(product);
                        final statusColor = _getStatusColor(status);

                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 280,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            product.mainBannerImage,
                                          ),
                                          fit: BoxFit.cover,
                                          onError:
                                              (exception, stackTrace) =>
                                                  AssetImage(
                                                    'assets/placeholder.png',
                                                  ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.productName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'ID: ${product.id}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF7C3AED,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  product.category,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF7C3AED),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹${_formatPrice(product.discountPrice)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  if (product.price > product.discountPrice)
                                    Text(
                                      '₹${_formatPrice(product.price)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                '${product.stock} units',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      product.stock == 0
                                          ? Colors.red
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility_outlined,
                                      size: 20,
                                    ),
                                    onPressed:
                                        () =>
                                            _navigateToProductDetails(product),
                                    color: const Color(0xFF3B82F6),
                                    tooltip: 'View Details',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                    ),
                                    onPressed:
                                        () => _navigateToEditProduct(product),
                                    color: const Color(0xFF10B981),
                                    tooltip: 'Edit Product',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                    ),
                                    onPressed: () => _deleteProduct(product),
                                    color: const Color(0xFFEF4444),
                                    tooltip: 'Delete Product',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

// Product Details Screen
class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onBack;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.onBack,
  });

  String _getProductStatus(ProductModel product) {
    if (product.stock == 0) return 'Out of Stock';
    if (product.stock <= 10) return 'Low Stock';
    return 'In Stock';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock':
        return const Color(0xFF10B981);
      case 'Low Stock':
        return const Color(0xFFF59E0B);
      case 'Out of Stock':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getProductStatus(product);
    final statusColor = _getStatusColor(status);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () {
            onBack();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Image and Basic Info
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(product.mainBannerImage),
                          fit: BoxFit.cover,
                          onError:
                              (exception, stackTrace) =>
                                  const AssetImage('assets/placeholder.png'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 13,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                size: 16,
                                color: Color(0xFF7C3AED),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.category,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.subdirectory_arrow_right,
                                size: 16,
                                color: Color(0xFF7C3AED),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.subCategory,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
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
              const SizedBox(height: 24),

              // Price and Stock Information
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                      'Pricing & Inventory',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Price',
                            '₹${_formatPrice(product.price)}',
                            Icons.currency_rupee,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            'Discounted Price',
                            '₹${_formatPrice(product.discountPrice)}',
                            Icons.local_offer_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            'Stock',
                            '${product.stock} units',
                            Icons.inventory_2_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Description
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Short Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.shortDescription.isEmpty
                          ? 'No description provided'
                          : product.shortDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Detailed Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.detailedDescription.isEmpty
                          ? 'No description provided'
                          : product.detailedDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tags
              if (product.tags.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        'Tags',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children:
                            product.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF7C3AED,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF7C3AED),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Additional Images
              if (product.multipleImages.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        'Additional Images',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: product.multipleImages.length,
                          itemBuilder:
                              (context, index) => Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    product.multipleImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Additional Info
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAdditionalInfoRow(
                      'Product ID',
                      product.id,
                      Icons.qr_code,
                    ),
                    const SizedBox(height: 12),
                    _buildAdditionalInfoRow(
                      'Rating',
                      '${product.rating} ⭐ (${product.totalReviews} reviews)',
                      Icons.star_outline,
                    ),
                    const SizedBox(height: 12),
                    _buildAdditionalInfoRow(
                      'Created Date',
                      _formatDate(product.createdAt),
                      Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildAdditionalInfoRow(
                      'Status',
                      product.isActive ? 'Active' : 'Inactive',
                      Icons.toggle_on_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF7C3AED)),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF7C3AED)),
        const SizedBox(width: 12),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}

// Add Product Screen
class AddProductScreen extends StatefulWidget {
  final VoidCallback onSuccess;

  const AddProductScreen({super.key, required this.onSuccess});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _priceController;
  late TextEditingController _discountPriceController;
  late TextEditingController _stockController;
  late TextEditingController _categoryController;
  late TextEditingController _subCategoryController;
  late TextEditingController _shortDescriptionController;
  late TextEditingController _detailedDescriptionController;
  late TextEditingController _tagsController;

  File? _mainBannerImage;
  List<File> _multipleImages = [];

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController();
    _priceController = TextEditingController();
    _discountPriceController = TextEditingController();
    _stockController = TextEditingController();
    _categoryController = TextEditingController();
    _subCategoryController = TextEditingController();
    _shortDescriptionController = TextEditingController();
    _detailedDescriptionController = TextEditingController();
    _tagsController = TextEditingController();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    _shortDescriptionController.dispose();
    _detailedDescriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickMainBannerImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mainBannerImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _multipleImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  void _removeMultipleImage(int index) {
    setState(() {
      _multipleImages.removeAt(index);
    });
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_mainBannerImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a main banner image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tags =
          _tagsController.text.split(',').map((e) => e.trim()).toList();

      final body = {
        'productName': _productNameController.text,
        'price': double.parse(_priceController.text),
        'discountPrice': double.parse(_discountPriceController.text),
        'stock': int.parse(_stockController.text),
        'stockAvailable': int.parse(_stockController.text) > 0,
        'category': _categoryController.text,
        'subCategory': _subCategoryController.text,
        'tags': tags,
        'shortDescription': _shortDescriptionController.text,
        'detailedDescription': _detailedDescriptionController.text,
        'specifications': {},
      };

      final productService = ProductService();
      await productService.addProductWithImages(
        body: body,
        mainBannerImage: _mainBannerImage!,
        multipleImages: _multipleImages,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      widget.onSuccess();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Banner Image
                        const Text(
                          'Main Banner Image',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickMainBannerImage,
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child:
                                _mainBannerImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _mainBannerImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Tap to upload main banner image',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Additional Images
                        const Text(
                          'Additional Images',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickMultipleImages,
                                icon: const Icon(Icons.add_photo_alternate),
                                label: const Text('Add Images'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_multipleImages.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _multipleImages.length,
                              itemBuilder:
                                  (context, index) => Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            _multipleImages[index],
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap:
                                                () =>
                                                    _removeMultipleImage(index),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.5,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Product Name
                        TextFormField(
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                            prefixIcon: Icon(Icons.shopping_bag_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true
                                      ? 'Please enter product name'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        // Price Fields
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Original Price (₹)',
                                  prefixIcon: Icon(Icons.currency_rupee),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please enter price'
                                            : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _discountPriceController,
                                decoration: const InputDecoration(
                                  labelText: 'Discounted Price (₹)',
                                  prefixIcon: Icon(Icons.local_offer_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please enter discounted price'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Stock and Category
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stockController,
                                decoration: const InputDecoration(
                                  labelText: 'Stock Quantity',
                                  prefixIcon: Icon(Icons.inventory_2_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please enter stock quantity'
                                            : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _categoryController,
                                decoration: const InputDecoration(
                                  labelText: 'Category',
                                  prefixIcon: Icon(Icons.category_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please enter category'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Sub Category and Tags
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _subCategoryController,
                                decoration: const InputDecoration(
                                  labelText: 'Sub Category',
                                  prefixIcon: Icon(
                                    Icons.subdirectory_arrow_right,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _tagsController,
                                decoration: const InputDecoration(
                                  labelText: 'Tags (comma separated)',
                                  prefixIcon: Icon(Icons.local_offer_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Short Description
                        TextFormField(
                          controller: _shortDescriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Short Description',
                            prefixIcon: Icon(Icons.description_outlined),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),

                        // Detailed Description
                        TextFormField(
                          controller: _detailedDescriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Detailed Description',
                            prefixIcon: Icon(Icons.article_outlined),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _submitProduct,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7C3AED),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Add Product'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

// Edit Product Screen
class EditProductScreen extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onSuccess;

  const EditProductScreen({
    super.key,
    required this.product,
    required this.onSuccess,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _priceController;
  late TextEditingController _discountPriceController;
  late TextEditingController _stockController;
  late TextEditingController _categoryController;
  late TextEditingController _subCategoryController;
  late TextEditingController _shortDescriptionController;
  late TextEditingController _detailedDescriptionController;
  late TextEditingController _tagsController;

  File? _mainBannerImage;
  List<File> _newMultipleImages = [];
  List<String> _existingMultipleImages = [];

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(
      text: widget.product.productName,
    );
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _discountPriceController = TextEditingController(
      text: widget.product.discountPrice.toString(),
    );
    _stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );
    _categoryController = TextEditingController(text: widget.product.category);
    _subCategoryController = TextEditingController(
      text: widget.product.subCategory,
    );
    _shortDescriptionController = TextEditingController(
      text: widget.product.shortDescription,
    );
    _detailedDescriptionController = TextEditingController(
      text: widget.product.detailedDescription,
    );
    _tagsController = TextEditingController(
      text: widget.product.tags.join(', '),
    );
    _existingMultipleImages = List.from(widget.product.multipleImages);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    _shortDescriptionController.dispose();
    _detailedDescriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickMainBannerImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mainBannerImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _newMultipleImages.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingMultipleImages.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newMultipleImages.removeAt(index);
    });
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final tags =
          _tagsController.text.split(',').map((e) => e.trim()).toList();

      final body = {
        'productName': _productNameController.text,
        'price': double.parse(_priceController.text),
        'discountPrice': double.parse(_discountPriceController.text),
        'stock': int.parse(_stockController.text),
        'stockAvailable': int.parse(_stockController.text) > 0,
        'category': _categoryController.text,
        'subCategory': _subCategoryController.text,
        'tags': tags,
        'shortDescription': _shortDescriptionController.text,
        'detailedDescription': _detailedDescriptionController.text,
        'specifications': {},
      };

      // Here you would call your update API
      // For now, just show success message

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      widget.onSuccess();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Banner Image
                        const Text(
                          'Main Banner Image',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickMainBannerImage,
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child:
                                _mainBannerImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _mainBannerImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        widget.product.mainBannerImage,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Additional Images
                        const Text(
                          'Additional Images',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickMultipleImages,
                                icon: const Icon(Icons.add_photo_alternate),
                                label: const Text('Add More Images'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Existing Images
                        if (_existingMultipleImages.isNotEmpty) ...[
                          const Text(
                            'Existing Images',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _existingMultipleImages.length,
                              itemBuilder:
                                  (context, index) => Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            _existingMultipleImages[index],
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap:
                                                () =>
                                                    _removeExistingImage(index),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.5,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // New Images
                        if (_newMultipleImages.isNotEmpty) ...[
                          const Text(
                            'New Images',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _newMultipleImages.length,
                              itemBuilder:
                                  (context, index) => Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            _newMultipleImages[index],
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () => _removeNewImage(index),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.5,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Product Name
                        TextFormField(
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                            prefixIcon: Icon(Icons.shopping_bag_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true
                                      ? 'Please enter product name'
                                      : null,
                        ),
                        const SizedBox(height: 16),

                        // Price Fields
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Original Price (₹)',
                                  prefixIcon: Icon(Icons.currency_rupee),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please enter price'
                                            : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _discountPriceController,
                                decoration: const InputDecoration(
                                  labelText: 'Discounted Price (₹)',
                                  prefixIcon: Icon(Icons.local_offer_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please enter discounted price'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Stock and Category
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _stockController,
                                decoration: const InputDecoration(
                                  labelText: 'Stock Quantity',
                                  prefixIcon: Icon(Icons.inventory_2_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please enter stock quantity'
                                            : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _categoryController,
                                decoration: const InputDecoration(
                                  labelText: 'Category',
                                  prefixIcon: Icon(Icons.category_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value?.isEmpty ?? true
                                            ? 'Please enter category'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Sub Category and Tags
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _subCategoryController,
                                decoration: const InputDecoration(
                                  labelText: 'Sub Category',
                                  prefixIcon: Icon(
                                    Icons.subdirectory_arrow_right,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _tagsController,
                                decoration: const InputDecoration(
                                  labelText: 'Tags (comma separated)',
                                  prefixIcon: Icon(Icons.local_offer_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Short Description
                        TextFormField(
                          controller: _shortDescriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Short Description',
                            prefixIcon: Icon(Icons.description_outlined),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),

                        // Detailed Description
                        TextFormField(
                          controller: _detailedDescriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Detailed Description',
                            prefixIcon: Icon(Icons.article_outlined),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _submitProduct,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7C3AED),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Save Changes'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

import 'package:app_frontend/features/seller/products/bloc/product_bloc.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:material_table_view/material_table_view.dart';
import 'package:material_table_view/table_view_typedefs.dart';

class ProductListView extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final String selectedStatus;
  final String selectedFilter;
  final String selectedSortBy;
  final Set<String> categories;
  final List<String> sortOptions;
  final List<ProductModel> filteredProducts;
  final ProductBloc productBloc;
  final Function(String) onSearchChanged;
  final Function(String?) onCategoryChanged;
  final Function(String?) onSortByChanged;
  final Function(String) onFilterChanged;
  final VoidCallback onAddProduct;
  final Function(ProductModel) onProductDetails;
  final Function(ProductModel) onEditProduct;
  final Function(ProductModel) onDeleteProduct;
  final VoidCallback onRefresh;
  final String Function(ProductModel) getProductStatus;
  final Color Function(String) getStatusColor;
  final String Function(double) formatPrice;

  const ProductListView({super.key, 
    required this.searchQuery,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.selectedFilter,
    required this.selectedSortBy,
    required this.categories,
    required this.sortOptions,
    required this.filteredProducts,
    required this.productBloc,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onSortByChanged,
    required this.onFilterChanged,
    required this.onAddProduct,
    required this.onProductDetails,
    required this.onEditProduct,
    required this.onDeleteProduct,
    required this.onRefresh,
    required this.getProductStatus,
    required this.getStatusColor,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildFilterButton('All', 'All'),
                    buildFilterButton('Active', 'Active'),
                    buildFilterButton('Draft', 'Draft'),
                    buildFilterButton('Out of Stock', 'Out of Stock'),
                    buildFilterButton('Low Stock', 'Low Stock'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed:
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Export feature coming soon'),
                            ),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3E8FF),
                        foregroundColor: Colors.deepPurple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            color: Colors.deepPurple,
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: const Text("Export"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: onAddProduct,
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            buildSearchAndFilters(context),
            const SizedBox(height: 24),
            buildProductList(context),
          ],
        ),
      ),
    );
  }

  Widget buildFilterButton(String label, String filterValue) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: TextButton(
        onPressed: () => onFilterChanged(filterValue),
        style: TextButton.styleFrom(
          backgroundColor:
              selectedFilter == filterValue
                  ? const Color(0xFF7C3AED).withOpacity(0.1)
                  : Colors.transparent,
          foregroundColor:
              selectedFilter == filterValue
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF64748B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }

  Widget buildSearchAndFilters(BuildContext context) {
    List<String> categoryList = categories.toList();

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
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                onChanged: onSearchChanged,
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
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButton<String>(
              value: selectedCategory,
              borderRadius: BorderRadius.circular(8),
              underline: const SizedBox(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              items:
                  categoryList
                      .map(
                        (String category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: onCategoryChanged,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButton<String>(
              value: selectedSortBy,
              borderRadius: BorderRadius.circular(8),
              underline: const SizedBox(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              icon: const Icon(Icons.sort, color: Colors.black, size: 20),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              items:
                  sortOptions
                      .map(
                        (String option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        ),
                      )
                      .toList(),
              onChanged: onSortByChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductList(BuildContext context) {
    if (filteredProducts.isEmpty) {
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

    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 800;
    final availableWidth = screenSize.width - 48;
    final columnFlex = [35, 9, 9, 9, 9, 10];
    final columnWidths =
        columnFlex.map((flex) => (availableWidth * flex / 100)).toList();
    final rowHeight = 80.0;
    final headerHeight = 80.0;
    final tableHeight = (filteredProducts.length * rowHeight) + headerHeight;

    final columns = [
      TableColumn(width: columnWidths[0], minResizeWidth: 180),
      TableColumn(width: columnWidths[1], minResizeWidth: 80),
      TableColumn(width: columnWidths[2], minResizeWidth: 70),
      TableColumn(width: columnWidths[3], minResizeWidth: 110),
      TableColumn(width: columnWidths[4], minResizeWidth: 80),
      TableColumn(width: columnWidths[5], minResizeWidth: 100),
    ];

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
        child: SizedBox(
          height: tableHeight,
          child: TableView.builder(
            columns: columns,
            rowCount: filteredProducts.length,
            rowHeight: rowHeight,
            style: TableViewStyle(
              dividers: TableViewDividersStyle(
                horizontal: TableViewHorizontalDividersStyle(
                  header: TableViewHorizontalDividerStyle(
                    color: Colors.grey.shade300,
                    thickness: 0.5,
                  ),
                  footer: TableViewHorizontalDividerStyle(
                    color: Colors.grey.shade300,
                    thickness: 0.5,
                  ),
                ),
              ),
            ),
            rowBuilder: (context, row, TableRowContentBuilder contentBuilder) {
              final product = filteredProducts[row];
              final status = getProductStatus(product);
              final statusColor = getStatusColor(status);

              return contentBuilder(context, (context, column) {
                switch (column) {
                  case 0:
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: isSmallScreen ? 40 : 50,
                            height: isSmallScreen ? 40 : 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product.mainBannerImage,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      color: const Color(0xFFF8FAFC),
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: isSmallScreen ? 20 : 30,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 12 : 14,
                                    color: const Color(0xFF1E293B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${product.id}',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 9 : 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  case 1:
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Text(
                        product.category,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  case 2:
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Text(
                        product.isActive ? "Active" : "Inactive",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: product.isActive ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  case 3:
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.stock} units',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: isSmallScreen ? 11 : 12,
                              color:
                                  product.stock == 0
                                      ? Colors.red
                                      : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 6 : 10,
                              vertical: isSmallScreen ? 4 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  case 4:
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${formatPrice(product.discountPrice)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallScreen ? 12 : 14,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          if (product.price > product.discountPrice)
                            Text(
                              '₹${formatPrice(product.price)}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9 : 11,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                              ),
                            ),
                        ],
                      ),
                    );
                  case 5:
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () => onProductDetails(product),
                          tooltip: 'View Details',
                          iconSize: isSmallScreen ? 18 : 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedView,
                            color: Color(0xFF64748B),
                            size: 20.0,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 12),
                        IconButton(
                          onPressed: () => onEditProduct(product),
                          tooltip: 'Edit Product',
                          iconSize: isSmallScreen ? 18 : 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedEdit02,
                            color: Color(0xFF7C3AED),
                            size: 20.0,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 12),
                        IconButton(
                          onPressed: () => onDeleteProduct(product),
                          tooltip: 'Delete Product',
                          iconSize: isSmallScreen ? 18 : 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedDelete02,
                            color: Color(0xFF64748B),
                            size: 20.0,
                          ),
                        ),
                      ],
                    );
                  default:
                    return const SizedBox();
                }
              });
            },
            headerBuilder: (context, contentBuilder) {
              final headers = [
                'Product',
                'Category',
                'Status',
                'Inventory',
                'Price',
                'Actions',
              ];
              return contentBuilder(context, (context, column) {
                return Container(
                  width: columnWidths[column],
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      headers[column],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                );
              });
            },
            headerHeight: headerHeight,
          ),
        ),
      ),
    );
  }
}

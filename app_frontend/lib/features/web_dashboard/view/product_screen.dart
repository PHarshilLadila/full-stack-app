// // // ignore_for_file: deprecated_member_use

// // import 'package:app_frontend/features/seller/products/bloc/product_bloc.dart';
// // import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
// // import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
// // import 'package:app_frontend/features/seller/products/service/product_service.dart';
// // import 'package:app_frontend/features/seller/products/model/product_model.dart';
// // import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:hugeicons/hugeicons.dart';
// // import 'dart:io';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:html' as html;
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'dart:developer';

// // import 'package:material_table_view/material_table_view.dart';
// // import 'package:material_table_view/table_view_typedefs.dart';

// // enum _CurrentView { productList, productDetails, addProduct, editProduct }

// // class ProductsContent extends StatefulWidget {
// //   final String userName;
// //   final String userEmail;
// //   final String? userProfileImage;

// //   const ProductsContent({
// //     super.key,
// //     required this.userName,
// //     required this.userEmail,
// //     this.userProfileImage,
// //   });

// //   @override
// //   State<ProductsContent> createState() => _ProductsContentState();
// // }

// // class _ProductsContentState extends State<ProductsContent> {
// //   String _searchQuery = '';
// //   String _selectedCategory = 'All';
// //   String _selectedStatus = 'All';
// //   String _selectedFilter = 'All';
// //   String _selectedSortBy = 'Newest';

// //   _CurrentView _currentView = _CurrentView.productList;
// //   ProductModel? _selectedProduct;

// //   Set<String> get _categories {
// //     final categories = <String>{'All'};
// //     if (productBloc.state is ProductLoaded) {
// //       final products = (productBloc.state as ProductLoaded).products;
// //       for (var product in products) {
// //         categories.add(product.category);
// //       }
// //     }
// //     return categories;
// //   }

// //   final List<String> _statuses = [
// //     'All',
// //     'In Stock',
// //     'Low Stock',
// //     'Out of Stock',
// //   ];

// //   final List<String> _sortOptions = [
// //     'Newest',
// //     'Price: Low to High',
// //     'Price: High to Low',
// //     'Name: A to Z',
// //     'Name: Z to A',
// //   ];

// //   late ProductBloc productBloc;

// //   @override
// //   void initState() {
// //     super.initState();
// //     productBloc = ProductBloc(ProductService());
// //     productBloc.add(FetchSellerProductsEvent());
// //   }

// //   List<ProductModel> get _filteredProducts {
// //     if (productBloc.state is! ProductLoaded) return [];

// //     final products = (productBloc.state as ProductLoaded).products;

// //     List<ProductModel> filtered =
// //         products.where((product) {
// //           final matchesSearch =
// //               _searchQuery.isEmpty ||
// //               product.productName.toLowerCase().contains(
// //                 _searchQuery.toLowerCase(),
// //               ) ||
// //               product.category.toLowerCase().contains(
// //                 _searchQuery.toLowerCase(),
// //               );

// //           final matchesCategory =
// //               _selectedCategory == 'All' ||
// //               product.category == _selectedCategory;

// //           final status = _getProductStatus(product);
// //           final matchesStatus =
// //               _selectedStatus == 'All' || status == _selectedStatus;

// //           bool matchesFilter = true;
// //           switch (_selectedFilter) {
// //             case 'Active':
// //               matchesFilter = product.isActive == true;
// //               break;
// //             case 'Draft':
// //               matchesFilter = product.isActive == false;
// //               break;
// //             case 'Out of Stock':
// //               matchesFilter = product.stock == 0;
// //               break;
// //             case 'Low Stock':
// //               matchesFilter = product.stock > 0 && product.stock <= 10;
// //               break;
// //             case 'All':
// //             default:
// //               matchesFilter = true;
// //               break;
// //           }

// //           return matchesSearch &&
// //               matchesCategory &&
// //               matchesStatus &&
// //               matchesFilter;
// //         }).toList();

// //     filtered.sort((a, b) {
// //       switch (_selectedSortBy) {
// //         case 'Newest':
// //           return b.createdAt.compareTo(a.createdAt);
// //         case 'Price: Low to High':
// //           return a.discountPrice.compareTo(b.discountPrice);
// //         case 'Price: High to Low':
// //           return b.discountPrice.compareTo(a.discountPrice);
// //         case 'Name: A to Z':
// //           return a.productName.compareTo(b.productName);
// //         case 'Name: Z to A':
// //           return b.productName.compareTo(a.productName);
// //         default:
// //           return b.createdAt.compareTo(a.createdAt);
// //       }
// //     });

// //     return filtered;
// //   }

// //   String _getProductStatus(ProductModel product) {
// //     if (product.stock == 0) return 'Out of Stock';
// //     if (product.stock <= 10) return 'Low Stock';
// //     return 'In Stock';
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'In Stock':
// //         return const Color(0xFF10B981);
// //       case 'Low Stock':
// //         return const Color(0xFFF59E0B);
// //       case 'Out of Stock':
// //         return const Color(0xFFEF4444);
// //       default:
// //         return const Color(0xFF94A3B8);
// //     }
// //   }

// //   int get totalProducts {
// //     if (productBloc.state is! ProductLoaded) return 0;
// //     return (productBloc.state as ProductLoaded).products.length;
// //   }

// //   int get lowStockCount {
// //     if (productBloc.state is! ProductLoaded) return 0;
// //     return (productBloc.state as ProductLoaded).products
// //         .where((p) => p.stock > 0 && p.stock <= 10)
// //         .length;
// //   }

// //   int get outOfStockCount {
// //     if (productBloc.state is! ProductLoaded) return 0;
// //     return (productBloc.state as ProductLoaded).products
// //         .where((p) => p.stock == 0)
// //         .length;
// //   }

// //   int get totalCategories {
// //     if (productBloc.state is! ProductLoaded) return 0;
// //     return (productBloc.state as ProductLoaded).products
// //         .map((p) => p.category)
// //         .toSet()
// //         .length;
// //   }

// //   void _showProductDetails(ProductModel product) {
// //     setState(() {
// //       _selectedProduct = product;
// //       _currentView = _CurrentView.productDetails;
// //     });
// //   }

// //   void _showEditProduct(ProductModel product) {
// //     setState(() {
// //       _selectedProduct = product;
// //       _currentView = _CurrentView.editProduct;
// //     });
// //   }

// //   void _showAddProduct() {
// //     setState(() {
// //       _currentView = _CurrentView.addProduct;
// //     });
// //   }

// //   void _showProductList() {
// //     setState(() {
// //       _currentView = _CurrentView.productList;
// //       _selectedProduct = null;
// //     });
// //     productBloc.add(FetchSellerProductsEvent());
// //   }

// //   void _deleteProduct(ProductModel product) {
// //     showDialog(
// //       context: context,
// //       builder:
// //           (context) => AlertDialog(
// //             title: const Text('Delete Product'),
// //             content: Text(
// //               'Are you sure you want to delete "${product.productName}"?',
// //             ),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(16),
// //             ),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: const Text('Cancel'),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   Navigator.pop(context);
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text('${product.productName} has been deleted'),
// //                       backgroundColor: Colors.green,
// //                     ),
// //                   );
// //                   productBloc.add(FetchSellerProductsEvent());
// //                 },
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //                 child: const Text('Delete'),
// //               ),
// //             ],
// //           ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8FAFC),
// //       body: Column(
// //         children: [
// //           const CommonAppBar(
// //             title: 'Products',
// //             subtitle: 'Manage your product inventory',
// //           ),
// //           Expanded(
// //             child: BlocProvider.value(
// //               value: productBloc,
// //               child: BlocBuilder<ProductBloc, ProductState>(
// //                 builder: (context, state) {
// //                   if (state is ProductLoading &&
// //                       _currentView == _CurrentView.productList) {
// //                     return const Center(child: CircularProgressIndicator());
// //                   } else if (state is ProductError &&
// //                       _currentView == _CurrentView.productList) {
// //                     return Center(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(
// //                             Icons.error_outline,
// //                             size: 64,
// //                             color: Colors.red.shade300,
// //                           ),
// //                           const SizedBox(height: 16),
// //                           Text(
// //                             'Error loading products',
// //                             style: TextStyle(
// //                               fontSize: 18,
// //                               color: Colors.grey.shade600,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 8),
// //                           Text(
// //                             state.message,
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               color: Colors.grey.shade500,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 16),
// //                           ElevatedButton(
// //                             onPressed:
// //                                 () =>
// //                                     productBloc.add(FetchSellerProductsEvent()),
// //                             child: const Text('Retry'),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   } else if (state is ProductLoaded ||
// //                       _currentView != _CurrentView.productList) {
// //                     return _buildCurrentView();
// //                   }
// //                   return const SizedBox();
// //                 },
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildCurrentView() {
// //     switch (_currentView) {
// //       case _CurrentView.productList:
// //         return SingleChildScrollView(
// //           child: Padding(
// //             padding: const EdgeInsets.all(24),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         _buildFilterButton('All', 'All'),
// //                         _buildFilterButton('Active', 'Active'),
// //                         _buildFilterButton('Draft', 'Draft'),
// //                         _buildFilterButton('Out of Stock', 'Out of Stock'),
// //                         _buildFilterButton('Low Stock', 'Low Stock'),
// //                       ],
// //                     ),
// //                     Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         ElevatedButton(
// //                           onPressed:
// //                               () => ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(
// //                                   content: Text('Export feature coming soon'),
// //                                 ),
// //                               ),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: const Color(0xFFF3E8FF),
// //                             foregroundColor: Colors.deepPurple,
// //                             elevation: 0,
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(8),
// //                               side: const BorderSide(
// //                                 color: Colors.deepPurple,
// //                                 width: 0.8,
// //                               ),
// //                             ),
// //                           ),
// //                           child: const Text("Export"),
// //                         ),
// //                         const SizedBox(width: 12),
// //                         ElevatedButton.icon(
// //                           onPressed: _showAddProduct,
// //                           icon: const Icon(Icons.add, size: 20),
// //                           label: const Text('Add Product'),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: const Color(0xFF7C3AED),
// //                             foregroundColor: Colors.white,
// //                             padding: const EdgeInsets.symmetric(
// //                               horizontal: 24,
// //                               vertical: 14,
// //                             ),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(8),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 24),
// //                 _buildSearchAndFilters(),
// //                 const SizedBox(height: 24),
// //                 _buildProductList(_filteredProducts),
// //               ],
// //             ),
// //           ),
// //         );
// //       case _CurrentView.productDetails:
// //         return _buildProductDetailsView();
// //       case _CurrentView.addProduct:
// //         return _buildAddProductView();
// //       case _CurrentView.editProduct:
// //         return _buildEditProductView();
// //     }
// //   }

// //   Widget _buildFilterButton(String label, String filterValue) {
// //     return Padding(
// //       padding: const EdgeInsets.only(right: 6),
// //       child: TextButton(
// //         onPressed: () => setState(() => _selectedFilter = filterValue),
// //         style: TextButton.styleFrom(
// //           backgroundColor:
// //               _selectedFilter == filterValue
// //                   ? const Color(0xFF7C3AED).withOpacity(0.1)
// //                   : Colors.transparent,
// //           foregroundColor:
// //               _selectedFilter == filterValue
// //                   ? const Color(0xFF7C3AED)
// //                   : const Color(0xFF64748B),
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //         ),
// //         child: Text(label),
// //       ),
// //     );
// //   }

// //   Widget _buildSearchAndFilters() {
// //     List<String> categoryList = _categories.toList();

// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.04),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             flex: 3,
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFF8FAFC),
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: Border.all(color: Colors.grey.shade200),
// //               ),
// //               child: TextField(
// //                 onChanged: (value) => setState(() => _searchQuery = value),
// //                 decoration: InputDecoration(
// //                   hintText: 'Search products...',
// //                   prefixIcon: const Icon(
// //                     Icons.search,
// //                     color: Color(0xFF94A3B8),
// //                   ),
// //                   border: InputBorder.none,
// //                   contentPadding: const EdgeInsets.symmetric(
// //                     horizontal: 16,
// //                     vertical: 14,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Container(
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //               border: Border.all(color: Colors.grey.shade200),
// //             ),
// //             child: DropdownButton<String>(
// //               value: _selectedCategory,
// //               borderRadius: BorderRadius.circular(8),
// //               underline: const SizedBox(),
// //               padding: const EdgeInsets.symmetric(horizontal: 12),
// //               icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
// //               style: const TextStyle(color: Colors.black, fontSize: 14),
// //               items:
// //                   categoryList
// //                       .map(
// //                         (String category) => DropdownMenuItem<String>(
// //                           value: category,
// //                           child: Text(category),
// //                         ),
// //                       )
// //                       .toList(),
// //               onChanged:
// //                   (String? newValue) =>
// //                       setState(() => _selectedCategory = newValue!),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Container(
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //               border: Border.all(color: Colors.grey.shade200),
// //             ),
// //             child: DropdownButton<String>(
// //               value: _selectedSortBy,
// //               borderRadius: BorderRadius.circular(8),
// //               underline: const SizedBox(),
// //               padding: const EdgeInsets.symmetric(horizontal: 12),
// //               icon: const Icon(Icons.sort, color: Colors.black, size: 20),
// //               style: const TextStyle(color: Colors.black, fontSize: 14),
// //               items:
// //                   _sortOptions
// //                       .map(
// //                         (String option) => DropdownMenuItem<String>(
// //                           value: option,
// //                           child: Text(option),
// //                         ),
// //                       )
// //                       .toList(),
// //               onChanged:
// //                   (String? newValue) =>
// //                       setState(() => _selectedSortBy = newValue!),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildProductList(List<ProductModel> products) {
// //     if (products.isEmpty) {
// //       return Container(
// //         padding: const EdgeInsets.all(60),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         child: Column(
// //           children: [
// //             Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
// //             const SizedBox(height: 16),
// //             Text(
// //               'No products found',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.grey.shade600,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Try adjusting your search or add a new product',
// //               style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     final screenSize = MediaQuery.of(context).size;
// //     final isSmallScreen = screenSize.width < 800;
// //     final availableWidth = screenSize.width - 48;
// //     final columnFlex = [35, 9, 9, 9, 9, 10];
// //     final columnWidths =
// //         columnFlex.map((flex) => (availableWidth * flex / 100)).toList();
// //     final rowHeight = 80.0;
// //     final headerHeight = 80.0;
// //     final tableHeight = (products.length * rowHeight) + headerHeight;

// //     final columns = [
// //       TableColumn(width: columnWidths[0], minResizeWidth: 180),
// //       TableColumn(width: columnWidths[1], minResizeWidth: 80),
// //       TableColumn(width: columnWidths[2], minResizeWidth: 70),
// //       TableColumn(width: columnWidths[3], minResizeWidth: 110),
// //       TableColumn(width: columnWidths[4], minResizeWidth: 80),
// //       TableColumn(width: columnWidths[5], minResizeWidth: 100),
// //     ];

// //     return Container(
// //       width: double.infinity,
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.04),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(20),
// //         child: SizedBox(
// //           height: tableHeight,
// //           child: TableView.builder(
// //             columns: columns,
// //             rowCount: products.length,
// //             rowHeight: rowHeight,
// //             style: TableViewStyle(
// //               dividers: TableViewDividersStyle(
// //                 horizontal: TableViewHorizontalDividersStyle(
// //                   header: TableViewHorizontalDividerStyle(
// //                     color: Colors.grey.shade300,
// //                     thickness: 0.5,
// //                   ),
// //                   footer: TableViewHorizontalDividerStyle(
// //                     color: Colors.grey.shade300,
// //                     thickness: 0.5,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             rowBuilder: (context, row, TableRowContentBuilder contentBuilder) {
// //               final product = products[row];
// //               final status = _getProductStatus(product);
// //               final statusColor = _getStatusColor(status);

// //               return contentBuilder(context, (context, column) {
// //                 switch (column) {
// //                   case 0:
// //                     return Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 8,
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Container(
// //                             width: isSmallScreen ? 40 : 50,
// //                             height: isSmallScreen ? 40 : 50,
// //                             decoration: BoxDecoration(
// //                               color: const Color(0xFFF8FAFC),
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                             child: ClipRRect(
// //                               borderRadius: BorderRadius.circular(10),
// //                               child: Image.network(
// //                                 product.mainBannerImage,
// //                                 fit: BoxFit.cover,
// //                                 errorBuilder:
// //                                     (context, error, stackTrace) => Container(
// //                                       color: const Color(0xFFF8FAFC),
// //                                       child: Icon(
// //                                         Icons.broken_image,
// //                                         color: Colors.grey,
// //                                         size: isSmallScreen ? 20 : 30,
// //                                       ),
// //                                     ),
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 12),
// //                           Expanded(
// //                             child: Column(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   product.productName,
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.w600,
// //                                     fontSize: isSmallScreen ? 12 : 14,
// //                                     color: const Color(0xFF1E293B),
// //                                   ),
// //                                   overflow: TextOverflow.ellipsis,
// //                                   maxLines: 2,
// //                                 ),
// //                                 const SizedBox(height: 4),
// //                                 Text(
// //                                   'ID: ${product.id}',
// //                                   style: TextStyle(
// //                                     fontSize: isSmallScreen ? 9 : 11,
// //                                     color: Colors.grey.shade500,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   case 1:
// //                     return Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 16,
// //                       ),
// //                       child: Text(
// //                         product.category,
// //                         style: TextStyle(
// //                           fontSize: isSmallScreen ? 11 : 12,
// //                           color: const Color(0xFF64748B),
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     );
// //                   case 2:
// //                     return Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 16,
// //                       ),
// //                       child: Text(
// //                         product.isActive ? "Active" : "Inactive",
// //                         style: TextStyle(
// //                           fontSize: isSmallScreen ? 11 : 12,
// //                           color: product.isActive ? Colors.green : Colors.grey,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     );
// //                   case 3:
// //                     return Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 8,
// //                       ),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             '${product.stock} units',
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.w500,
// //                               fontSize: isSmallScreen ? 11 : 12,
// //                               color:
// //                                   product.stock == 0
// //                                       ? Colors.red
// //                                       : const Color(0xFF64748B),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 6),
// //                           Container(
// //                             padding: EdgeInsets.symmetric(
// //                               horizontal: isSmallScreen ? 6 : 10,
// //                               vertical: isSmallScreen ? 4 : 6,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color: statusColor.withOpacity(0.1),
// //                               borderRadius: BorderRadius.circular(20),
// //                             ),
// //                             child: Text(
// //                               status,
// //                               style: TextStyle(
// //                                 fontSize: isSmallScreen ? 10 : 12,
// //                                 color: statusColor,
// //                                 fontWeight: FontWeight.w600,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   case 4:
// //                     return Padding(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 8,
// //                       ),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             '₹${_formatPrice(product.discountPrice)}',
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.w600,
// //                               fontSize: isSmallScreen ? 12 : 14,
// //                               color: const Color(0xFF1E293B),
// //                             ),
// //                           ),
// //                           if (product.price > product.discountPrice)
// //                             Text(
// //                               '₹${_formatPrice(product.price)}',
// //                               style: TextStyle(
// //                                 fontSize: isSmallScreen ? 9 : 11,
// //                                 decoration: TextDecoration.lineThrough,
// //                                 color: Colors.grey.shade500,
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                     );
// //                   case 5:
// //                     return Row(
// //                       children: [
// //                         IconButton(
// //                           onPressed: () => _showProductDetails(product),
// //                           tooltip: 'View Details',
// //                           iconSize: isSmallScreen ? 18 : 20,
// //                           padding: EdgeInsets.zero,
// //                           constraints: const BoxConstraints(),
// //                           icon: const HugeIcon(
// //                             icon: HugeIcons.strokeRoundedView,
// //                             color: Color(0xFF64748B),
// //                             size: 20.0,
// //                           ),
// //                         ),
// //                         SizedBox(width: isSmallScreen ? 4 : 12),
// //                         IconButton(
// //                           onPressed: () => _showEditProduct(product),
// //                           tooltip: 'Edit Product',
// //                           iconSize: isSmallScreen ? 18 : 20,
// //                           padding: EdgeInsets.zero,
// //                           constraints: const BoxConstraints(),
// //                           icon: const HugeIcon(
// //                             icon: HugeIcons.strokeRoundedEdit02,
// //                             color: Color(0xFF7C3AED),
// //                             size: 20.0,
// //                           ),
// //                         ),
// //                         SizedBox(width: isSmallScreen ? 4 : 12),
// //                         IconButton(
// //                           onPressed: () => _deleteProduct(product),
// //                           tooltip: 'Delete Product',
// //                           iconSize: isSmallScreen ? 18 : 20,
// //                           padding: EdgeInsets.zero,
// //                           constraints: const BoxConstraints(),
// //                           icon: const HugeIcon(
// //                             icon: HugeIcons.strokeRoundedDelete02,
// //                             color: Color(0xFF64748B),
// //                             size: 20.0,
// //                           ),
// //                         ),
// //                       ],
// //                     );
// //                   default:
// //                     return const SizedBox();
// //                 }
// //               });
// //             },
// //             headerBuilder: (context, contentBuilder) {
// //               final headers = [
// //                 'Product',
// //                 'Category',
// //                 'Status',
// //                 'Inventory',
// //                 'Price',
// //                 'Actions',
// //               ];
// //               return contentBuilder(context, (context, column) {
// //                 return Container(
// //                   width: columnWidths[column],
// //                   decoration: const BoxDecoration(
// //                     color: Color(0xFFF8FAFC),
// //                     border: Border(
// //                       bottom: BorderSide(color: Colors.grey, width: 0.5),
// //                     ),
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 16,
// //                       vertical: 12,
// //                     ),
// //                     child: Text(
// //                       headers[column],
// //                       style: const TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 14,
// //                         color: Color(0xFF64748B),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               });
// //             },
// //             headerHeight: headerHeight,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   String _formatPrice(double price) {
// //     return price
// //         .toStringAsFixed(0)
// //         .replaceAllMapped(
// //           RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
// //           (Match m) => '${m[1]},',
// //         );
// //   }

// //   Widget _buildProductDetailsView() {
// //     if (_selectedProduct == null) return const SizedBox();
// //     return SingleChildScrollView(
// //       child: Padding(
// //         padding: const EdgeInsets.all(24),
// //         child: Column(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.04),
// //                     blurRadius: 10,
// //                     offset: const Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: Row(
// //                 children: [
// //                   IconButton(
// //                     onPressed: _showProductList,
// //                     icon: const Icon(Icons.arrow_back),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   const Text(
// //                     'Back to Products',
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             _buildProductDetails(_selectedProduct!),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildAddProductView() {
// //     return SingleChildScrollView(
// //       child: Padding(
// //         padding: const EdgeInsets.all(24),
// //         child: Column(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.04),
// //                     blurRadius: 10,
// //                     offset: const Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: Row(
// //                 children: [
// //                   IconButton(
// //                     onPressed: _showProductList,
// //                     icon: const Icon(Icons.arrow_back),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   const Text(
// //                     'Back to Products',
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             _AddProductFormWidget(onSuccess: _showProductList),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEditProductView() {
// //     if (_selectedProduct == null) return const SizedBox();
// //     return SingleChildScrollView(
// //       child: Padding(
// //         padding: const EdgeInsets.all(24),
// //         child: Column(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.04),
// //                     blurRadius: 10,
// //                     offset: const Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: Row(
// //                 children: [
// //                   IconButton(
// //                     onPressed: _showProductList,
// //                     icon: const Icon(Icons.arrow_back),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   const Text(
// //                     'Back to Products',
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             _EditProductFormWidget(
// //               product: _selectedProduct!,
// //               onSuccess: _showProductList,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildProductDetails(ProductModel product) {
// //     final status = _getProductStatus(product);
// //     final statusColor = _getStatusColor(status);
// //     final screenSize = MediaQuery.of(context).size;
// //     final isSmallScreen = screenSize.width < 800;
// //     final isMediumScreen = screenSize.width >= 800 && screenSize.width < 1200;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Container(
// //           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.04),
// //                 blurRadius: 10,
// //                 offset: const Offset(0, 2),
// //               ),
// //             ],
// //           ),
// //           child:
// //               isSmallScreen
// //                   ? Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Center(
// //                         child: Container(
// //                           width: 150,
// //                           height: 150,
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFFF8FAFC),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: ClipRRect(
// //                             borderRadius: BorderRadius.circular(12),
// //                             child: Image.network(
// //                               product.mainBannerImage,
// //                               fit: BoxFit.cover,
// //                               errorBuilder:
// //                                   (context, error, stackTrace) => Container(
// //                                     color: const Color(0xFFF8FAFC),
// //                                     child: const Icon(
// //                                       Icons.broken_image,
// //                                       color: Colors.grey,
// //                                       size: 40,
// //                                     ),
// //                                   ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Row(
// //                             children: [
// //                               Text(
// //                                 product.productName,
// //                                 style: TextStyle(
// //                                   fontSize: isSmallScreen ? 20 : 24,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: const Color(0xFF1E293B),
// //                                 ),
// //                               ),
// //                               Container(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: 12,
// //                                   vertical: 6,
// //                                 ),
// //                                 decoration: BoxDecoration(
// //                                   color: statusColor.withOpacity(0.1),
// //                                   borderRadius: BorderRadius.circular(20),
// //                                 ),
// //                                 child: Text(
// //                                   product.isActive == true
// //                                       ? "Active"
// //                                       : "Inactive",
// //                                   style: TextStyle(
// //                                     fontSize: 13,
// //                                     color: statusColor,
// //                                     fontWeight: FontWeight.w600,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 8),
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(
// //                               horizontal: 12,
// //                               vertical: 6,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color: statusColor.withOpacity(0.1),
// //                               borderRadius: BorderRadius.circular(20),
// //                             ),
// //                             child: Text(
// //                               status,
// //                               style: TextStyle(
// //                                 fontSize: 13,
// //                                 color: statusColor,
// //                                 fontWeight: FontWeight.w600,
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 16),
// //                           Wrap(
// //                             spacing: 16,
// //                             runSpacing: 8,
// //                             children: [
// //                               Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   const Icon(
// //                                     Icons.category_outlined,
// //                                     size: 16,
// //                                     color: Color(0xFF7C3AED),
// //                                   ),
// //                                   const SizedBox(width: 4),
// //                                   Text(
// //                                     product.category,
// //                                     style: const TextStyle(
// //                                       fontSize: 14,
// //                                       color: Color(0xFF64748B),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                               Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   const Icon(
// //                                     Icons.subdirectory_arrow_right,
// //                                     size: 16,
// //                                     color: Color(0xFF7C3AED),
// //                                   ),
// //                                   const SizedBox(width: 4),
// //                                   Text(
// //                                     product.subCategory,
// //                                     style: const TextStyle(
// //                                       fontSize: 14,
// //                                       color: Color(0xFF64748B),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   )
// //                   : Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Container(
// //                       //   width: isMediumScreen ? 100 : 120,
// //                       //   height: isMediumScreen ? 100 : 120,
// //                       //   decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
// //                       //   child: ClipRRect(
// //                       //     borderRadius: BorderRadius.circular(12),
// //                       //     child: Image.network(product.mainBannerImage, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFF8FAFC), child: const Icon(Icons.broken_image, color: Colors.grey, size: 40))),
// //                       //   ),
// //                       // ),
// //                       // const SizedBox(width: 24),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,

// //                         children: [
// //                           Row(
// //                             mainAxisSize: MainAxisSize.min,

// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

// //                             children: [
// //                               Expanded(
// //                                 child: Row(
// //                                   mainAxisSize: MainAxisSize.min,
// //                                   children: [
// //                                     Text(
// //                                       product.productName,
// //                                       style: TextStyle(
// //                                         fontSize: isSmallScreen ? 20 : 24,
// //                                         fontWeight: FontWeight.bold,
// //                                         color: const Color(0xFF1E293B),
// //                                       ),
// //                                     ),
// //                                     const SizedBox(width: 12),
// //                                     Container(
// //                                       padding: EdgeInsets.symmetric(
// //                                         horizontal: 12,
// //                                         vertical: 6,
// //                                       ),
// //                                       decoration: BoxDecoration(
// //                                         color: statusColor.withOpacity(0.1),
// //                                         borderRadius: BorderRadius.circular(6),
// //                                       ),
// //                                       child: Text(
// //                                         product.isActive == true
// //                                             ? "Active"
// //                                             : "Inactive",
// //                                         style: TextStyle(
// //                                           fontSize: 13,
// //                                           color: statusColor,
// //                                           fontWeight: FontWeight.w600,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                               Row(
// //                                 mainAxisSize: MainAxisSize.min,

// //                                 children: [
// //                                   ElevatedButton.icon(
// //                                     onPressed:
// //                                         () => ScaffoldMessenger.of(
// //                                           context,
// //                                         ).showSnackBar(
// //                                           const SnackBar(
// //                                             content: Text(
// //                                               'Export feature coming soon',
// //                                             ),
// //                                           ),
// //                                         ),
// //                                     icon: const Icon(Icons.share, size: 18),
// //                                     label: const Text("Share"),
// //                                     style: ElevatedButton.styleFrom(
// //                                       backgroundColor: Colors.white,
// //                                       foregroundColor: Colors.black,
// //                                       elevation: 0,
// //                                       shape: RoundedRectangleBorder(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         side: BorderSide(
// //                                           color: Colors.grey.withOpacity(0.5),
// //                                           width: 0.8,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   SizedBox(width: 12),
// //                                   ElevatedButton.icon(
// //                                     onPressed:
// //                                         () => ScaffoldMessenger.of(
// //                                           context,
// //                                         ).showSnackBar(
// //                                           const SnackBar(
// //                                             content: Text(
// //                                               'Export feature coming soon',
// //                                             ),
// //                                           ),
// //                                         ),
// //                                     icon: const Icon(Icons.delete, size: 18),
// //                                     label: const Text("Delete"),
// //                                     style: ElevatedButton.styleFrom(
// //                                       backgroundColor: Colors.white,
// //                                       foregroundColor: Colors.black,
// //                                       elevation: 0,
// //                                       shape: RoundedRectangleBorder(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         side: BorderSide(
// //                                           color: Colors.orange.withOpacity(0.5),
// //                                           width: 0.8,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   SizedBox(width: 12),

// //                                   ElevatedButton.icon(
// //                                     onPressed:
// //                                         () => ScaffoldMessenger.of(
// //                                           context,
// //                                         ).showSnackBar(
// //                                           const SnackBar(
// //                                             content: Text(
// //                                               'Export feature coming soon',
// //                                             ),
// //                                           ),
// //                                         ),
// //                                     icon: const Icon(Icons.edit, size: 18),
// //                                     label: const Text("Edit"),
// //                                     style: ElevatedButton.styleFrom(
// //                                       backgroundColor: Colors.deepPurple,
// //                                       foregroundColor: Colors.white,
// //                                       elevation: 0,
// //                                       shape: RoundedRectangleBorder(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         side: BorderSide(
// //                                           color: Colors.white.withOpacity(0.5),
// //                                           width: 0.8,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                           // const SizedBox(height: 8),
// //                           // Container(
// //                           //   padding: const EdgeInsets.symmetric(
// //                           //     horizontal: 12,
// //                           //     vertical: 6,
// //                           //   ),
// //                           //   decoration: BoxDecoration(
// //                           //     color: statusColor.withOpacity(0.1),
// //                           //     borderRadius: BorderRadius.circular(20),
// //                           //   ),
// //                           //   child: Text(
// //                           //     status,
// //                           //     style: TextStyle(
// //                           //       fontSize: 13,
// //                           //       color: statusColor,
// //                           //       fontWeight: FontWeight.w600,
// //                           //     ),
// //                           //   ),
// //                           // ),
// //                           // const SizedBox(height: 16),
// //                           // Wrap(
// //                           //   spacing: 16,
// //                           //   runSpacing: 8,
// //                           //   children: [
// //                           //     Row(
// //                           //       mainAxisSize: MainAxisSize.min,
// //                           //       children: [
// //                           //         const Icon(
// //                           //           Icons.category_outlined,
// //                           //           size: 16,
// //                           //           color: Color(0xFF7C3AED),
// //                           //         ),
// //                           //         const SizedBox(width: 4),
// //                           //         Text(
// //                           //           product.category,
// //                           //           style: const TextStyle(
// //                           //             fontSize: 14,
// //                           //             color: Color(0xFF64748B),
// //                           //           ),
// //                           //         ),
// //                           //       ],
// //                           //     ),
// //                           //     Row(
// //                           //       mainAxisSize: MainAxisSize.min,
// //                           //       children: [
// //                           //         const Icon(
// //                           //           Icons.subdirectory_arrow_right,
// //                           //           size: 16,
// //                           //           color: Color(0xFF7C3AED),
// //                           //         ),
// //                           //         const SizedBox(width: 4),
// //                           //         Text(
// //                           //           product.subCategory,
// //                           //           style: const TextStyle(
// //                           //             fontSize: 14,
// //                           //             color: Color(0xFF64748B),
// //                           //           ),
// //                           //         ),
// //                           //       ],
// //                           //     ),
// //                           //   ],
// //                           // ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //         ),
// //         const SizedBox(height: 24),
// //         Container(
// //           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.04),
// //                 blurRadius: 10,
// //                 offset: const Offset(0, 2),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'Pricing & Inventory',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Color(0xFF1E293B),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               isSmallScreen
// //                   ? Column(
// //                     children: [
// //                       _buildInfoCard(
// //                         'Price',
// //                         '₹${_formatPrice(product.price)}',
// //                         Icons.currency_rupee,
// //                       ),
// //                       const SizedBox(height: 12),
// //                       _buildInfoCard(
// //                         'Discounted Price',
// //                         '₹${_formatPrice(product.discountPrice)}',
// //                         Icons.local_offer_outlined,
// //                       ),
// //                       const SizedBox(height: 12),
// //                       _buildInfoCard(
// //                         'Stock',
// //                         '${product.stock} units',
// //                         Icons.inventory_2_outlined,
// //                       ),
// //                     ],
// //                   )
// //                   : Row(
// //                     children: [
// //                       Expanded(
// //                         child: _buildInfoCard(
// //                           'Price',
// //                           '₹${_formatPrice(product.price)}',
// //                           Icons.currency_rupee,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 16),
// //                       Expanded(
// //                         child: _buildInfoCard(
// //                           'Discounted Price',
// //                           '₹${_formatPrice(product.discountPrice)}',
// //                           Icons.local_offer_outlined,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 16),
// //                       Expanded(
// //                         child: _buildInfoCard(
// //                           'Stock',
// //                           '${product.stock} units',
// //                           Icons.inventory_2_outlined,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(height: 24),
// //         Container(
// //           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.04),
// //                 blurRadius: 10,
// //                 offset: const Offset(0, 2),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'Description',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Color(0xFF1E293B),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               const Text(
// //                 'Short Description',
// //                 style: TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFF64748B),
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Container(
// //                 width: double.infinity,
// //                 padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFFF8FAFC),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Text(
// //                   product.shortDescription.isEmpty
// //                       ? 'No description provided'
// //                       : product.shortDescription,
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     color: Color(0xFF475569),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               const Text(
// //                 'Detailed Description',
// //                 style: TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFF64748B),
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Container(
// //                 width: double.infinity,
// //                 padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFFF8FAFC),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Text(
// //                   product.detailedDescription.isEmpty
// //                       ? 'No description provided'
// //                       : product.detailedDescription,
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     color: Color(0xFF475569),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(height: 24),
// //         if (product.tags.isNotEmpty)
// //           Container(
// //             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(20),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.04),
// //                   blurRadius: 10,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   'Tags',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF1E293B),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children:
// //                       product.tags
// //                           .map(
// //                             (tag) => Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 12,
// //                                 vertical: 6,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: const Color(0xFF7C3AED).withOpacity(0.1),
// //                                 borderRadius: BorderRadius.circular(20),
// //                               ),
// //                               child: Text(
// //                                 tag,
// //                                 style: const TextStyle(
// //                                   fontSize: 13,
// //                                   color: Color(0xFF7C3AED),
// //                                 ),
// //                               ),
// //                             ),
// //                           )
// //                           .toList(),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         const SizedBox(height: 24),
// //         if (product.multipleImages.isNotEmpty)
// //           Container(
// //             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(20),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.04),
// //                   blurRadius: 10,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   'Additional Images',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF1E293B),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 SizedBox(
// //                   height: 120,
// //                   child: ListView.builder(
// //                     scrollDirection: Axis.horizontal,
// //                     itemCount: product.multipleImages.length,
// //                     itemBuilder:
// //                         (context, index) => Container(
// //                           width: 120,
// //                           margin: const EdgeInsets.only(right: 12),
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(12),
// //                             border: Border.all(color: Colors.grey.shade200),
// //                           ),
// //                           child: ClipRRect(
// //                             borderRadius: BorderRadius.circular(12),
// //                             child: Image.network(
// //                               product.multipleImages[index],
// //                               fit: BoxFit.cover,
// //                               width: 120,
// //                               height: 120,
// //                               errorBuilder:
// //                                   (context, error, stackTrace) => Container(
// //                                     color: const Color(0xFFF8FAFC),
// //                                     child: const Icon(
// //                                       Icons.broken_image,
// //                                       color: Colors.grey,
// //                                       size: 40,
// //                                     ),
// //                                   ),
// //                             ),
// //                           ),
// //                         ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         const SizedBox(height: 24),
// //         if (product.specifications.isNotEmpty)
// //           Container(
// //             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(20),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.04),
// //                   blurRadius: 10,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   'Product Specifications',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF1E293B),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 ListView.separated(
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: product.specifications.length,
// //                   separatorBuilder:
// //                       (context, index) => const Divider(height: 1),
// //                   itemBuilder: (context, index) {
// //                     final entry = product.specifications.entries.elementAt(
// //                       index,
// //                     );
// //                     return Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 12),
// //                       child:
// //                           isSmallScreen
// //                               ? Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     entry.key,
// //                                     style: const TextStyle(
// //                                       fontWeight: FontWeight.w600,
// //                                       fontSize: 14,
// //                                       color: Color(0xFF1E293B),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Text(
// //                                     entry.value.toString(),
// //                                     style: const TextStyle(
// //                                       fontSize: 13,
// //                                       color: Color(0xFF64748B),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               )
// //                               : Row(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   SizedBox(
// //                                     width: 160,
// //                                     child: Text(
// //                                       entry.key,
// //                                       style: const TextStyle(
// //                                         fontWeight: FontWeight.w600,
// //                                         fontSize: 14,
// //                                         color: Color(0xFF1E293B),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(width: 16),
// //                                   Expanded(
// //                                     child: Text(
// //                                       entry.value.toString(),
// //                                       style: const TextStyle(
// //                                         fontSize: 13,
// //                                         color: Color(0xFF64748B),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                     );
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         const SizedBox(height: 24),
// //         Container(
// //           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.04),
// //                 blurRadius: 10,
// //                 offset: const Offset(0, 2),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'Additional Information',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Color(0xFF1E293B),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),
// //               _buildAdditionalInfoRow(
// //                 'Product ID',
// //                 product.id,
// //                 Icons.qr_code,
// //                 isSmallScreen,
// //               ),
// //               const SizedBox(height: 12),
// //               _buildAdditionalInfoRow(
// //                 'Rating',
// //                 '${product.rating} ⭐ (${product.totalReviews} reviews)',
// //                 Icons.star_outline,
// //                 isSmallScreen,
// //               ),
// //               const SizedBox(height: 12),
// //               _buildAdditionalInfoRow(
// //                 'Created Date',
// //                 _formatDate(product.createdAt),
// //                 Icons.calendar_today_outlined,
// //                 isSmallScreen,
// //               ),
// //               const SizedBox(height: 12),
// //               _buildAdditionalInfoRow(
// //                 'Status',
// //                 product.isActive ? 'Active' : 'Inactive',
// //                 Icons.toggle_on_outlined,
// //                 isSmallScreen,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildInfoCard(String title, String value, IconData icon) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF8FAFC),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Icon(icon, size: 20, color: const Color(0xFF7C3AED)),
// //           const SizedBox(height: 8),
// //           Text(
// //             title,
// //             style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             value,
// //             style: const TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.w600,
// //               color: Color(0xFF1E293B),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAdditionalInfoRow(
// //     String label,
// //     String value,
// //     IconData icon,
// //     bool isSmallScreen,
// //   ) {
// //     if (isSmallScreen) {
// //       return Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(icon, size: 18, color: const Color(0xFF7C3AED)),
// //               const SizedBox(width: 12),
// //               Text(
// //                 label,
// //                 style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           Padding(
// //             padding: const EdgeInsets.only(left: 30),
// //             child: Text(
// //               value,
// //               style: const TextStyle(
// //                 fontSize: 13,
// //                 fontWeight: FontWeight.w500,
// //                 color: Color(0xFF1E293B),
// //               ),
// //             ),
// //           ),
// //         ],
// //       );
// //     }
// //     return Row(
// //       children: [
// //         Icon(icon, size: 18, color: const Color(0xFF7C3AED)),
// //         const SizedBox(width: 12),
// //         SizedBox(
// //           width: 120,
// //           child: Text(
// //             label,
// //             style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: Text(
// //             value,
// //             style: const TextStyle(
// //               fontSize: 13,
// //               fontWeight: FontWeight.w500,
// //               color: Color(0xFF1E293B),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   String _formatDate(String dateString) {
// //     try {
// //       final date = DateTime.parse(dateString);
// //       return '${date.day}/${date.month}/${date.year}';
// //     } catch (e) {
// //       return dateString;
// //     }
// //   }
// // }

// // // Add Product Form Widget with Specifications
// // class _AddProductFormWidget extends StatefulWidget {
// //   final VoidCallback onSuccess;
// //   const _AddProductFormWidget({required this.onSuccess});

// //   @override
// //   State<_AddProductFormWidget> createState() => _AddProductFormWidgetState();
// // }

// // class _AddProductFormWidgetState extends State<_AddProductFormWidget> {
// //   final _formKey = GlobalKey<FormState>();
// //   late TextEditingController _productNameController;
// //   late TextEditingController _priceController;
// //   late TextEditingController _discountPriceController;
// //   late TextEditingController _stockController;
// //   late TextEditingController _categoryController;
// //   late TextEditingController _subCategoryController;
// //   late TextEditingController _shortDescriptionController;
// //   late TextEditingController _detailedDescriptionController;
// //   late TextEditingController _tagsController;

// //   List<MapEntry<String, String>> _specifications = [];

// //   List<int>? _mainBannerImageBytes;
// //   String? _mainBannerImageName;
// //   String? _mainBannerImageUrl;

// //   List<List<int>> _multipleImagesBytes = [];
// //   List<String> _multipleImageNames = [];
// //   List<String> _multipleImageUrls = [];

// //   final ImagePicker _picker = ImagePicker();
// //   bool _isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _productNameController = TextEditingController();
// //     _priceController = TextEditingController();
// //     _discountPriceController = TextEditingController();
// //     _stockController = TextEditingController();
// //     _categoryController = TextEditingController();
// //     _subCategoryController = TextEditingController();
// //     _shortDescriptionController = TextEditingController();
// //     _detailedDescriptionController = TextEditingController();
// //     _tagsController = TextEditingController();
// //   }

// //   @override
// //   void dispose() {
// //     if (_mainBannerImageUrl != null)
// //       html.Url.revokeObjectUrl(_mainBannerImageUrl!);
// //     for (var url in _multipleImageUrls) html.Url.revokeObjectUrl(url);
// //     _productNameController.dispose();
// //     _priceController.dispose();
// //     _discountPriceController.dispose();
// //     _stockController.dispose();
// //     _categoryController.dispose();
// //     _subCategoryController.dispose();
// //     _shortDescriptionController.dispose();
// //     _detailedDescriptionController.dispose();
// //     _tagsController.dispose();
// //     super.dispose();
// //   }

// //   void _addSpecification() =>
// //       setState(() => _specifications.add(const MapEntry('', '')));

// //   void _updateSpecification(int index, String key, String value) =>
// //       setState(() => _specifications[index] = MapEntry(key, value));

// //   void _removeSpecification(int index) =>
// //       setState(() => _specifications.removeAt(index));

// //   Future<void> _pickMainBannerImage() async {
// //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       final bytes = await pickedFile.readAsBytes();
// //       final blob = html.Blob([bytes]);
// //       final url = html.Url.createObjectUrlFromBlob(blob);
// //       setState(() {
// //         _mainBannerImageBytes = bytes;
// //         _mainBannerImageName = pickedFile.name;
// //         _mainBannerImageUrl = url;
// //       });
// //     }
// //   }

// //   Future<void> _pickMultipleImages() async {
// //     final pickedFiles = await _picker.pickMultiImage();
// //     if (pickedFiles.isNotEmpty) {
// //       final List<String> urls = [];
// //       final List<List<int>> bytesList = [];
// //       final List<String> names = [];
// //       for (var file in pickedFiles) {
// //         final bytes = await file.readAsBytes();
// //         final blob = html.Blob([bytes]);
// //         final url = html.Url.createObjectUrlFromBlob(blob);
// //         urls.add(url);
// //         bytesList.add(bytes);
// //         names.add(file.name);
// //       }
// //       setState(() {
// //         _multipleImageUrls.addAll(urls);
// //         _multipleImagesBytes.addAll(bytesList);
// //         _multipleImageNames.addAll(names);
// //       });
// //     }
// //   }

// //   void _removeMultipleImage(int index) {
// //     html.Url.revokeObjectUrl(_multipleImageUrls[index]);
// //     setState(() {
// //       _multipleImageUrls.removeAt(index);
// //       _multipleImagesBytes.removeAt(index);
// //       _multipleImageNames.removeAt(index);
// //     });
// //   }

// //   Future<void> _submitProduct() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     if (_mainBannerImageBytes == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Please select a main banner image')),
// //       );
// //       return;
// //     }

// //     setState(() => _isLoading = true);

// //     try {
// //       final tags =
// //           _tagsController.text
// //               .split(',')
// //               .map((e) => e.trim())
// //               .where((e) => e.isNotEmpty)
// //               .toList();

// //       final Map<String, dynamic> specifications = {};
// //       for (var spec in _specifications) {
// //         if (spec.key.trim().isNotEmpty && spec.value.trim().isNotEmpty) {
// //           specifications[spec.key.trim()] = spec.value.trim();
// //         }
// //       }

// //       final body = {
// //         'productName': _productNameController.text,
// //         'price': double.parse(_priceController.text),
// //         'discountPrice': double.parse(_discountPriceController.text),
// //         'stock': int.parse(_stockController.text),
// //         'stockAvailable': int.parse(_stockController.text) > 0,
// //         'category': _categoryController.text,
// //         'subCategory': _subCategoryController.text,
// //         'tags': tags,
// //         'shortDescription': _shortDescriptionController.text,
// //         'detailedDescription': _detailedDescriptionController.text,
// //         'specifications': specifications,
// //       };

// //       final productService = ProductService();
// //       await productService.addProductWithImageBytes(
// //         body: body,
// //         mainBannerImageBytes: _mainBannerImageBytes!,
// //         mainBannerImageName: _mainBannerImageName!,
// //         multipleImagesBytes: _multipleImagesBytes,
// //         multipleImagesNames: _multipleImageNames,
// //       );

// //       if (_mainBannerImageUrl != null)
// //         html.Url.revokeObjectUrl(_mainBannerImageUrl!);
// //       for (var url in _multipleImageUrls) html.Url.revokeObjectUrl(url);

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Product added successfully'),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //         widget.onSuccess();
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Error: ${e.toString()}'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) setState(() => _isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenSize = MediaQuery.of(context).size;
// //     final isSmallScreen = screenSize.width < 800;

// //     return Container(
// //       padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.04),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child:
// //           _isLoading
// //               ? const Center(child: CircularProgressIndicator())
// //               : Form(
// //                 key: _formKey,
// //                 child: SingleChildScrollView(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Main Banner Image *',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w600,
// //                           color: Color(0xFF1E293B),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       GestureDetector(
// //                         onTap: _pickMainBannerImage,
// //                         child: Container(
// //                           height: 150,
// //                           width: double.infinity,
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFFF8FAFC),
// //                             borderRadius: BorderRadius.circular(12),
// //                             border: Border.all(color: Colors.grey.shade300),
// //                           ),
// //                           child:
// //                               _mainBannerImageUrl != null
// //                                   ? ClipRRect(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     child: Image.network(
// //                                       _mainBannerImageUrl!,
// //                                       fit: BoxFit.cover,
// //                                       width: double.infinity,
// //                                     ),
// //                                   )
// //                                   : Column(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     children: [
// //                                       Icon(
// //                                         Icons.cloud_upload,
// //                                         size: 40,
// //                                         color: Colors.grey.shade400,
// //                                       ),
// //                                       const SizedBox(height: 8),
// //                                       Text(
// //                                         'Tap to upload main banner image',
// //                                         style: TextStyle(
// //                                           color: Colors.grey.shade600,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 24),
// //                       const Text(
// //                         'Additional Images',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w600,
// //                           color: Color(0xFF1E293B),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       OutlinedButton.icon(
// //                         onPressed: _pickMultipleImages,
// //                         icon: const Icon(Icons.add_photo_alternate),
// //                         label: const Text('Add Images'),
// //                         style: OutlinedButton.styleFrom(
// //                           padding: const EdgeInsets.symmetric(vertical: 12),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 12),
// //                       if (_multipleImageUrls.isNotEmpty)
// //                         SizedBox(
// //                           height: 100,
// //                           child: ListView.builder(
// //                             scrollDirection: Axis.horizontal,
// //                             itemCount: _multipleImageUrls.length,
// //                             itemBuilder:
// //                                 (context, index) => Container(
// //                                   width: 100,
// //                                   margin: const EdgeInsets.only(right: 8),
// //                                   decoration: BoxDecoration(
// //                                     borderRadius: BorderRadius.circular(8),
// //                                     border: Border.all(
// //                                       color: Colors.grey.shade300,
// //                                     ),
// //                                   ),
// //                                   child: Stack(
// //                                     children: [
// //                                       ClipRRect(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         child: Image.network(
// //                                           _multipleImageUrls[index],
// //                                           fit: BoxFit.cover,
// //                                           width: 100,
// //                                           height: 100,
// //                                         ),
// //                                       ),
// //                                       Positioned(
// //                                         top: 4,
// //                                         right: 4,
// //                                         child: GestureDetector(
// //                                           onTap:
// //                                               () => _removeMultipleImage(index),
// //                                           child: Container(
// //                                             decoration: BoxDecoration(
// //                                               color: Colors.black.withOpacity(
// //                                                 0.5,
// //                                               ),
// //                                               shape: BoxShape.circle,
// //                                             ),
// //                                             child: const Icon(
// //                                               Icons.close,
// //                                               size: 16,
// //                                               color: Colors.white,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                           ),
// //                         ),
// //                       const SizedBox(height: 24),
// //                       TextFormField(
// //                         controller: _productNameController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Product Name *',
// //                           prefixIcon: Icon(Icons.shopping_bag_outlined),
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         validator:
// //                             (value) =>
// //                                 value?.isEmpty ?? true
// //                                     ? 'Please enter product name'
// //                                     : null,
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _priceController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Original Price (₹) *',
// //                                 prefixIcon: Icon(Icons.currency_rupee),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                               validator:
// //                                   (value) =>
// //                                       value?.isEmpty ?? true
// //                                           ? 'Please enter price'
// //                                           : null,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _discountPriceController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Discounted Price (₹) *',
// //                                 prefixIcon: Icon(Icons.local_offer_outlined),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                               validator:
// //                                   (value) =>
// //                                       value?.isEmpty ?? true
// //                                           ? 'Please enter discounted price'
// //                                           : null,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _stockController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Stock Quantity *',
// //                                 prefixIcon: Icon(Icons.inventory_2_outlined),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                               validator:
// //                                   (value) =>
// //                                       value?.isEmpty ?? true
// //                                           ? 'Please enter stock quantity'
// //                                           : null,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _categoryController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Category *',
// //                                 prefixIcon: Icon(Icons.category_outlined),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                               validator:
// //                                   (value) =>
// //                                       value?.isEmpty ?? true
// //                                           ? 'Please enter category'
// //                                           : null,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _subCategoryController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Sub Category',
// //                                 prefixIcon: Icon(
// //                                   Icons.subdirectory_arrow_right,
// //                                 ),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _tagsController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Tags (comma separated)',
// //                                 prefixIcon: Icon(Icons.local_offer_outlined),
// //                                 border: OutlineInputBorder(),
// //                                 helperText: 'e.g., popular, new, sale',
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         controller: _shortDescriptionController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Short Description',
// //                           prefixIcon: Icon(Icons.description_outlined),
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         maxLines: 2,
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         controller: _detailedDescriptionController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Detailed Description',
// //                           prefixIcon: Icon(Icons.article_outlined),
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         maxLines: 4,
// //                       ),
// //                       const SizedBox(height: 24),
// //                       Container(
// //                         padding: const EdgeInsets.all(16),
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xFFF8FAFC),
// //                           borderRadius: BorderRadius.circular(12),
// //                           border: Border.all(color: Colors.grey.shade200),
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 const Text(
// //                                   'Product Specifications',
// //                                   style: TextStyle(
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Color(0xFF1E293B),
// //                                   ),
// //                                 ),
// //                                 TextButton.icon(
// //                                   onPressed: _addSpecification,
// //                                   icon: const Icon(Icons.add, size: 18),
// //                                   label: const Text('Add Specification'),
// //                                   style: TextButton.styleFrom(
// //                                     foregroundColor: const Color(0xFF7C3AED),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             const SizedBox(height: 16),
// //                             if (_specifications.isEmpty)
// //                               Container(
// //                                 padding: const EdgeInsets.all(32),
// //                                 alignment: Alignment.center,
// //                                 child: Column(
// //                                   children: [
// //                                     Icon(
// //                                       Icons.settings_outlined,
// //                                       size: 48,
// //                                       color: Colors.grey.shade400,
// //                                     ),
// //                                     const SizedBox(height: 8),
// //                                     Text(
// //                                       'No specifications added',
// //                                       style: TextStyle(
// //                                         color: Colors.grey.shade500,
// //                                         fontSize: 14,
// //                                       ),
// //                                     ),
// //                                     const SizedBox(height: 4),
// //                                     Text(
// //                                       'Click "Add Specification" to add product features',
// //                                       style: TextStyle(
// //                                         color: Colors.grey.shade400,
// //                                         fontSize: 12,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               )
// //                             else
// //                               ListView.separated(
// //                                 shrinkWrap: true,
// //                                 physics: const NeverScrollableScrollPhysics(),
// //                                 itemCount: _specifications.length,
// //                                 separatorBuilder:
// //                                     (context, index) =>
// //                                         const SizedBox(height: 12),
// //                                 itemBuilder: (context, index) {
// //                                   final spec = _specifications[index];
// //                                   return Row(
// //                                     children: [
// //                                       Expanded(
// //                                         child: TextFormField(
// //                                           initialValue: spec.key,
// //                                           decoration: const InputDecoration(
// //                                             labelText: 'Specification Name',
// //                                             hintText:
// //                                                 'e.g., Brand, Color, Size',
// //                                             border: OutlineInputBorder(),
// //                                             contentPadding:
// //                                                 EdgeInsets.symmetric(
// //                                                   horizontal: 12,
// //                                                   vertical: 12,
// //                                                 ),
// //                                           ),
// //                                           onChanged:
// //                                               (value) => _updateSpecification(
// //                                                 index,
// //                                                 value,
// //                                                 spec.value,
// //                                               ),
// //                                         ),
// //                                       ),
// //                                       const SizedBox(width: 12),
// //                                       Expanded(
// //                                         child: TextFormField(
// //                                           initialValue: spec.value,
// //                                           decoration: const InputDecoration(
// //                                             labelText: 'Specification Value',
// //                                             hintText: 'e.g., Nike, Black, XL',
// //                                             border: OutlineInputBorder(),
// //                                             contentPadding:
// //                                                 EdgeInsets.symmetric(
// //                                                   horizontal: 12,
// //                                                   vertical: 12,
// //                                                 ),
// //                                           ),
// //                                           onChanged:
// //                                               (value) => _updateSpecification(
// //                                                 index,
// //                                                 spec.key,
// //                                                 value,
// //                                               ),
// //                                         ),
// //                                       ),
// //                                       IconButton(
// //                                         onPressed:
// //                                             () => _removeSpecification(index),
// //                                         icon: const Icon(
// //                                           Icons.delete_outline,
// //                                           color: Colors.red,
// //                                         ),
// //                                         tooltip: 'Remove',
// //                                       ),
// //                                     ],
// //                                   );
// //                                 },
// //                               ),
// //                           ],
// //                         ),
// //                       ),
// //                       const SizedBox(height: 24),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: OutlinedButton(
// //                               onPressed: widget.onSuccess,
// //                               style: OutlinedButton.styleFrom(
// //                                 padding: const EdgeInsets.symmetric(
// //                                   vertical: 12,
// //                                 ),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                               ),
// //                               child: const Text('Cancel'),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: ElevatedButton(
// //                               onPressed: _submitProduct,
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: const Color(0xFF7C3AED),
// //                                 foregroundColor: Colors.white,
// //                                 padding: const EdgeInsets.symmetric(
// //                                   vertical: 12,
// //                                 ),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                               ),
// //                               child: const Text('Add Product'),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //     );
// //   }
// // }

// // // Edit Product Form Widget with Specifications
// // class _EditProductFormWidget extends StatefulWidget {
// //   final ProductModel product;
// //   final VoidCallback onSuccess;
// //   const _EditProductFormWidget({
// //     required this.product,
// //     required this.onSuccess,
// //   });

// //   @override
// //   State<_EditProductFormWidget> createState() => _EditProductFormWidgetState();
// // }

// // class _EditProductFormWidgetState extends State<_EditProductFormWidget> {
// //   final _formKey = GlobalKey<FormState>();
// //   late TextEditingController _productNameController;
// //   late TextEditingController _priceController;
// //   late TextEditingController _discountPriceController;
// //   late TextEditingController _stockController;
// //   late TextEditingController _categoryController;
// //   late TextEditingController _subCategoryController;
// //   late TextEditingController _shortDescriptionController;
// //   late TextEditingController _detailedDescriptionController;
// //   late TextEditingController _tagsController;

// //   List<MapEntry<String, String>> _specifications = [];

// //   File? _mainBannerImage;
// //   List<File> _newMultipleImages = [];
// //   List<String> _existingMultipleImages = [];

// //   List<int>? _newMainBannerImageBytes;
// //   String? _newMainBannerImageName;
// //   List<List<int>> _newMultipleImagesBytes = [];
// //   List<String> _newMultipleImagesNames = [];

// //   final ImagePicker _picker = ImagePicker();
// //   bool _isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _productNameController = TextEditingController(
// //       text: widget.product.productName,
// //     );
// //     _priceController = TextEditingController(
// //       text: widget.product.price.toString(),
// //     );
// //     _discountPriceController = TextEditingController(
// //       text: widget.product.discountPrice.toString(),
// //     );
// //     _stockController = TextEditingController(
// //       text: widget.product.stock.toString(),
// //     );
// //     _categoryController = TextEditingController(text: widget.product.category);
// //     _subCategoryController = TextEditingController(
// //       text: widget.product.subCategory,
// //     );
// //     _shortDescriptionController = TextEditingController(
// //       text: widget.product.shortDescription,
// //     );
// //     _detailedDescriptionController = TextEditingController(
// //       text: widget.product.detailedDescription,
// //     );
// //     _tagsController = TextEditingController(
// //       text: widget.product.tags.join(', '),
// //     );
// //     _specifications =
// //         widget.product.specifications.entries
// //             .map((entry) => MapEntry(entry.key, entry.value.toString()))
// //             .toList();
// //     _existingMultipleImages = List.from(widget.product.multipleImages);
// //   }

// //   @override
// //   void dispose() {
// //     _productNameController.dispose();
// //     _priceController.dispose();
// //     _discountPriceController.dispose();
// //     _stockController.dispose();
// //     _categoryController.dispose();
// //     _subCategoryController.dispose();
// //     _shortDescriptionController.dispose();
// //     _detailedDescriptionController.dispose();
// //     _tagsController.dispose();
// //     super.dispose();
// //   }

// //   void _addSpecification() =>
// //       setState(() => _specifications.add(const MapEntry('', '')));
// //   void _updateSpecification(int index, String key, String value) =>
// //       setState(() => _specifications[index] = MapEntry(key, value));
// //   void _removeSpecification(int index) =>
// //       setState(() => _specifications.removeAt(index));

// //   Future<void> _pickMainBannerImage() async {
// //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       final bytes = await pickedFile.readAsBytes();
// //       setState(() {
// //         _newMainBannerImageBytes = bytes;
// //         _newMainBannerImageName = pickedFile.name;
// //         _mainBannerImage = File(pickedFile.path);
// //       });
// //     }
// //   }

// //   Future<void> _pickMultipleImages() async {
// //     final pickedFiles = await _picker.pickMultiImage();
// //     if (pickedFiles.isNotEmpty) {
// //       final List<List<int>> bytesList = [];
// //       final List<String> names = [];
// //       final List<File> files = [];
// //       for (var file in pickedFiles) {
// //         final bytes = await file.readAsBytes();
// //         bytesList.add(bytes);
// //         names.add(file.name);
// //         files.add(File(file.path));
// //       }
// //       setState(() {
// //         _newMultipleImagesBytes.addAll(bytesList);
// //         _newMultipleImagesNames.addAll(names);
// //         _newMultipleImages.addAll(files);
// //       });
// //     }
// //   }

// //   void _removeExistingImage(int index) =>
// //       setState(() => _existingMultipleImages.removeAt(index));
// //   void _removeNewImage(int index) =>
// //       setState(() => _newMultipleImages.removeAt(index));

// //   Future<void> _submitProduct() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     setState(() => _isLoading = true);

// //     try {
// //       final tags =
// //           _tagsController.text
// //               .split(',')
// //               .map((e) => e.trim())
// //               .where((e) => e.isNotEmpty)
// //               .toList();
// //       final Map<String, dynamic> specifications = {};
// //       for (var spec in _specifications) {
// //         if (spec.key.trim().isNotEmpty && spec.value.trim().isNotEmpty) {
// //           specifications[spec.key.trim()] = spec.value.trim();
// //         }
// //       }

// //       final body = {
// //         'productId': widget.product.id,
// //         'productName': _productNameController.text,
// //         'price': double.parse(_priceController.text),
// //         'discountPrice': double.parse(_discountPriceController.text),
// //         'stock': int.parse(_stockController.text),
// //         'stockAvailable': int.parse(_stockController.text) > 0,
// //         'category': _categoryController.text,
// //         'subCategory': _subCategoryController.text,
// //         'tags': tags,
// //         'shortDescription': _shortDescriptionController.text,
// //         'detailedDescription': _detailedDescriptionController.text,
// //         'specifications': specifications,
// //       };

// //       final productService = ProductService();

// //       if (_newMainBannerImageBytes != null ||
// //           _newMultipleImagesBytes.isNotEmpty) {
// //         await productService.updateProductWithImageBytes(
// //           body: body,
// //           mainBannerImageBytes: _newMainBannerImageBytes,
// //           mainBannerImageName: _newMainBannerImageName,
// //           newMultipleImagesBytes:
// //               _newMultipleImagesBytes.isNotEmpty
// //                   ? _newMultipleImagesBytes
// //                   : null,
// //           newMultipleImagesNames:
// //               _newMultipleImagesNames.isNotEmpty
// //                   ? _newMultipleImagesNames
// //                   : null,
// //           existingMultipleImages: _existingMultipleImages,
// //         );
// //       } else {
// //         await productService.updateProduct(body: body);
// //       }

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Product updated successfully'),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //         widget.onSuccess();
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Error: ${e.toString()}'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) setState(() => _isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenSize = MediaQuery.of(context).size;
// //     final isSmallScreen = screenSize.width < 800;

// //     return Container(
// //       padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.04),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child:
// //           _isLoading
// //               ? const Center(child: CircularProgressIndicator())
// //               : Form(
// //                 key: _formKey,
// //                 child: SingleChildScrollView(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Main Banner Image',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w600,
// //                           color: Color(0xFF1E293B),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       GestureDetector(
// //                         onTap: _pickMainBannerImage,
// //                         child: Container(
// //                           height: 150,
// //                           width: double.infinity,
// //                           decoration: BoxDecoration(
// //                             color: const Color(0xFFF8FAFC),
// //                             borderRadius: BorderRadius.circular(12),
// //                             border: Border.all(color: Colors.grey.shade300),
// //                           ),
// //                           child:
// //                               _mainBannerImage != null
// //                                   ? ClipRRect(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     child: Image.file(
// //                                       _mainBannerImage!,
// //                                       fit: BoxFit.cover,
// //                                       width: double.infinity,
// //                                     ),
// //                                   )
// //                                   : ClipRRect(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     child: Image.network(
// //                                       widget.product.mainBannerImage,
// //                                       fit: BoxFit.cover,
// //                                       width: double.infinity,
// //                                       errorBuilder:
// //                                           (context, error, stackTrace) =>
// //                                               Container(
// //                                                 color: const Color(0xFFF8FAFC),
// //                                                 child: const Icon(
// //                                                   Icons.broken_image,
// //                                                   color: Colors.grey,
// //                                                   size: 40,
// //                                                 ),
// //                                               ),
// //                                     ),
// //                                   ),
// //                         ),
// //                       ),
// //                       if (_mainBannerImage == null)
// //                         Padding(
// //                           padding: const EdgeInsets.only(top: 8),
// //                           child: Text(
// //                             'Tap to change image',
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               color: const Color(0xFF7C3AED),
// //                             ),
// //                           ),
// //                         ),
// //                       const SizedBox(height: 24),
// //                       const Text(
// //                         'Additional Images',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w600,
// //                           color: Color(0xFF1E293B),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       OutlinedButton.icon(
// //                         onPressed: _pickMultipleImages,
// //                         icon: const Icon(Icons.add_photo_alternate),
// //                         label: const Text('Add More Images'),
// //                         style: OutlinedButton.styleFrom(
// //                           padding: const EdgeInsets.symmetric(vertical: 12),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 12),
// //                       if (_existingMultipleImages.isNotEmpty) ...[
// //                         const Text(
// //                           'Existing Images',
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.w500,
// //                             color: Color(0xFF64748B),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         SizedBox(
// //                           height: 100,
// //                           child: ListView.builder(
// //                             scrollDirection: Axis.horizontal,
// //                             itemCount: _existingMultipleImages.length,
// //                             itemBuilder:
// //                                 (context, index) => Container(
// //                                   width: 100,
// //                                   margin: const EdgeInsets.only(right: 8),
// //                                   decoration: BoxDecoration(
// //                                     borderRadius: BorderRadius.circular(8),
// //                                     border: Border.all(
// //                                       color: Colors.grey.shade300,
// //                                     ),
// //                                   ),
// //                                   child: Stack(
// //                                     children: [
// //                                       ClipRRect(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         child: Image.network(
// //                                           _existingMultipleImages[index],
// //                                           fit: BoxFit.cover,
// //                                           width: 100,
// //                                           height: 100,
// //                                           errorBuilder:
// //                                               (context, error, stackTrace) =>
// //                                                   Container(
// //                                                     color: const Color(
// //                                                       0xFFF8FAFC,
// //                                                     ),
// //                                                     child: const Icon(
// //                                                       Icons.broken_image,
// //                                                       color: Colors.grey,
// //                                                       size: 30,
// //                                                     ),
// //                                                   ),
// //                                         ),
// //                                       ),
// //                                       Positioned(
// //                                         top: 4,
// //                                         right: 4,
// //                                         child: GestureDetector(
// //                                           onTap:
// //                                               () => _removeExistingImage(index),
// //                                           child: Container(
// //                                             decoration: BoxDecoration(
// //                                               color: Colors.black.withOpacity(
// //                                                 0.5,
// //                                               ),
// //                                               shape: BoxShape.circle,
// //                                             ),
// //                                             child: const Icon(
// //                                               Icons.close,
// //                                               size: 16,
// //                                               color: Colors.white,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),
// //                       ],
// //                       if (_newMultipleImages.isNotEmpty) ...[
// //                         const Text(
// //                           'New Images',
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.w500,
// //                             color: Color(0xFF64748B),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         SizedBox(
// //                           height: 100,
// //                           child: ListView.builder(
// //                             scrollDirection: Axis.horizontal,
// //                             itemCount: _newMultipleImages.length,
// //                             itemBuilder:
// //                                 (context, index) => Container(
// //                                   width: 100,
// //                                   margin: const EdgeInsets.only(right: 8),
// //                                   decoration: BoxDecoration(
// //                                     borderRadius: BorderRadius.circular(8),
// //                                     border: Border.all(
// //                                       color: Colors.grey.shade300,
// //                                     ),
// //                                   ),
// //                                   child: Stack(
// //                                     children: [
// //                                       ClipRRect(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         child: Image.file(
// //                                           _newMultipleImages[index],
// //                                           fit: BoxFit.cover,
// //                                           width: 100,
// //                                           height: 100,
// //                                         ),
// //                                       ),
// //                                       Positioned(
// //                                         top: 4,
// //                                         right: 4,
// //                                         child: GestureDetector(
// //                                           onTap: () => _removeNewImage(index),
// //                                           child: Container(
// //                                             decoration: BoxDecoration(
// //                                               color: Colors.black.withOpacity(
// //                                                 0.5,
// //                                               ),
// //                                               shape: BoxShape.circle,
// //                                             ),
// //                                             child: const Icon(
// //                                               Icons.close,
// //                                               size: 16,
// //                                               color: Colors.white,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                           ),
// //                         ),
// //                       ],
// //                       const SizedBox(height: 24),
// //                       TextFormField(
// //                         controller: _productNameController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Product Name *',
// //                           prefixIcon: Icon(Icons.shopping_bag_outlined),
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         validator:
// //                             (value) =>
// //                                 value?.isEmpty ?? true
// //                                     ? 'Please enter product name'
// //                                     : null,
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _priceController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Original Price (₹) *',
// //                                 prefixIcon: Icon(Icons.currency_rupee),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                               validator:
// //                                   (value) =>
// //                                       value?.isEmpty ?? true
// //                                           ? 'Please enter price'
// //                                           : null,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _discountPriceController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Discounted Price (₹) *',
// //                                 prefixIcon: Icon(Icons.local_offer_outlined),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                               validator:
// //                                   (value) =>
// //                                       value?.isEmpty ?? true
// //                                           ? 'Please enter discounted price'
// //                                           : null,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _stockController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Stock Quantity *',
// //                                 prefixIcon: Icon(Icons.inventory_2_outlined),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                               validator:
// //                                   (value) =>
// //                                       value?.isEmpty ?? true
// //                                           ? 'Please enter stock quantity'
// //                                           : null,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _categoryController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Category *',
// //                                 prefixIcon: Icon(Icons.category_outlined),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                               validator:
// //                                   (value) =>
// //                                       value?.isEmpty ?? true
// //                                           ? 'Please enter category'
// //                                           : null,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _subCategoryController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Sub Category',
// //                                 prefixIcon: Icon(
// //                                   Icons.subdirectory_arrow_right,
// //                                 ),
// //                                 border: OutlineInputBorder(),
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: TextFormField(
// //                               controller: _tagsController,
// //                               decoration: const InputDecoration(
// //                                 labelText: 'Tags (comma separated)',
// //                                 prefixIcon: Icon(Icons.local_offer_outlined),
// //                                 border: OutlineInputBorder(),
// //                                 helperText: 'e.g., popular, new, sale',
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         controller: _shortDescriptionController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Short Description',
// //                           prefixIcon: Icon(Icons.description_outlined),
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         maxLines: 2,
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextFormField(
// //                         controller: _detailedDescriptionController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Detailed Description',
// //                           prefixIcon: Icon(Icons.article_outlined),
// //                           border: OutlineInputBorder(),
// //                         ),
// //                         maxLines: 4,
// //                       ),
// //                       const SizedBox(height: 24),
// //                       Container(
// //                         padding: const EdgeInsets.all(16),
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xFFF8FAFC),
// //                           borderRadius: BorderRadius.circular(12),
// //                           border: Border.all(color: Colors.grey.shade200),
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 const Text(
// //                                   'Product Specifications',
// //                                   style: TextStyle(
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Color(0xFF1E293B),
// //                                   ),
// //                                 ),
// //                                 TextButton.icon(
// //                                   onPressed: _addSpecification,
// //                                   icon: const Icon(Icons.add, size: 18),
// //                                   label: const Text('Add Specification'),
// //                                   style: TextButton.styleFrom(
// //                                     foregroundColor: const Color(0xFF7C3AED),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             const SizedBox(height: 16),
// //                             if (_specifications.isEmpty)
// //                               Container(
// //                                 padding: const EdgeInsets.all(32),
// //                                 alignment: Alignment.center,
// //                                 child: Column(
// //                                   children: [
// //                                     Icon(
// //                                       Icons.settings_outlined,
// //                                       size: 48,
// //                                       color: Colors.grey.shade400,
// //                                     ),
// //                                     const SizedBox(height: 8),
// //                                     Text(
// //                                       'No specifications added',
// //                                       style: TextStyle(
// //                                         color: Colors.grey.shade500,
// //                                         fontSize: 14,
// //                                       ),
// //                                     ),
// //                                     const SizedBox(height: 4),
// //                                     Text(
// //                                       'Click "Add Specification" to add product features',
// //                                       style: TextStyle(
// //                                         color: Colors.grey.shade400,
// //                                         fontSize: 12,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               )
// //                             else
// //                               ListView.separated(
// //                                 shrinkWrap: true,
// //                                 physics: const NeverScrollableScrollPhysics(),
// //                                 itemCount: _specifications.length,
// //                                 separatorBuilder:
// //                                     (context, index) =>
// //                                         const SizedBox(height: 12),
// //                                 itemBuilder: (context, index) {
// //                                   final spec = _specifications[index];
// //                                   return Row(
// //                                     children: [
// //                                       Expanded(
// //                                         child: TextFormField(
// //                                           initialValue: spec.key,
// //                                           decoration: const InputDecoration(
// //                                             labelText: 'Specification Name',
// //                                             hintText:
// //                                                 'e.g., Brand, Color, Size',
// //                                             border: OutlineInputBorder(),
// //                                             contentPadding:
// //                                                 EdgeInsets.symmetric(
// //                                                   horizontal: 12,
// //                                                   vertical: 12,
// //                                                 ),
// //                                           ),
// //                                           onChanged:
// //                                               (value) => _updateSpecification(
// //                                                 index,
// //                                                 value,
// //                                                 spec.value,
// //                                               ),
// //                                         ),
// //                                       ),
// //                                       const SizedBox(width: 12),
// //                                       Expanded(
// //                                         child: TextFormField(
// //                                           initialValue: spec.value,
// //                                           decoration: const InputDecoration(
// //                                             labelText: 'Specification Value',
// //                                             hintText: 'e.g., Nike, Black, XL',
// //                                             border: OutlineInputBorder(),
// //                                             contentPadding:
// //                                                 EdgeInsets.symmetric(
// //                                                   horizontal: 12,
// //                                                   vertical: 12,
// //                                                 ),
// //                                           ),
// //                                           onChanged:
// //                                               (value) => _updateSpecification(
// //                                                 index,
// //                                                 spec.key,
// //                                                 value,
// //                                               ),
// //                                         ),
// //                                       ),
// //                                       IconButton(
// //                                         onPressed:
// //                                             () => _removeSpecification(index),
// //                                         icon: const Icon(
// //                                           Icons.delete_outline,
// //                                           color: Colors.red,
// //                                         ),
// //                                         tooltip: 'Remove',
// //                                       ),
// //                                     ],
// //                                   );
// //                                 },
// //                               ),
// //                           ],
// //                         ),
// //                       ),
// //                       const SizedBox(height: 24),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: OutlinedButton(
// //                               onPressed: widget.onSuccess,
// //                               style: OutlinedButton.styleFrom(
// //                                 padding: const EdgeInsets.symmetric(
// //                                   vertical: 12,
// //                                 ),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                               ),
// //                               child: const Text('Cancel'),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 16),
// //                           Expanded(
// //                             child: ElevatedButton(
// //                               onPressed: _submitProduct,
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: const Color(0xFF7C3AED),
// //                                 foregroundColor: Colors.white,
// //                                 padding: const EdgeInsets.symmetric(
// //                                   vertical: 12,
// //                                 ),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                               ),
// //                               child: const Text('Save Changes'),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //     );
// //   }
// // }

// // ignore_for_file: deprecated_member_use

// import 'package:app_frontend/features/seller/products/bloc/product_bloc.dart';
// import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
// import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
// import 'package:app_frontend/features/seller/products/service/product_service.dart';
// import 'package:app_frontend/features/seller/products/model/product_model.dart';
// import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'dart:html' as html;
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:developer';

// import 'package:material_table_view/material_table_view.dart';
// import 'package:material_table_view/table_view_typedefs.dart';

// enum _CurrentView { productList, productDetails, addProduct, editProduct }

// class ProductsContent extends StatefulWidget {
//   final String userName;
//   final String userEmail;
//   final String? userProfileImage;

//   const ProductsContent({
//     super.key,
//     required this.userName,
//     required this.userEmail,
//     this.userProfileImage,
//   });

//   @override
//   State<ProductsContent> createState() => _ProductsContentState();
// }

// class _ProductsContentState extends State<ProductsContent> {
//   String _searchQuery = '';
//   String _selectedCategory = 'All';
//   String _selectedStatus = 'All';
//   String _selectedFilter = 'All';
//   String _selectedSortBy = 'Newest';

//   _CurrentView _currentView = _CurrentView.productList;
//   ProductModel? _selectedProduct;

//   Set<String> get _categories {
//     final categories = <String>{'All'};
//     if (productBloc.state is ProductLoaded) {
//       final products = (productBloc.state as ProductLoaded).products;
//       for (var product in products) {
//         categories.add(product.category);
//       }
//     }
//     return categories;
//   }

//   final List<String> _statuses = [
//     'All',
//     'In Stock',
//     'Low Stock',
//     'Out of Stock',
//   ];

//   final List<String> _sortOptions = [
//     'Newest',
//     'Price: Low to High',
//     'Price: High to Low',
//     'Name: A to Z',
//     'Name: Z to A',
//   ];

//   late ProductBloc productBloc;

//   @override
//   void initState() {
//     super.initState();
//     productBloc = ProductBloc(ProductService());
//     productBloc.add(FetchSellerProductsEvent());
//   }

//   List<ProductModel> get _filteredProducts {
//     if (productBloc.state is! ProductLoaded) return [];

//     final products = (productBloc.state as ProductLoaded).products;

//     List<ProductModel> filtered =
//         products.where((product) {
//           final matchesSearch =
//               _searchQuery.isEmpty ||
//               product.productName.toLowerCase().contains(
//                 _searchQuery.toLowerCase(),
//               ) ||
//               product.category.toLowerCase().contains(
//                 _searchQuery.toLowerCase(),
//               );

//           final matchesCategory =
//               _selectedCategory == 'All' ||
//               product.category == _selectedCategory;

//           final status = _getProductStatus(product);
//           final matchesStatus =
//               _selectedStatus == 'All' || status == _selectedStatus;

//           bool matchesFilter = true;
//           switch (_selectedFilter) {
//             case 'Active':
//               matchesFilter = product.isActive == true;
//               break;
//             case 'Draft':
//               matchesFilter = product.isActive == false;
//               break;
//             case 'Out of Stock':
//               matchesFilter = product.stock == 0;
//               break;
//             case 'Low Stock':
//               matchesFilter = product.stock > 0 && product.stock <= 10;
//               break;
//             case 'All':
//             default:
//               matchesFilter = true;
//               break;
//           }

//           return matchesSearch &&
//               matchesCategory &&
//               matchesStatus &&
//               matchesFilter;
//         }).toList();

//     filtered.sort((a, b) {
//       switch (_selectedSortBy) {
//         case 'Newest':
//           return b.createdAt.compareTo(a.createdAt);
//         case 'Price: Low to High':
//           return a.discountPrice.compareTo(b.discountPrice);
//         case 'Price: High to Low':
//           return b.discountPrice.compareTo(a.discountPrice);
//         case 'Name: A to Z':
//           return a.productName.compareTo(b.productName);
//         case 'Name: Z to A':
//           return b.productName.compareTo(a.productName);
//         default:
//           return b.createdAt.compareTo(a.createdAt);
//       }
//     });

//     return filtered;
//   }

//   String _getProductStatus(ProductModel product) {
//     if (product.stock == 0) return 'Out of Stock';
//     if (product.stock <= 10) return 'Low Stock';
//     return 'In Stock';
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'In Stock':
//         return const Color(0xFF10B981);
//       case 'Low Stock':
//         return const Color(0xFFF59E0B);
//       case 'Out of Stock':
//         return const Color(0xFFEF4444);
//       default:
//         return const Color(0xFF94A3B8);
//     }
//   }

//   int get totalProducts {
//     if (productBloc.state is! ProductLoaded) return 0;
//     return (productBloc.state as ProductLoaded).products.length;
//   }

//   int get lowStockCount {
//     if (productBloc.state is! ProductLoaded) return 0;
//     return (productBloc.state as ProductLoaded).products
//         .where((p) => p.stock > 0 && p.stock <= 10)
//         .length;
//   }

//   int get outOfStockCount {
//     if (productBloc.state is! ProductLoaded) return 0;
//     return (productBloc.state as ProductLoaded).products
//         .where((p) => p.stock == 0)
//         .length;
//   }

//   int get totalCategories {
//     if (productBloc.state is! ProductLoaded) return 0;
//     return (productBloc.state as ProductLoaded).products
//         .map((p) => p.category)
//         .toSet()
//         .length;
//   }

//   void _showProductDetails(ProductModel product) {
//     setState(() {
//       _selectedProduct = product;
//       _currentView = _CurrentView.productDetails;
//     });
//   }

//   void _showEditProduct(ProductModel product) {
//     setState(() {
//       _selectedProduct = product;
//       _currentView = _CurrentView.editProduct;
//     });
//   }

//   void _showAddProduct() {
//     setState(() {
//       _currentView = _CurrentView.addProduct;
//     });
//   }

//   void _showProductList() {
//     setState(() {
//       _currentView = _CurrentView.productList;
//       _selectedProduct = null;
//     });
//     productBloc.add(FetchSellerProductsEvent());
//   }

//   void _deleteProduct(ProductModel product) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Delete Product'),
//             content: Text(
//               'Are you sure you want to delete "${product.productName}"?',
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('${product.productName} has been deleted'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   productBloc.add(FetchSellerProductsEvent());
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 child: const Text('Delete'),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: Column(
//         children: [
//           const CommonAppBar(
//             title: 'Products',
//             subtitle: 'Manage your product inventory',
//           ),
//           Expanded(
//             child: BlocProvider.value(
//               value: productBloc,
//               child: BlocBuilder<ProductBloc, ProductState>(
//                 builder: (context, state) {
//                   if (state is ProductLoading &&
//                       _currentView == _CurrentView.productList) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is ProductError &&
//                       _currentView == _CurrentView.productList) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.error_outline,
//                             size: 64,
//                             color: Colors.red.shade300,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Error loading products',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             state.message,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey.shade500,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed:
//                                 () =>
//                                     productBloc.add(FetchSellerProductsEvent()),
//                             child: const Text('Retry'),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else if (state is ProductLoaded ||
//                       _currentView != _CurrentView.productList) {
//                     return _buildCurrentView();
//                   }
//                   return const SizedBox();
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCurrentView() {
//     switch (_currentView) {
//       case _CurrentView.productList:
//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         _buildFilterButton('All', 'All'),
//                         _buildFilterButton('Active', 'Active'),
//                         _buildFilterButton('Draft', 'Draft'),
//                         _buildFilterButton('Out of Stock', 'Out of Stock'),
//                         _buildFilterButton('Low Stock', 'Low Stock'),
//                       ],
//                     ),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ElevatedButton(
//                           onPressed:
//                               () => ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text('Export feature coming soon'),
//                                 ),
//                               ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFF3E8FF),
//                             foregroundColor: Colors.deepPurple,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               side: const BorderSide(
//                                 color: Colors.deepPurple,
//                                 width: 0.8,
//                               ),
//                             ),
//                           ),
//                           child: const Text("Export"),
//                         ),
//                         const SizedBox(width: 12),
//                         ElevatedButton.icon(
//                           onPressed: _showAddProduct,
//                           icon: const Icon(Icons.add, size: 20),
//                           label: const Text('Add Product'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF7C3AED),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 14,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 _buildSearchAndFilters(),
//                 const SizedBox(height: 24),
//                 _buildProductList(_filteredProducts),
//               ],
//             ),
//           ),
//         );
//       case _CurrentView.productDetails:
//         return _buildProductDetailsView();
//       case _CurrentView.addProduct:
//         return _buildAddProductView();
//       case _CurrentView.editProduct:
//         return _buildEditProductView();
//     }
//   }

//   Widget _buildFilterButton(String label, String filterValue) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 6),
//       child: TextButton(
//         onPressed: () => setState(() => _selectedFilter = filterValue),
//         style: TextButton.styleFrom(
//           backgroundColor:
//               _selectedFilter == filterValue
//                   ? const Color(0xFF7C3AED).withOpacity(0.1)
//                   : Colors.transparent,
//           foregroundColor:
//               _selectedFilter == filterValue
//                   ? const Color(0xFF7C3AED)
//                   : const Color(0xFF64748B),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: Text(label),
//       ),
//     );
//   }

//   Widget _buildSearchAndFilters() {
//     List<String> categoryList = _categories.toList();

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF8FAFC),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: TextField(
//                 onChanged: (value) => setState(() => _searchQuery = value),
//                 decoration: InputDecoration(
//                   hintText: 'Search products...',
//                   prefixIcon: const Icon(
//                     Icons.search,
//                     color: Color(0xFF94A3B8),
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade200),
//             ),
//             child: DropdownButton<String>(
//               value: _selectedCategory,
//               borderRadius: BorderRadius.circular(8),
//               underline: const SizedBox(),
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
//               style: const TextStyle(color: Colors.black, fontSize: 14),
//               items:
//                   categoryList
//                       .map(
//                         (String category) => DropdownMenuItem<String>(
//                           value: category,
//                           child: Text(category),
//                         ),
//                       )
//                       .toList(),
//               onChanged:
//                   (String? newValue) =>
//                       setState(() => _selectedCategory = newValue!),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade200),
//             ),
//             child: DropdownButton<String>(
//               value: _selectedSortBy,
//               borderRadius: BorderRadius.circular(8),
//               underline: const SizedBox(),
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               icon: const Icon(Icons.sort, color: Colors.black, size: 20),
//               style: const TextStyle(color: Colors.black, fontSize: 14),
//               items:
//                   _sortOptions
//                       .map(
//                         (String option) => DropdownMenuItem<String>(
//                           value: option,
//                           child: Text(option),
//                         ),
//                       )
//                       .toList(),
//               onChanged:
//                   (String? newValue) =>
//                       setState(() => _selectedSortBy = newValue!),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductList(List<ProductModel> products) {
//     if (products.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(60),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
//             const SizedBox(height: 16),
//             Text(
//               'No products found',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Try adjusting your search or add a new product',
//               style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//             ),
//           ],
//         ),
//       );
//     }

//     final screenSize = MediaQuery.of(context).size;
//     final isSmallScreen = screenSize.width < 800;
//     final availableWidth = screenSize.width - 48;
//     final columnFlex = [35, 9, 9, 9, 9, 10];
//     final columnWidths =
//         columnFlex.map((flex) => (availableWidth * flex / 100)).toList();
//     final rowHeight = 80.0;
//     final headerHeight = 80.0;
//     final tableHeight = (products.length * rowHeight) + headerHeight;

//     final columns = [
//       TableColumn(width: columnWidths[0], minResizeWidth: 180),
//       TableColumn(width: columnWidths[1], minResizeWidth: 80),
//       TableColumn(width: columnWidths[2], minResizeWidth: 70),
//       TableColumn(width: columnWidths[3], minResizeWidth: 110),
//       TableColumn(width: columnWidths[4], minResizeWidth: 80),
//       TableColumn(width: columnWidths[5], minResizeWidth: 100),
//     ];

//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: SizedBox(
//           height: tableHeight,
//           child: TableView.builder(
//             columns: columns,
//             rowCount: products.length,
//             rowHeight: rowHeight,
//             style: TableViewStyle(
//               dividers: TableViewDividersStyle(
//                 horizontal: TableViewHorizontalDividersStyle(
//                   header: TableViewHorizontalDividerStyle(
//                     color: Colors.grey.shade300,
//                     thickness: 0.5,
//                   ),
//                   footer: TableViewHorizontalDividerStyle(
//                     color: Colors.grey.shade300,
//                     thickness: 0.5,
//                   ),
//                 ),
//               ),
//             ),
//             rowBuilder: (context, row, TableRowContentBuilder contentBuilder) {
//               final product = products[row];
//               final status = _getProductStatus(product);
//               final statusColor = _getStatusColor(status);

//               return contentBuilder(context, (context, column) {
//                 switch (column) {
//                   case 0:
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: isSmallScreen ? 40 : 50,
//                             height: isSmallScreen ? 40 : 50,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF8FAFC),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.network(
//                                 product.mainBannerImage,
//                                 fit: BoxFit.cover,
//                                 errorBuilder:
//                                     (context, error, stackTrace) => Container(
//                                       color: const Color(0xFFF8FAFC),
//                                       child: Icon(
//                                         Icons.broken_image,
//                                         color: Colors.grey,
//                                         size: isSmallScreen ? 20 : 30,
//                                       ),
//                                     ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   product.productName,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: isSmallScreen ? 12 : 14,
//                                     color: const Color(0xFF1E293B),
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 2,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'ID: ${product.id}',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 9 : 11,
//                                     color: Colors.grey.shade500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   case 1:
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                       child: Text(
//                         product.category,
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 11 : 12,
//                           color: const Color(0xFF64748B),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     );
//                   case 2:
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                       child: Text(
//                         product.isActive ? "Active" : "Inactive",
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 11 : 12,
//                           color: product.isActive ? Colors.green : Colors.grey,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     );
//                   case 3:
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${product.stock} units',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: isSmallScreen ? 11 : 12,
//                               color:
//                                   product.stock == 0
//                                       ? Colors.red
//                                       : const Color(0xFF64748B),
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: isSmallScreen ? 6 : 10,
//                               vertical: isSmallScreen ? 4 : 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: statusColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               status,
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 10 : 12,
//                                 color: statusColor,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   case 4:
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '₹${_formatPrice(product.discountPrice)}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: isSmallScreen ? 12 : 14,
//                               color: const Color(0xFF1E293B),
//                             ),
//                           ),
//                           if (product.price > product.discountPrice)
//                             Text(
//                               '₹${_formatPrice(product.price)}',
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 9 : 11,
//                                 decoration: TextDecoration.lineThrough,
//                                 color: Colors.grey.shade500,
//                               ),
//                             ),
//                         ],
//                       ),
//                     );
//                   case 5:
//                     return Row(
//                       children: [
//                         IconButton(
//                           onPressed: () => _showProductDetails(product),
//                           tooltip: 'View Details',
//                           iconSize: isSmallScreen ? 18 : 20,
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                           icon: const HugeIcon(
//                             icon: HugeIcons.strokeRoundedView,
//                             color: Color(0xFF64748B),
//                             size: 20.0,
//                           ),
//                         ),
//                         SizedBox(width: isSmallScreen ? 4 : 12),
//                         IconButton(
//                           onPressed: () => _showEditProduct(product),
//                           tooltip: 'Edit Product',
//                           iconSize: isSmallScreen ? 18 : 20,
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                           icon: const HugeIcon(
//                             icon: HugeIcons.strokeRoundedEdit02,
//                             color: Color(0xFF7C3AED),
//                             size: 20.0,
//                           ),
//                         ),
//                         SizedBox(width: isSmallScreen ? 4 : 12),
//                         IconButton(
//                           onPressed: () => _deleteProduct(product),
//                           tooltip: 'Delete Product',
//                           iconSize: isSmallScreen ? 18 : 20,
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                           icon: const HugeIcon(
//                             icon: HugeIcons.strokeRoundedDelete02,
//                             color: Color(0xFF64748B),
//                             size: 20.0,
//                           ),
//                         ),
//                       ],
//                     );
//                   default:
//                     return const SizedBox();
//                 }
//               });
//             },
//             headerBuilder: (context, contentBuilder) {
//               final headers = [
//                 'Product',
//                 'Category',
//                 'Status',
//                 'Inventory',
//                 'Price',
//                 'Actions',
//               ];
//               return contentBuilder(context, (context, column) {
//                 return Container(
//                   width: columnWidths[column],
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFF8FAFC),
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey, width: 0.5),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     child: Text(
//                       headers[column],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                         color: Color(0xFF64748B),
//                       ),
//                     ),
//                   ),
//                 );
//               });
//             },
//             headerHeight: headerHeight,
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatPrice(double price) {
//     return price
//         .toStringAsFixed(0)
//         .replaceAllMapped(
//           RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//           (Match m) => '${m[1]},',
//         );
//   }

//   Widget _buildProductDetailsView() {
//     if (_selectedProduct == null) return const SizedBox();
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: _showProductList,
//                     icon: const Icon(Icons.arrow_back),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Back to Products',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildProductDetails(_selectedProduct!),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddProductView() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: _showProductList,
//                     icon: const Icon(Icons.arrow_back),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Back to Products',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _AddProductFormWidget(onSuccess: _showProductList),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEditProductView() {
//     if (_selectedProduct == null) return const SizedBox();
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: _showProductList,
//                     icon: const Icon(Icons.arrow_back),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Back to Products',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _EditProductFormWidget(
//               product: _selectedProduct!,
//               onSuccess: _showProductList,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductDetails(ProductModel product) {
//     final status = _getProductStatus(product);
//     final statusColor = _getStatusColor(status);
//     final screenSize = MediaQuery.of(context).size;
//     final isSmallScreen = screenSize.width < 800;
//     final isMediumScreen = screenSize.width >= 800 && screenSize.width < 1200;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child:
//               isSmallScreen
//                   ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 150,
//                           height: 150,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF8FAFC),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               product.mainBannerImage,
//                               fit: BoxFit.cover,
//                               errorBuilder:
//                                   (context, error, stackTrace) => Container(
//                                     color: const Color(0xFFF8FAFC),
//                                     child: const Icon(
//                                       Icons.broken_image,
//                                       color: Colors.grey,
//                                       size: 40,
//                                     ),
//                                   ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 product.productName,
//                                 style: TextStyle(
//                                   fontSize: isSmallScreen ? 20 : 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: const Color(0xFF1E293B),
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 6,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: statusColor.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   product.isActive == true
//                                       ? "Active"
//                                       : "Inactive",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: statusColor,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: statusColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               status,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: statusColor,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Wrap(
//                             spacing: 16,
//                             runSpacing: 8,
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Icon(
//                                     Icons.category_outlined,
//                                     size: 16,
//                                     color: Color(0xFF7C3AED),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     product.category,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Color(0xFF64748B),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Icon(
//                                     Icons.subdirectory_arrow_right,
//                                     size: 16,
//                                     color: Color(0xFF7C3AED),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     product.subCategory,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Color(0xFF64748B),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//                   : Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Container(
//                       //   width: isMediumScreen ? 100 : 120,
//                       //   height: isMediumScreen ? 100 : 120,
//                       //   decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
//                       //   child: ClipRRect(
//                       //     borderRadius: BorderRadius.circular(12),
//                       //     child: Image.network(product.mainBannerImage, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFF8FAFC), child: const Icon(Icons.broken_image, color: Colors.grey, size: 40))),
//                       //   ),
//                       // ),
//                       // const SizedBox(width: 24),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,

//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.min,

//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                             children: [
//                               Expanded(
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       product.productName,
//                                       style: TextStyle(
//                                         fontSize: isSmallScreen ? 20 : 24,
//                                         fontWeight: FontWeight.bold,
//                                         color: const Color(0xFF1E293B),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 6,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: statusColor.withOpacity(0.1),
//                                         borderRadius: BorderRadius.circular(6),
//                                       ),
//                                       child: Text(
//                                         product.isActive == true
//                                             ? "Active"
//                                             : "Inactive",
//                                         style: TextStyle(
//                                           fontSize: 13,
//                                           color: statusColor,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,

//                                 children: [
//                                   ElevatedButton.icon(
//                                     onPressed:
//                                         () => ScaffoldMessenger.of(
//                                           context,
//                                         ).showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                               'Export feature coming soon',
//                                             ),
//                                           ),
//                                         ),
//                                     icon: const Icon(Icons.share, size: 18),
//                                     label: const Text("Share"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.white,
//                                       foregroundColor: Colors.black,
//                                       elevation: 0,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         side: BorderSide(
//                                           color: Colors.grey.withOpacity(0.5),
//                                           width: 0.8,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 12),
//                                   ElevatedButton.icon(
//                                     onPressed:
//                                         () => ScaffoldMessenger.of(
//                                           context,
//                                         ).showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                               'Export feature coming soon',
//                                             ),
//                                           ),
//                                         ),
//                                     icon: const Icon(Icons.delete, size: 18),
//                                     label: const Text("Delete"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.white,
//                                       foregroundColor: Colors.black,
//                                       elevation: 0,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         side: BorderSide(
//                                           color: Colors.orange.withOpacity(0.5),
//                                           width: 0.8,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 12),

//                                   ElevatedButton.icon(
//                                     onPressed:
//                                         () => ScaffoldMessenger.of(
//                                           context,
//                                         ).showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                               'Export feature coming soon',
//                                             ),
//                                           ),
//                                         ),
//                                     icon: const Icon(Icons.edit, size: 18),
//                                     label: const Text("Edit"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.deepPurple,
//                                       foregroundColor: Colors.white,
//                                       elevation: 0,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         side: BorderSide(
//                                           color: Colors.white.withOpacity(0.5),
//                                           width: 0.8,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           // const SizedBox(height: 8),
//                           // Container(
//                           //   padding: const EdgeInsets.symmetric(
//                           //     horizontal: 12,
//                           //     vertical: 6,
//                           //   ),
//                           //   decoration: BoxDecoration(
//                           //     color: statusColor.withOpacity(0.1),
//                           //     borderRadius: BorderRadius.circular(20),
//                           //   ),
//                           //   child: Text(
//                           //     status,
//                           //     style: TextStyle(
//                           //       fontSize: 13,
//                           //       color: statusColor,
//                           //       fontWeight: FontWeight.w600,
//                           //     ),
//                           //   ),
//                           // ),
//                           // const SizedBox(height: 16),
//                           // Wrap(
//                           //   spacing: 16,
//                           //   runSpacing: 8,
//                           //   children: [
//                           //     Row(
//                           //       mainAxisSize: MainAxisSize.min,
//                           //       children: [
//                           //         const Icon(
//                           //           Icons.category_outlined,
//                           //           size: 16,
//                           //           color: Color(0xFF7C3AED),
//                           //         ),
//                           //         const SizedBox(width: 4),
//                           //         Text(
//                           //           product.category,
//                           //           style: const TextStyle(
//                           //             fontSize: 14,
//                           //             color: Color(0xFF64748B),
//                           //           ),
//                           //         ),
//                           //       ],
//                           //     ),
//                           //     Row(
//                           //       mainAxisSize: MainAxisSize.min,
//                           //       children: [
//                           //         const Icon(
//                           //           Icons.subdirectory_arrow_right,
//                           //           size: 16,
//                           //           color: Color(0xFF7C3AED),
//                           //         ),
//                           //         const SizedBox(width: 4),
//                           //         Text(
//                           //           product.subCategory,
//                           //           style: const TextStyle(
//                           //             fontSize: 14,
//                           //             color: Color(0xFF64748B),
//                           //           ),
//                           //         ),
//                           //       ],
//                           //     ),
//                           //   ],
//                           // ),
//                         ],
//                       ),
//                     ],
//                   ),
//         ),
//         const SizedBox(height: 24),
//         Container(
//           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Pricing & Inventory',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               isSmallScreen
//                   ? Column(
//                     children: [
//                       _buildInfoCard(
//                         'Price',
//                         '₹${_formatPrice(product.price)}',
//                         Icons.currency_rupee,
//                       ),
//                       const SizedBox(height: 12),
//                       _buildInfoCard(
//                         'Discounted Price',
//                         '₹${_formatPrice(product.discountPrice)}',
//                         Icons.local_offer_outlined,
//                       ),
//                       const SizedBox(height: 12),
//                       _buildInfoCard(
//                         'Stock',
//                         '${product.stock} units',
//                         Icons.inventory_2_outlined,
//                       ),
//                     ],
//                   )
//                   : Row(
//                     children: [
//                       Expanded(
//                         child: _buildInfoCard(
//                           'Price',
//                           '₹${_formatPrice(product.price)}',
//                           Icons.currency_rupee,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: _buildInfoCard(
//                           'Discounted Price',
//                           '₹${_formatPrice(product.discountPrice)}',
//                           Icons.local_offer_outlined,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: _buildInfoCard(
//                           'Stock',
//                           '${product.stock} units',
//                           Icons.inventory_2_outlined,
//                         ),
//                       ),
//                     ],
//                   ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 24),
//         Container(
//           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Description',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Short Description',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF8FAFC),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   product.shortDescription.isEmpty
//                       ? 'No description provided'
//                       : product.shortDescription,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF475569),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Detailed Description',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF8FAFC),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   product.detailedDescription.isEmpty
//                       ? 'No description provided'
//                       : product.detailedDescription,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF475569),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 24),
//         if (product.tags.isNotEmpty)
//           Container(
//             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.04),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Tags',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1E293B),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children:
//                       product.tags
//                           .map(
//                             (tag) => Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF7C3AED).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 tag,
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xFF7C3AED),
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                 ),
//               ],
//             ),
//           ),
//         const SizedBox(height: 24),
//         if (product.multipleImages.isNotEmpty)
//           Container(
//             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.04),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Additional Images',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1E293B),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   height: 120,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: product.multipleImages.length,
//                     itemBuilder:
//                         (context, index) => Container(
//                           width: 120,
//                           margin: const EdgeInsets.only(right: 12),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade200),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               product.multipleImages[index],
//                               fit: BoxFit.cover,
//                               width: 120,
//                               height: 120,
//                               errorBuilder:
//                                   (context, error, stackTrace) => Container(
//                                     color: const Color(0xFFF8FAFC),
//                                     child: const Icon(
//                                       Icons.broken_image,
//                                       color: Colors.grey,
//                                       size: 40,
//                                     ),
//                                   ),
//                             ),
//                           ),
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         const SizedBox(height: 24),
//         if (product.specifications.isNotEmpty)
//           Container(
//             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.04),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Product Specifications',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1E293B),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: product.specifications.length,
//                   separatorBuilder:
//                       (context, index) => const Divider(height: 1),
//                   itemBuilder: (context, index) {
//                     final entry = product.specifications.entries.elementAt(
//                       index,
//                     );
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       child:
//                           isSmallScreen
//                               ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     entry.key,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 14,
//                                       color: Color(0xFF1E293B),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     entry.value.toString(),
//                                     style: const TextStyle(
//                                       fontSize: 13,
//                                       color: Color(0xFF64748B),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                               : Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     width: 160,
//                                     child: Text(
//                                       entry.key,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 14,
//                                         color: Color(0xFF1E293B),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Text(
//                                       entry.value.toString(),
//                                       style: const TextStyle(
//                                         fontSize: 13,
//                                         color: Color(0xFF64748B),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         const SizedBox(height: 24),
//         Container(
//           padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Additional Information',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               _buildAdditionalInfoRow(
//                 'Product ID',
//                 product.id,
//                 Icons.qr_code,
//                 isSmallScreen,
//               ),
//               const SizedBox(height: 12),
//               _buildAdditionalInfoRow(
//                 'Rating',
//                 '${product.rating} ⭐ (${product.totalReviews} reviews)',
//                 Icons.star_outline,
//                 isSmallScreen,
//               ),
//               const SizedBox(height: 12),
//               _buildAdditionalInfoRow(
//                 'Created Date',
//                 _formatDate(product.createdAt),
//                 Icons.calendar_today_outlined,
//                 isSmallScreen,
//               ),
//               const SizedBox(height: 12),
//               _buildAdditionalInfoRow(
//                 'Status',
//                 product.isActive ? 'Active' : 'Inactive',
//                 Icons.toggle_on_outlined,
//                 isSmallScreen,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoCard(String title, String value, IconData icon) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 20, color: const Color(0xFF7C3AED)),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdditionalInfoRow(
//     String label,
//     String value,
//     IconData icon,
//     bool isSmallScreen,
//   ) {
//     if (isSmallScreen) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 18, color: const Color(0xFF7C3AED)),
//               const SizedBox(width: 12),
//               Text(
//                 label,
//                 style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.only(left: 30),
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF1E293B),
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: const Color(0xFF7C3AED)),
//         const SizedBox(width: 12),
//         SizedBox(
//           width: 120,
//           child: Text(
//             label,
//             style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1E293B),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       return dateString;
//     }
//   }
// }

// // Add Product Form Widget with Specifications
// class _AddProductFormWidget extends StatefulWidget {
//   final VoidCallback onSuccess;
//   const _AddProductFormWidget({required this.onSuccess});

//   @override
//   State<_AddProductFormWidget> createState() => _AddProductFormWidgetState();
// }

// class _AddProductFormWidgetState extends State<_AddProductFormWidget> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _productNameController;
//   late TextEditingController _priceController;
//   late TextEditingController _discountPriceController;
//   late TextEditingController _stockController;
//   late TextEditingController _categoryController;
//   late TextEditingController _subCategoryController;
//   late TextEditingController _shortDescriptionController;
//   late TextEditingController _detailedDescriptionController;
//   late TextEditingController _tagsController;

//   List<MapEntry<String, String>> _specifications = [];

//   List<int>? _mainBannerImageBytes;
//   String? _mainBannerImageName;
//   String? _mainBannerImageUrl;

//   List<List<int>> _multipleImagesBytes = [];
//   List<String> _multipleImageNames = [];
//   List<String> _multipleImageUrls = [];

//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _productNameController = TextEditingController();
//     _priceController = TextEditingController();
//     _discountPriceController = TextEditingController();
//     _stockController = TextEditingController();
//     _categoryController = TextEditingController();
//     _subCategoryController = TextEditingController();
//     _shortDescriptionController = TextEditingController();
//     _detailedDescriptionController = TextEditingController();
//     _tagsController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     if (_mainBannerImageUrl != null)
//       html.Url.revokeObjectUrl(_mainBannerImageUrl!);
//     for (var url in _multipleImageUrls) html.Url.revokeObjectUrl(url);
//     _productNameController.dispose();
//     _priceController.dispose();
//     _discountPriceController.dispose();
//     _stockController.dispose();
//     _categoryController.dispose();
//     _subCategoryController.dispose();
//     _shortDescriptionController.dispose();
//     _detailedDescriptionController.dispose();
//     _tagsController.dispose();
//     super.dispose();
//   }

//   void _addSpecification() =>
//       setState(() => _specifications.add(const MapEntry('', '')));

//   void _updateSpecification(int index, String key, String value) =>
//       setState(() => _specifications[index] = MapEntry(key, value));

//   void _removeSpecification(int index) =>
//       setState(() => _specifications.removeAt(index));

//   Future<void> _pickMainBannerImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final bytes = await pickedFile.readAsBytes();
//       final blob = html.Blob([bytes]);
//       final url = html.Url.createObjectUrlFromBlob(blob);
//       setState(() {
//         _mainBannerImageBytes = bytes;
//         _mainBannerImageName = pickedFile.name;
//         _mainBannerImageUrl = url;
//       });
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     final pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles.isNotEmpty) {
//       final List<String> urls = [];
//       final List<List<int>> bytesList = [];
//       final List<String> names = [];
//       for (var file in pickedFiles) {
//         final bytes = await file.readAsBytes();
//         final blob = html.Blob([bytes]);
//         final url = html.Url.createObjectUrlFromBlob(blob);
//         urls.add(url);
//         bytesList.add(bytes);
//         names.add(file.name);
//       }
//       setState(() {
//         _multipleImageUrls.addAll(urls);
//         _multipleImagesBytes.addAll(bytesList);
//         _multipleImageNames.addAll(names);
//       });
//     }
//   }

//   void _removeMultipleImage(int index) {
//     html.Url.revokeObjectUrl(_multipleImageUrls[index]);
//     setState(() {
//       _multipleImageUrls.removeAt(index);
//       _multipleImagesBytes.removeAt(index);
//       _multipleImageNames.removeAt(index);
//     });
//   }

//   Future<void> _submitProduct() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_mainBannerImageBytes == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a main banner image')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final tags =
//           _tagsController.text
//               .split(',')
//               .map((e) => e.trim())
//               .where((e) => e.isNotEmpty)
//               .toList();

//       final Map<String, dynamic> specifications = {};
//       for (var spec in _specifications) {
//         if (spec.key.trim().isNotEmpty && spec.value.trim().isNotEmpty) {
//           specifications[spec.key.trim()] = spec.value.trim();
//         }
//       }

//       final body = {
//         'productName': _productNameController.text,
//         'price': double.parse(_priceController.text),
//         'discountPrice': double.parse(_discountPriceController.text),
//         'stock': int.parse(_stockController.text),
//         'stockAvailable': int.parse(_stockController.text) > 0,
//         'category': _categoryController.text,
//         'subCategory': _subCategoryController.text,
//         'tags': tags,
//         'shortDescription': _shortDescriptionController.text,
//         'detailedDescription': _detailedDescriptionController.text,
//         'specifications': specifications,
//       };

//       final productService = ProductService();
//       await productService.addProductWithImageBytes(
//         body: body,
//         mainBannerImageBytes: _mainBannerImageBytes!,
//         mainBannerImageName: _mainBannerImageName!,
//         multipleImagesBytes: _multipleImagesBytes,
//         multipleImagesNames: _multipleImageNames,
//       );

//       if (_mainBannerImageUrl != null)
//         html.Url.revokeObjectUrl(_mainBannerImageUrl!);
//       for (var url in _multipleImageUrls) html.Url.revokeObjectUrl(url);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Product added successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onSuccess();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isSmallScreen = screenSize.width < 800;

//     return Container(
//       padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child:
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Main Banner Image *',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1E293B),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       GestureDetector(
//                         onTap: _pickMainBannerImage,
//                         child: Container(
//                           height: 150,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF8FAFC),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child:
//                               _mainBannerImageUrl != null
//                                   ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.network(
//                                       _mainBannerImageUrl!,
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                     ),
//                                   )
//                                   : Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.cloud_upload,
//                                         size: 40,
//                                         color: Colors.grey.shade400,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'Tap to upload main banner image',
//                                         style: TextStyle(
//                                           color: Colors.grey.shade600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Additional Images',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1E293B),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       OutlinedButton.icon(
//                         onPressed: _pickMultipleImages,
//                         icon: const Icon(Icons.add_photo_alternate),
//                         label: const Text('Add Images'),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       if (_multipleImageUrls.isNotEmpty)
//                         SizedBox(
//                           height: 100,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: _multipleImageUrls.length,
//                             itemBuilder:
//                                 (context, index) => Container(
//                                   width: 100,
//                                   margin: const EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                       color: Colors.grey.shade300,
//                                     ),
//                                   ),
//                                   child: Stack(
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           _multipleImageUrls[index],
//                                           fit: BoxFit.cover,
//                                           width: 100,
//                                           height: 100,
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 4,
//                                         right: 4,
//                                         child: GestureDetector(
//                                           onTap:
//                                               () => _removeMultipleImage(index),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.black.withOpacity(
//                                                 0.5,
//                                               ),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: const Icon(
//                                               Icons.close,
//                                               size: 16,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                           ),
//                         ),
//                       const SizedBox(height: 24),
//                       TextFormField(
//                         controller: _productNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Product Name *',
//                           prefixIcon: Icon(Icons.shopping_bag_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         validator:
//                             (value) =>
//                                 value?.isEmpty ?? true
//                                     ? 'Please enter product name'
//                                     : null,
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _priceController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Original Price (₹) *',
//                                 prefixIcon: Icon(Icons.currency_rupee),
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                               validator:
//                                   (value) =>
//                                       value?.isEmpty ?? true
//                                           ? 'Please enter price'
//                                           : null,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _discountPriceController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Discounted Price (₹) *',
//                                 prefixIcon: Icon(Icons.local_offer_outlined),
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                               validator:
//                                   (value) =>
//                                       value?.isEmpty ?? true
//                                           ? 'Please enter discounted price'
//                                           : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _stockController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Stock Quantity *',
//                                 prefixIcon: Icon(Icons.inventory_2_outlined),
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                               validator:
//                                   (value) =>
//                                       value?.isEmpty ?? true
//                                           ? 'Please enter stock quantity'
//                                           : null,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _categoryController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Category *',
//                                 prefixIcon: Icon(Icons.category_outlined),
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator:
//                                   (value) =>
//                                       value?.isEmpty ?? true
//                                           ? 'Please enter category'
//                                           : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _subCategoryController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Sub Category',
//                                 prefixIcon: Icon(
//                                   Icons.subdirectory_arrow_right,
//                                 ),
//                                 border: OutlineInputBorder(),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _tagsController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Tags (comma separated)',
//                                 prefixIcon: Icon(Icons.local_offer_outlined),
//                                 border: OutlineInputBorder(),
//                                 helperText: 'e.g., popular, new, sale',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _shortDescriptionController,
//                         decoration: const InputDecoration(
//                           labelText: 'Short Description',
//                           prefixIcon: Icon(Icons.description_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 2,
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _detailedDescriptionController,
//                         decoration: const InputDecoration(
//                           labelText: 'Detailed Description',
//                           prefixIcon: Icon(Icons.article_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 4,
//                       ),
//                       const SizedBox(height: 24),
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF8FAFC),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Product Specifications',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF1E293B),
//                                   ),
//                                 ),
//                                 TextButton.icon(
//                                   onPressed: _addSpecification,
//                                   icon: const Icon(Icons.add, size: 18),
//                                   label: const Text('Add Specification'),
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: const Color(0xFF7C3AED),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             if (_specifications.isEmpty)
//                               Container(
//                                 padding: const EdgeInsets.all(32),
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   children: [
//                                     Icon(
//                                       Icons.settings_outlined,
//                                       size: 48,
//                                       color: Colors.grey.shade400,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'No specifications added',
//                                       style: TextStyle(
//                                         color: Colors.grey.shade500,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       'Click "Add Specification" to add product features',
//                                       style: TextStyle(
//                                         color: Colors.grey.shade400,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             else
//                               ListView.separated(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: _specifications.length,
//                                 separatorBuilder:
//                                     (context, index) =>
//                                         const SizedBox(height: 12),
//                                 itemBuilder: (context, index) {
//                                   final spec = _specifications[index];
//                                   return Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextFormField(
//                                           initialValue: spec.key,
//                                           decoration: const InputDecoration(
//                                             labelText: 'Specification Name',
//                                             hintText:
//                                                 'e.g., Brand, Color, Size',
//                                             border: OutlineInputBorder(),
//                                             contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                   horizontal: 12,
//                                                   vertical: 12,
//                                                 ),
//                                           ),
//                                           onChanged:
//                                               (value) => _updateSpecification(
//                                                 index,
//                                                 value,
//                                                 spec.value,
//                                               ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: TextFormField(
//                                           initialValue: spec.value,
//                                           decoration: const InputDecoration(
//                                             labelText: 'Specification Value',
//                                             hintText: 'e.g., Nike, Black, XL',
//                                             border: OutlineInputBorder(),
//                                             contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                   horizontal: 12,
//                                                   vertical: 12,
//                                                 ),
//                                           ),
//                                           onChanged:
//                                               (value) => _updateSpecification(
//                                                 index,
//                                                 spec.key,
//                                                 value,
//                                               ),
//                                         ),
//                                       ),
//                                       IconButton(
//                                         onPressed:
//                                             () => _removeSpecification(index),
//                                         icon: const Icon(
//                                           Icons.delete_outline,
//                                           color: Colors.red,
//                                         ),
//                                         tooltip: 'Remove',
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: widget.onSuccess,
//                               style: OutlinedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text('Cancel'),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: _submitProduct,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF7C3AED),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text('Add Product'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//     );
//   }
// }

// // Edit Product Form Widget with Specifications
// class _EditProductFormWidget extends StatefulWidget {
//   final ProductModel product;
//   final VoidCallback onSuccess;
//   const _EditProductFormWidget({
//     required this.product,
//     required this.onSuccess,
//   });

//   @override
//   State<_EditProductFormWidget> createState() => _EditProductFormWidgetState();
// }

// class _EditProductFormWidgetState extends State<_EditProductFormWidget> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _productNameController;
//   late TextEditingController _priceController;
//   late TextEditingController _discountPriceController;
//   late TextEditingController _stockController;
//   late TextEditingController _categoryController;
//   late TextEditingController _subCategoryController;
//   late TextEditingController _shortDescriptionController;
//   late TextEditingController _detailedDescriptionController;
//   late TextEditingController _tagsController;

//   List<MapEntry<String, String>> _specifications = [];

//   File? _mainBannerImage;
//   List<File> _newMultipleImages = [];
//   List<String> _existingMultipleImages = [];

//   List<int>? _newMainBannerImageBytes;
//   String? _newMainBannerImageName;
//   List<List<int>> _newMultipleImagesBytes = [];
//   List<String> _newMultipleImagesNames = [];

//   final ImagePicker _picker = ImagePicker();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _productNameController = TextEditingController(
//       text: widget.product.productName,
//     );
//     _priceController = TextEditingController(
//       text: widget.product.price.toString(),
//     );
//     _discountPriceController = TextEditingController(
//       text: widget.product.discountPrice.toString(),
//     );
//     _stockController = TextEditingController(
//       text: widget.product.stock.toString(),
//     );
//     _categoryController = TextEditingController(text: widget.product.category);
//     _subCategoryController = TextEditingController(
//       text: widget.product.subCategory,
//     );
//     _shortDescriptionController = TextEditingController(
//       text: widget.product.shortDescription,
//     );
//     _detailedDescriptionController = TextEditingController(
//       text: widget.product.detailedDescription,
//     );
//     _tagsController = TextEditingController(
//       text: widget.product.tags.join(', '),
//     );
//     _specifications =
//         widget.product.specifications.entries
//             .map((entry) => MapEntry(entry.key, entry.value.toString()))
//             .toList();
//     _existingMultipleImages = List.from(widget.product.multipleImages);
//   }

//   @override
//   void dispose() {
//     _productNameController.dispose();
//     _priceController.dispose();
//     _discountPriceController.dispose();
//     _stockController.dispose();
//     _categoryController.dispose();
//     _subCategoryController.dispose();
//     _shortDescriptionController.dispose();
//     _detailedDescriptionController.dispose();
//     _tagsController.dispose();
//     super.dispose();
//   }

//   void _addSpecification() =>
//       setState(() => _specifications.add(const MapEntry('', '')));
//   void _updateSpecification(int index, String key, String value) =>
//       setState(() => _specifications[index] = MapEntry(key, value));
//   void _removeSpecification(int index) =>
//       setState(() => _specifications.removeAt(index));

//   Future<void> _pickMainBannerImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final bytes = await pickedFile.readAsBytes();
//       setState(() {
//         _newMainBannerImageBytes = bytes;
//         _newMainBannerImageName = pickedFile.name;
//         _mainBannerImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     final pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles.isNotEmpty) {
//       final List<List<int>> bytesList = [];
//       final List<String> names = [];
//       final List<File> files = [];
//       for (var file in pickedFiles) {
//         final bytes = await file.readAsBytes();
//         bytesList.add(bytes);
//         names.add(file.name);
//         files.add(File(file.path));
//       }
//       setState(() {
//         _newMultipleImagesBytes.addAll(bytesList);
//         _newMultipleImagesNames.addAll(names);
//         _newMultipleImages.addAll(files);
//       });
//     }
//   }

//   void _removeExistingImage(int index) =>
//       setState(() => _existingMultipleImages.removeAt(index));
//   void _removeNewImage(int index) =>
//       setState(() => _newMultipleImages.removeAt(index));

//   Future<void> _submitProduct() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     try {
//       final tags =
//           _tagsController.text
//               .split(',')
//               .map((e) => e.trim())
//               .where((e) => e.isNotEmpty)
//               .toList();
//       final Map<String, dynamic> specifications = {};
//       for (var spec in _specifications) {
//         if (spec.key.trim().isNotEmpty && spec.value.trim().isNotEmpty) {
//           specifications[spec.key.trim()] = spec.value.trim();
//         }
//       }

//       final body = {
//         'productId': widget.product.id,
//         'productName': _productNameController.text,
//         'price': double.parse(_priceController.text),
//         'discountPrice': double.parse(_discountPriceController.text),
//         'stock': int.parse(_stockController.text),
//         'stockAvailable': int.parse(_stockController.text) > 0,
//         'category': _categoryController.text,
//         'subCategory': _subCategoryController.text,
//         'tags': tags,
//         'shortDescription': _shortDescriptionController.text,
//         'detailedDescription': _detailedDescriptionController.text,
//         'specifications': specifications,
//       };

//       final productService = ProductService();

//       if (_newMainBannerImageBytes != null ||
//           _newMultipleImagesBytes.isNotEmpty) {
//         await productService.updateProductWithImageBytes(
//           body: body,
//           mainBannerImageBytes: _newMainBannerImageBytes,
//           mainBannerImageName: _newMainBannerImageName,
//           newMultipleImagesBytes:
//               _newMultipleImagesBytes.isNotEmpty
//                   ? _newMultipleImagesBytes
//                   : null,
//           newMultipleImagesNames:
//               _newMultipleImagesNames.isNotEmpty
//                   ? _newMultipleImagesNames
//                   : null,
//           existingMultipleImages: _existingMultipleImages,
//         );
//       } else {
//         await productService.updateProduct(body: body);
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Product updated successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onSuccess();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isSmallScreen = screenSize.width < 800;

//     return Container(
//       padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child:
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Main Banner Image',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1E293B),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       GestureDetector(
//                         onTap: _pickMainBannerImage,
//                         child: Container(
//                           height: 150,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF8FAFC),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child:
//                               _mainBannerImage != null
//                                   ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.file(
//                                       _mainBannerImage!,
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                     ),
//                                   )
//                                   : ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Image.network(
//                                       widget.product.mainBannerImage,
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                       errorBuilder:
//                                           (context, error, stackTrace) =>
//                                               Container(
//                                                 color: const Color(0xFFF8FAFC),
//                                                 child: const Icon(
//                                                   Icons.broken_image,
//                                                   color: Colors.grey,
//                                                   size: 40,
//                                                 ),
//                                               ),
//                                     ),
//                                   ),
//                         ),
//                       ),
//                       if (_mainBannerImage == null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text(
//                             'Tap to change image',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: const Color(0xFF7C3AED),
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Additional Images',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1E293B),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       OutlinedButton.icon(
//                         onPressed: _pickMultipleImages,
//                         icon: const Icon(Icons.add_photo_alternate),
//                         label: const Text('Add More Images'),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       if (_existingMultipleImages.isNotEmpty) ...[
//                         const Text(
//                           'Existing Images',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xFF64748B),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           height: 100,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: _existingMultipleImages.length,
//                             itemBuilder:
//                                 (context, index) => Container(
//                                   width: 100,
//                                   margin: const EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                       color: Colors.grey.shade300,
//                                     ),
//                                   ),
//                                   child: Stack(
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           _existingMultipleImages[index],
//                                           fit: BoxFit.cover,
//                                           width: 100,
//                                           height: 100,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   Container(
//                                                     color: const Color(
//                                                       0xFFF8FAFC,
//                                                     ),
//                                                     child: const Icon(
//                                                       Icons.broken_image,
//                                                       color: Colors.grey,
//                                                       size: 30,
//                                                     ),
//                                                   ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 4,
//                                         right: 4,
//                                         child: GestureDetector(
//                                           onTap:
//                                               () => _removeExistingImage(index),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.black.withOpacity(
//                                                 0.5,
//                                               ),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: const Icon(
//                                               Icons.close,
//                                               size: 16,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                       ],
//                       if (_newMultipleImages.isNotEmpty) ...[
//                         const Text(
//                           'New Images',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xFF64748B),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           height: 100,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: _newMultipleImages.length,
//                             itemBuilder:
//                                 (context, index) => Container(
//                                   width: 100,
//                                   margin: const EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                       color: Colors.grey.shade300,
//                                     ),
//                                   ),
//                                   child: Stack(
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.file(
//                                           _newMultipleImages[index],
//                                           fit: BoxFit.cover,
//                                           width: 100,
//                                           height: 100,
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 4,
//                                         right: 4,
//                                         child: GestureDetector(
//                                           onTap: () => _removeNewImage(index),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.black.withOpacity(
//                                                 0.5,
//                                               ),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: const Icon(
//                                               Icons.close,
//                                               size: 16,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                           ),
//                         ),
//                       ],
//                       const SizedBox(height: 24),
//                       TextFormField(
//                         controller: _productNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Product Name *',
//                           prefixIcon: Icon(Icons.shopping_bag_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         validator:
//                             (value) =>
//                                 value?.isEmpty ?? true
//                                     ? 'Please enter product name'
//                                     : null,
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _priceController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Original Price (₹) *',
//                                 prefixIcon: Icon(Icons.currency_rupee),
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                               validator:
//                                   (value) =>
//                                       value?.isEmpty ?? true
//                                           ? 'Please enter price'
//                                           : null,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _discountPriceController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Discounted Price (₹) *',
//                                 prefixIcon: Icon(Icons.local_offer_outlined),
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                               validator:
//                                   (value) =>
//                                       value?.isEmpty ?? true
//                                           ? 'Please enter discounted price'
//                                           : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _stockController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Stock Quantity *',
//                                 prefixIcon: Icon(Icons.inventory_2_outlined),
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                               validator:
//                                   (value) =>
//                                       value?.isEmpty ?? true
//                                           ? 'Please enter stock quantity'
//                                           : null,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _categoryController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Category *',
//                                 prefixIcon: Icon(Icons.category_outlined),
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator:
//                                   (value) =>
//                                       value?.isEmpty ?? true
//                                           ? 'Please enter category'
//                                           : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _subCategoryController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Sub Category',
//                                 prefixIcon: Icon(
//                                   Icons.subdirectory_arrow_right,
//                                 ),
//                                 border: OutlineInputBorder(),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _tagsController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Tags (comma separated)',
//                                 prefixIcon: Icon(Icons.local_offer_outlined),
//                                 border: OutlineInputBorder(),
//                                 helperText: 'e.g., popular, new, sale',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _shortDescriptionController,
//                         decoration: const InputDecoration(
//                           labelText: 'Short Description',
//                           prefixIcon: Icon(Icons.description_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 2,
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _detailedDescriptionController,
//                         decoration: const InputDecoration(
//                           labelText: 'Detailed Description',
//                           prefixIcon: Icon(Icons.article_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 4,
//                       ),
//                       const SizedBox(height: 24),
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF8FAFC),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   'Product Specifications',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF1E293B),
//                                   ),
//                                 ),
//                                 TextButton.icon(
//                                   onPressed: _addSpecification,
//                                   icon: const Icon(Icons.add, size: 18),
//                                   label: const Text('Add Specification'),
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: const Color(0xFF7C3AED),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             if (_specifications.isEmpty)
//                               Container(
//                                 padding: const EdgeInsets.all(32),
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   children: [
//                                     Icon(
//                                       Icons.settings_outlined,
//                                       size: 48,
//                                       color: Colors.grey.shade400,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'No specifications added',
//                                       style: TextStyle(
//                                         color: Colors.grey.shade500,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       'Click "Add Specification" to add product features',
//                                       style: TextStyle(
//                                         color: Colors.grey.shade400,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             else
//                               ListView.separated(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: _specifications.length,
//                                 separatorBuilder:
//                                     (context, index) =>
//                                         const SizedBox(height: 12),
//                                 itemBuilder: (context, index) {
//                                   final spec = _specifications[index];
//                                   return Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextFormField(
//                                           initialValue: spec.key,
//                                           decoration: const InputDecoration(
//                                             labelText: 'Specification Name',
//                                             hintText:
//                                                 'e.g., Brand, Color, Size',
//                                             border: OutlineInputBorder(),
//                                             contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                   horizontal: 12,
//                                                   vertical: 12,
//                                                 ),
//                                           ),
//                                           onChanged:
//                                               (value) => _updateSpecification(
//                                                 index,
//                                                 value,
//                                                 spec.value,
//                                               ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: TextFormField(
//                                           initialValue: spec.value,
//                                           decoration: const InputDecoration(
//                                             labelText: 'Specification Value',
//                                             hintText: 'e.g., Nike, Black, XL',
//                                             border: OutlineInputBorder(),
//                                             contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                   horizontal: 12,
//                                                   vertical: 12,
//                                                 ),
//                                           ),
//                                           onChanged:
//                                               (value) => _updateSpecification(
//                                                 index,
//                                                 spec.key,
//                                                 value,
//                                               ),
//                                         ),
//                                       ),
//                                       IconButton(
//                                         onPressed:
//                                             () => _removeSpecification(index),
//                                         icon: const Icon(
//                                           Icons.delete_outline,
//                                           color: Colors.red,
//                                         ),
//                                         tooltip: 'Remove',
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: widget.onSuccess,
//                               style: OutlinedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text('Cancel'),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: _submitProduct,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF7C3AED),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text('Save Changes'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//     );
//   }
// }

import 'package:app_frontend/features/seller/products/bloc/product_bloc.dart';
import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/web_dashboard/widgets/add_product_view.dart';
import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
import 'package:app_frontend/features/web_dashboard/widgets/edit_product_view.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_details_view.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:material_table_view/material_table_view.dart';
import 'package:material_table_view/table_view_typedefs.dart';

// ==================== ENUMS ====================
enum _CurrentView { productList, productDetails, addProduct, editProduct }

// ==================== MAIN PRODUCTS CONTENT ====================
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
  String _selectedFilter = 'All';
  String _selectedSortBy = 'Newest';

  _CurrentView _currentView = _CurrentView.productList;
  ProductModel? _selectedProduct;

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

  final List<String> _sortOptions = [
    'Newest',
    'Price: Low to High',
    'Price: High to Low',
    'Name: A to Z',
    'Name: Z to A',
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

    List<ProductModel> filtered =
        products.where((product) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              product.productName.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              product.category.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );

          final matchesCategory =
              _selectedCategory == 'All' ||
              product.category == _selectedCategory;

          final status = _getProductStatus(product);
          final matchesStatus =
              _selectedStatus == 'All' || status == _selectedStatus;

          bool matchesFilter = true;
          switch (_selectedFilter) {
            case 'Active':
              matchesFilter = product.isActive == true;
              break;
            case 'Draft':
              matchesFilter = product.isActive == false;
              break;
            case 'Out of Stock':
              matchesFilter = product.stock == 0;
              break;
            case 'Low Stock':
              matchesFilter = product.stock > 0 && product.stock <= 10;
              break;
            case 'All':
            default:
              matchesFilter = true;
              break;
          }

          return matchesSearch &&
              matchesCategory &&
              matchesStatus &&
              matchesFilter;
        }).toList();

    filtered.sort((a, b) {
      switch (_selectedSortBy) {
        case 'Newest':
          return b.createdAt.compareTo(a.createdAt);
        case 'Price: Low to High':
          return a.discountPrice.compareTo(b.discountPrice);
        case 'Price: High to Low':
          return b.discountPrice.compareTo(a.discountPrice);
        case 'Name: A to Z':
          return a.productName.compareTo(b.productName);
        case 'Name: Z to A':
          return b.productName.compareTo(a.productName);
        default:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return filtered;
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

  void _showProductDetails(ProductModel product) {
    setState(() {
      _selectedProduct = product;
      _currentView = _CurrentView.productDetails;
    });
  }

  void _showEditProduct(ProductModel product) {
    setState(() {
      _selectedProduct = product;
      _currentView = _CurrentView.editProduct;
    });
  }

  void _showAddProduct() {
    setState(() {
      _currentView = _CurrentView.addProduct;
    });
  }

  void _showProductList() {
    setState(() {
      _currentView = _CurrentView.productList;
      _selectedProduct = null;
    });
    productBloc.add(FetchSellerProductsEvent());
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
                  if (state is ProductLoading &&
                      _currentView == _CurrentView.productList) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductError &&
                      _currentView == _CurrentView.productList) {
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
                            onPressed:
                                () =>
                                    productBloc.add(FetchSellerProductsEvent()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ProductLoaded ||
                      _currentView != _CurrentView.productList) {
                    return _buildCurrentView();
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

  Widget _buildCurrentView() {
    switch (_currentView) {
      case _CurrentView.productList:
        return ProductListView(
          searchQuery: _searchQuery,
          selectedCategory: _selectedCategory,
          selectedStatus: _selectedStatus,
          selectedFilter: _selectedFilter,
          selectedSortBy: _selectedSortBy,
          categories: _categories,
          sortOptions: _sortOptions,
          filteredProducts: _filteredProducts,
          productBloc: productBloc,
          onSearchChanged: (value) => setState(() => _searchQuery = value),
          onCategoryChanged: (value) => setState(() => _selectedCategory = value!),
          onSortByChanged: (value) => setState(() => _selectedSortBy = value!),
          onFilterChanged: (value) => setState(() => _selectedFilter = value),
          onAddProduct: _showAddProduct,
          onProductDetails: _showProductDetails,
          onEditProduct: _showEditProduct,
          onDeleteProduct: _deleteProduct,
          onRefresh: () => productBloc.add(FetchSellerProductsEvent()),
          getProductStatus: _getProductStatus,
          getStatusColor: _getStatusColor,
          formatPrice: _formatPrice,
        );
      case _CurrentView.productDetails:
        return ProductDetailsView(
          product: _selectedProduct!,
          onBack: _showProductList,
          getProductStatus: _getProductStatus,
          getStatusColor: _getStatusColor,
          formatPrice: _formatPrice,
          formatDate: _formatDate,
        );
      case _CurrentView.addProduct:
        return AddProductView(onBack: _showProductList);
      case _CurrentView.editProduct:
        return EditProductView(
          product: _selectedProduct!,
          onBack: _showProductList,
        );
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
}

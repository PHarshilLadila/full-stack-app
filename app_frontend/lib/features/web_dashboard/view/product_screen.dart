import 'package:app_frontend/features/seller/products/bloc/product_bloc.dart';
import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/add_product_view.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/dashboard_appbar.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/edit_product_view.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/product_details_view.dart';
import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/product_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CurrentView { productList, productDetails, addProduct, editProduct }

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
  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedStatus = 'All';
  String selectedFilter = 'All';
  String selectedSortBy = 'Newest';

  CurrentView _currentView = CurrentView.productList;
  ProductModel? selectedProduct;

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

  final List<String> statuses = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  final List<String> sortOptions = [
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

  List<ProductModel> get filteredProducts {
    if (productBloc.state is! ProductLoaded) return [];

    final products = (productBloc.state as ProductLoaded).products;

    List<ProductModel> filtered =
        products.where((product) {
          final matchesSearch =
              searchQuery.isEmpty ||
              product.productName.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              product.category.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );

          final matchesCategory =
              selectedCategory == 'All' || product.category == selectedCategory;

          final status = getProductStatus(product);
          final matchesStatus =
              selectedStatus == 'All' || status == selectedStatus;

          bool matchesFilter = true;
          switch (selectedFilter) {
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
      switch (selectedSortBy) {
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

  String getProductStatus(ProductModel product) {
    if (product.stock == 0) return 'Out of Stock';
    if (product.stock <= 10) return 'Low Stock';
    return 'In Stock';
  }

  Color getStatusColor(String status) {
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

  void showProductDetails(ProductModel product) {
    setState(() {
      selectedProduct = product;
      _currentView = CurrentView.productDetails;
    });
  }

  void showEditProduct(ProductModel product) {
    setState(() {
      selectedProduct = product;
      _currentView = CurrentView.editProduct;
    });
  }

  void showAddProduct() {
    setState(() {
      _currentView = CurrentView.addProduct;
    });
  }

  void showProductList() {
    setState(() {
      _currentView = CurrentView.productList;
      selectedProduct = null;
    });
    productBloc.add(FetchSellerProductsEvent());
  }

  void deleteProduct(ProductModel product) {
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
                      _currentView == CurrentView.productList) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductError &&
                      _currentView == CurrentView.productList) {
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
                      _currentView != CurrentView.productList) {
                    return buildCurrentView();
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

  Widget buildCurrentView() {
    switch (_currentView) {
      case CurrentView.productList:
        return ProductListView(
          searchQuery: searchQuery,
          selectedCategory: selectedCategory,
          selectedStatus: selectedStatus,
          selectedFilter: selectedFilter,
          selectedSortBy: selectedSortBy,
          categories: _categories,
          sortOptions: sortOptions,
          filteredProducts: filteredProducts,
          productBloc: productBloc,
          onSearchChanged: (value) => setState(() => searchQuery = value),
          onCategoryChanged:
              (value) => setState(() => selectedCategory = value!),
          onSortByChanged: (value) => setState(() => selectedSortBy = value!),
          onFilterChanged: (value) => setState(() => selectedFilter = value),
          onAddProduct: showAddProduct,
          onProductDetails: showProductDetails,
          onEditProduct: showEditProduct,
          onDeleteProduct: deleteProduct,
          onRefresh: () => productBloc.add(FetchSellerProductsEvent()),
          getProductStatus: getProductStatus,
          getStatusColor: getStatusColor,
          formatPrice: formatPrice,
        );
      case CurrentView.productDetails:
        return ProductDetailsView(
          product: selectedProduct!,
          onBack: showProductList,
          onEdit: () => showEditProduct(selectedProduct!),
          onDelete: () => deleteProduct(selectedProduct!),
          getProductStatus: getProductStatus,
          getStatusColor: getStatusColor,
          formatPrice: formatPrice,
          formatDate: formatDate,
          userEmail: widget.userEmail,
          userName: widget.userName,
          userProfileImage: widget.userProfileImage,
        );
      case CurrentView.addProduct:
        return AddProductView(onBack: showProductList);
      case CurrentView.editProduct:
        return EditProductView(
          product: selectedProduct!,
          onBack: showProductList,
        );
    }
  }

  String formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

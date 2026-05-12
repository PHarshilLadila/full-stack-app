import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_frontend/features/seller/products/bloc/add_product_bloc.dart';
import 'package:app_frontend/features/seller/products/bloc/add_product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/add_product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:app_frontend/utils/common/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AddProductBloc(ProductService())),
        BlocProvider(create: (_) => UserBloc(userService: UserService())),
      ],
      child: const AddProductView(),
    );
  }
}

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final sellerIdController = TextEditingController();
  final sellerNameController = TextEditingController();
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();
  final stockController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  final shortDescController = TextEditingController();
  final detailDescController = TextEditingController();
  final tagsController = TextEditingController();
  final ratingController = TextEditingController();
  final totalReviewsController = TextEditingController();

  // Dynamic Specifications
  final List<Map<String, String>> specifications = [];
  final TextEditingController specNameController = TextEditingController();
  final TextEditingController specValueController = TextEditingController();

  // Image Files
  File? mainBannerImage;
  List<File> multipleImages = [];

  // Available image slots (max 4 additional images)
  final int maxAdditionalImages = 4;

  // User data
  Map<String, dynamic>? sellerData;
  bool isLoadingUser = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSellerData();
  }

  @override
  void dispose() {
    sellerIdController.dispose();
    sellerNameController.dispose();
    productNameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();
    categoryController.dispose();
    subCategoryController.dispose();
    shortDescController.dispose();
    detailDescController.dispose();
    tagsController.dispose();
    ratingController.dispose();
    totalReviewsController.dispose();
    specNameController.dispose();
    specValueController.dispose();
    super.dispose();
  }

  Future<void> _loadSellerData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userRole = prefs.getString('user_role');

      if (token != null && userRole == 'seller') {
        final userService = UserService();
        final user = await userService.getUserProfile(token);

        setState(() {
          sellerData = {'sellerId': user.id, 'sellerName': user.fullName};
          sellerIdController.text = user.id;
          sellerNameController.text = user.fullName;
          isLoadingUser = false;
        });
      } else {
        setState(() {
          errorMessage = 'No seller data found. Please login as seller.';
          isLoadingUser = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load seller data: ${e.toString()}';
        isLoadingUser = false;
      });
    }
  }

  void _addSpecification() {
    final name = specNameController.text.trim();
    final value = specValueController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Please enter specification name');
      return;
    }

    if (value.isEmpty) {
      _showSnackBar('Please enter specification value');
      return;
    }

    setState(() {
      specifications.add({'name': name, 'value': value});
      specNameController.clear();
      specValueController.clear();
    });
  }

  void _removeSpecification(int index) {
    setState(() {
      specifications.removeAt(index);
    });
  }

  void _editSpecification(int index) {
    final spec = specifications[index];
    specNameController.text = spec['name']!;
    specValueController.text = spec['value']!;

    // Remove the old one so we can add edited version
    setState(() {
      specifications.removeAt(index);
    });
  }

  Future<void> _pickMainBannerImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          mainBannerImage = File(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  Future<void> _pickAdditionalImage() async {
    if (multipleImages.length >= maxAdditionalImages) {
      _showSnackBar('Maximum $maxAdditionalImages images allowed');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          multipleImages.add(File(image.path));
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  void _removeAdditionalImage(int index) {
    setState(() {
      multipleImages.removeAt(index);
    });
  }

  void _removeMainBanner() {
    setState(() {
      mainBannerImage = null;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void submitProduct() {
    if (!formKey.currentState!.validate()) return;

    if (mainBannerImage == null) {
      _showSnackBar('Please upload a main banner image');
      return;
    }

    if (multipleImages.isEmpty) {
      _showSnackBar('Please upload at least one additional image');
      return;
    }

    // Build specifications map from dynamic list
    Map<String, String> specsMap = {};
    for (var spec in specifications) {
      specsMap[spec['name']!] = spec['value']!;
    }

    // Parse tags
    List<String> tags = [];
    if (tagsController.text.trim().isNotEmpty) {
      tags =
          tagsController.text.trim().split(',').map((e) => e.trim()).toList();
    }

    final body = {
      "sellerId": sellerIdController.text.trim(),
      "sellerName": sellerNameController.text.trim(),
      "productName": productNameController.text.trim(),
      "price": double.tryParse(priceController.text.trim()) ?? 0,
      "discountPrice":
          double.tryParse(discountPriceController.text.trim()) ?? 0,
      "stock": int.tryParse(stockController.text.trim()) ?? 0,
      "stockAvailable": (int.tryParse(stockController.text.trim()) ?? 0) > 0,
      "category": categoryController.text.trim(),
      "subCategory": subCategoryController.text.trim(),
      "shortDescription": shortDescController.text.trim(),
      "detailedDescription": detailDescController.text.trim(),
      "tags": tags,
      "specifications": specsMap,
      "rating": double.tryParse(ratingController.text.trim()) ?? 0,
      "totalReviews": int.tryParse(totalReviewsController.text.trim()) ?? 0,
      "isActive": true,
    };

    context.read<AddProductBloc>().add(
      SubmitProductWithImagesEvent(
        body: body,
        mainBannerImage: mainBannerImage!,
        multipleImages: multipleImages,
      ),
    );
  }

  Widget _buildReadOnlyField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, size: 20, color: Colors.amber.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, size: 20, color: Colors.amber.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.amber.shade700, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator:
            validator ??
            (isRequired
                ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                }
                : null),
      ),
    );
  }

  Widget _buildImageUploadBox({
    required VoidCallback onTap,
    required Widget? imageWidget,
    required VoidCallback? onRemove,
    String label = '',
    double height = 140,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.amber.shade200,
            width: 2,
            style: BorderStyle.solid,
          ),
          color: Colors.grey.shade50,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child:
                  imageWidget ??
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 42,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label.isEmpty ? 'Upload Image' : label,
                          style: TextStyle(
                            color: Colors.amber.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
            ),
            if (onRemove != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationInput() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 20,
                color: Colors.amber.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Add New Specification',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: specNameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Brand, Color, Size',
                    labelText: 'Specification Name',
                    prefixIcon: Icon(
                      Icons.label_outline,
                      size: 18,
                      color: Colors.amber.shade700,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: specValueController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Apple, Red, XL',
                    labelText: 'Specification Value',
                    prefixIcon: Icon(
                      Icons.text_fields,
                      size: 18,
                      color: Colors.amber.shade700,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _addSpecification,
                  icon: const Icon(Icons.add, color: Colors.white, size: 24),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsList() {
    if (specifications.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              Icons.settings_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No specifications added yet',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Add specifications using the form above',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.settings, size: 18, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Product Specifications',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specifications.length,
            separatorBuilder:
                (context, index) =>
                    Divider(color: Colors.grey.shade200, height: 0),
            itemBuilder: (context, index) {
              final spec = specifications[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Text(
                        spec['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        spec['value']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _editSpecification(index),
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.blue.shade600,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _removeSpecification(index),
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red.shade400,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Add Product",
        backgroundColor: Colors.transparent,
        onMenuTap: () => Scaffold.of(context).openDrawer(),
        onNotificationTap: () {},
        onFavouriteTap: () {},
        showMenu: true,
        showNotification: true,
        showFavourite: true,
      ),
      body: SafeArea(
        child: BlocConsumer<AddProductBloc, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              _showSnackBar(state.message);
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            }
            if (state is AddProductError) {
              _showSnackBar(state.message);
            }
          },
          builder: (context, state) {
            if (isLoadingUser) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.amber),
                    SizedBox(height: 16),
                    Text('Loading seller information...'),
                  ],
                ),
              );
            }

            if (errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(errorMessage!, textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loadSellerData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  RedCorner(),
                  BlueCenter(),
                  YellowCorner(),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.amber.shade800,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add New Product",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  Text(
                                    "Fill in the details below",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Seller Information (Read-only)
                          _buildSectionTitle(
                            "Seller Information",
                            Icons.storefront_outlined,
                          ),
                          _buildReadOnlyField(
                            controller: sellerIdController,
                            label: "Seller ID",
                            icon: Icons.badge_outlined,
                          ),
                          _buildReadOnlyField(
                            controller: sellerNameController,
                            label: "Seller Name",
                            icon: Icons.store_outlined,
                          ),

                          // Product Basic Information
                          _buildSectionTitle(
                            "Product Information",
                            Icons.info_outline,
                          ),
                          _buildTextField(
                            controller: productNameController,
                            label: "Product Name",
                            icon: Icons.tag_outlined,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: priceController,
                                  label: "Price",
                                  icon: Icons.currency_rupee,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: discountPriceController,
                                  label: "Discount Price",
                                  icon: Icons.local_offer_outlined,
                                  keyboardType: TextInputType.number,
                                  isRequired: false,
                                ),
                              ),
                            ],
                          ),
                          _buildTextField(
                            controller: stockController,
                            label: "Stock Quantity",
                            icon: Icons.inventory_2_outlined,
                            keyboardType: TextInputType.number,
                          ),

                          // Categories
                          _buildSectionTitle(
                            "Categories",
                            Icons.category_outlined,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: categoryController,
                                  label: "Category",
                                  icon: Icons.grid_view_outlined,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: subCategoryController,
                                  label: "Sub Category",
                                  icon: Icons.layers_outlined,
                                ),
                              ),
                            ],
                          ),

                          // Descriptions
                          _buildSectionTitle(
                            "Descriptions",
                            Icons.description_outlined,
                          ),
                          _buildTextField(
                            controller: shortDescController,
                            label: "Short Description",
                            icon: Icons.short_text_outlined,
                            maxLines: 2,
                          ),
                          _buildTextField(
                            controller: detailDescController,
                            label: "Detailed Description",
                            icon: Icons.article_outlined,
                            maxLines: 4,
                          ),

                          // Tags & Ratings
                          _buildSectionTitle(
                            "Tags & Ratings",
                            Icons.tune_outlined,
                          ),
                          _buildTextField(
                            controller: tagsController,
                            label: "Tags (comma separated)",
                            icon: Icons.local_offer_outlined,
                            isRequired: false,
                            validator: null,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: ratingController,
                                  label: "Rating",
                                  icon: Icons.star_outline,
                                  keyboardType: TextInputType.number,
                                  isRequired: false,
                                  validator: null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  controller: totalReviewsController,
                                  label: "Total Reviews",
                                  icon: Icons.reviews_outlined,
                                  keyboardType: TextInputType.number,
                                  isRequired: false,
                                  validator: null,
                                ),
                              ),
                            ],
                          ),

                          // Main Banner Image
                          _buildSectionTitle(
                            "Main Banner Image",
                            Icons.image_outlined,
                          ),
                          _buildImageUploadBox(
                            onTap: _pickMainBannerImage,
                            imageWidget:
                                mainBannerImage != null
                                    ? Image.file(
                                      mainBannerImage!,
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                            onRemove:
                                mainBannerImage != null
                                    ? _removeMainBanner
                                    : null,
                            label: 'Tap to upload main banner',
                          ),

                          // Additional Images
                          _buildSectionTitle(
                            "Additional Images",
                            Icons.photo_library_outlined,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                ...multipleImages.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  File imageFile = entry.value;
                                  return SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: _buildImageUploadBox(
                                      onTap: () {},
                                      imageWidget: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.file(
                                          imageFile,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      onRemove:
                                          () => _removeAdditionalImage(index),
                                      height: 100,
                                    ),
                                  );
                                }),
                                if (multipleImages.length < maxAdditionalImages)
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: GestureDetector(
                                      onTap: _pickAdditionalImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Colors.amber.shade200,
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                          color: Colors.grey.shade50,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              size: 32,
                                              color: Colors.amber.shade700,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Add Image',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (multipleImages.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Tap the box above to add images (Max $maxAdditionalImages)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),

                          // Specifications
                          _buildSectionTitle(
                            "Specifications",
                            Icons.settings_outlined,
                          ),
                          _buildSpecificationInput(),
                          const SizedBox(height: 12),
                          _buildSpecificationsList(),

                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  state is AddProductLoading
                                      ? null
                                      : submitProduct,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xffFDBB12),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child:
                                  state is AddProductLoading
                                      ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "Publish Product",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.amber.shade700),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: 1,
              color: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}

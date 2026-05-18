
import 'package:app_frontend/features/seller/products/bloc/product_bloc.dart';
import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:material_table_view/material_table_view.dart';
import 'package:material_table_view/table_view_typedefs.dart';

class AddProductFormWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  const AddProductFormWidget({required this.onSuccess});

  @override
  State<AddProductFormWidget> createState() => _AddProductFormWidgetState();
}

class _AddProductFormWidgetState extends State<AddProductFormWidget> {
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

  List<MapEntry<String, String>> _specifications = [];

  List<int>? _mainBannerImageBytes;
  String? _mainBannerImageName;
  String? _mainBannerImageUrl;

  List<List<int>> _multipleImagesBytes = [];
  List<String> _multipleImageNames = [];
  List<String> _multipleImageUrls = [];

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
    if (_mainBannerImageUrl != null) html.Url.revokeObjectUrl(_mainBannerImageUrl!);
    for (var url in _multipleImageUrls) html.Url.revokeObjectUrl(url);
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

  void _addSpecification() => setState(() => _specifications.add(const MapEntry('', '')));
  void _updateSpecification(int index, String key, String value) => setState(() => _specifications[index] = MapEntry(key, value));
  void _removeSpecification(int index) => setState(() => _specifications.removeAt(index));

  Future<void> _pickMainBannerImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      setState(() {
        _mainBannerImageBytes = bytes;
        _mainBannerImageName = pickedFile.name;
        _mainBannerImageUrl = url;
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final List<String> urls = [];
      final List<List<int>> bytesList = [];
      final List<String> names = [];
      for (var file in pickedFiles) {
        final bytes = await file.readAsBytes();
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        urls.add(url);
        bytesList.add(bytes);
        names.add(file.name);
      }
      setState(() {
        _multipleImageUrls.addAll(urls);
        _multipleImagesBytes.addAll(bytesList);
        _multipleImageNames.addAll(names);
      });
    }
  }

  void _removeMultipleImage(int index) {
    html.Url.revokeObjectUrl(_multipleImageUrls[index]);
    setState(() {
      _multipleImageUrls.removeAt(index);
      _multipleImagesBytes.removeAt(index);
      _multipleImageNames.removeAt(index);
    });
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_mainBannerImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a main banner image')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tags = _tagsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final Map<String, dynamic> specifications = {};
      for (var spec in _specifications) {
        if (spec.key.trim().isNotEmpty && spec.value.trim().isNotEmpty) {
          specifications[spec.key.trim()] = spec.value.trim();
        }
      }

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
        'specifications': specifications,
      };

      final productService = ProductService();
      await productService.addProductWithImageBytes(
        body: body,
        mainBannerImageBytes: _mainBannerImageBytes!,
        mainBannerImageName: _mainBannerImageName!,
        multipleImagesBytes: _multipleImagesBytes,
        multipleImagesNames: _multipleImageNames,
      );

      if (_mainBannerImageUrl != null) html.Url.revokeObjectUrl(_mainBannerImageUrl!);
      for (var url in _multipleImageUrls) html.Url.revokeObjectUrl(url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product added successfully'), backgroundColor: Colors.green));
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 800;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Main Banner Image *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
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
                        child: _mainBannerImageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(_mainBannerImageUrl!, fit: BoxFit.cover, width: double.infinity),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload, size: 40, color: Colors.grey.shade400),
                                  const SizedBox(height: 8),
                                  Text('Tap to upload main banner image', style: TextStyle(color: Colors.grey.shade600)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Additional Images', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _pickMultipleImages,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Add Images'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                    const SizedBox(height: 12),
                    if (_multipleImageUrls.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _multipleImageUrls.length,
                          itemBuilder: (context, index) => Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(_multipleImageUrls[index], fit: BoxFit.cover, width: 100, height: 100),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeMultipleImage(index),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _productNameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name *',
                        prefixIcon: Icon(Icons.shopping_bag_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter product name' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(labelText: 'Original Price (₹) *', prefixIcon: Icon(Icons.currency_rupee), border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (value) => value?.isEmpty ?? true ? 'Please enter price' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _discountPriceController,
                            decoration: const InputDecoration(labelText: 'Discounted Price (₹) *', prefixIcon: Icon(Icons.local_offer_outlined), border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (value) => value?.isEmpty ?? true ? 'Please enter discounted price' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _stockController,
                            decoration: const InputDecoration(labelText: 'Stock Quantity *', prefixIcon: Icon(Icons.inventory_2_outlined), border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (value) => value?.isEmpty ?? true ? 'Please enter stock quantity' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _categoryController,
                            decoration: const InputDecoration(labelText: 'Category *', prefixIcon: Icon(Icons.category_outlined), border: OutlineInputBorder()),
                            validator: (value) => value?.isEmpty ?? true ? 'Please enter category' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _subCategoryController,
                            decoration: const InputDecoration(labelText: 'Sub Category', prefixIcon: Icon(Icons.subdirectory_arrow_right), border: OutlineInputBorder()),
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
                              helperText: 'e.g., popular, new, sale',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _shortDescriptionController,
                      decoration: const InputDecoration(labelText: 'Short Description', prefixIcon: Icon(Icons.description_outlined), border: OutlineInputBorder()),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _detailedDescriptionController,
                      decoration: const InputDecoration(labelText: 'Detailed Description', prefixIcon: Icon(Icons.article_outlined), border: OutlineInputBorder()),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Product Specifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              TextButton.icon(
                                onPressed: _addSpecification,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Specification'),
                                style: TextButton.styleFrom(foregroundColor: const Color(0xFF7C3AED)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_specifications.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(32),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(Icons.settings_outlined, size: 48, color: Colors.grey.shade400),
                                  const SizedBox(height: 8),
                                  Text('No specifications added', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text('Click "Add Specification" to add product features', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                                ],
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _specifications.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final spec = _specifications[index];
                                return Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: spec.key,
                                        decoration: const InputDecoration(
                                          labelText: 'Specification Name',
                                          hintText: 'e.g., Brand, Color, Size',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        ),
                                        onChanged: (value) => _updateSpecification(index, value, spec.value),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: spec.value,
                                        decoration: const InputDecoration(
                                          labelText: 'Specification Value',
                                          hintText: 'e.g., Nike, Black, XL',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        ),
                                        onChanged: (value) => _updateSpecification(index, spec.key, value),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _removeSpecification(index),
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      tooltip: 'Remove',
                                    ),
                                  ],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.onSuccess,
                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    );
  }
}

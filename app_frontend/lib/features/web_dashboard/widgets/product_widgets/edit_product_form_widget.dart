// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProductFormWidget extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onSuccess;
  const EditProductFormWidget({super.key, required this.product, required this.onSuccess});

  @override
  State<EditProductFormWidget> createState() => EditProductFormWidgetState();
}

class EditProductFormWidgetState extends State<EditProductFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController productNameController;
  late TextEditingController priceController;
  late TextEditingController discountPriceController;
  late TextEditingController stockController;
  late TextEditingController categoryController;
  late TextEditingController subCategoryController;
  late TextEditingController shortDescriptionController;
  late TextEditingController detailedDescriptionController;
  late TextEditingController tagsController;

  List<MapEntry<String, String>> _specifications = [];

  File? mainBannerImage;
  List<File> newMultipleImages = [];
  List<String> existingMultipleImages = [];

  List<int>? newMainBannerImageBytes;
  String? newMainBannerImageName;
  List<List<int>> newMultipleImagesBytes = [];
  List<String> newMultipleImagesNames = [];

  final ImagePicker picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController(
      text: widget.product.productName,
    );
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    discountPriceController = TextEditingController(
      text: widget.product.discountPrice.toString(),
    );
    stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );
    categoryController = TextEditingController(text: widget.product.category);
    subCategoryController = TextEditingController(
      text: widget.product.subCategory,
    );
    shortDescriptionController = TextEditingController(
      text: widget.product.shortDescription,
    );
    detailedDescriptionController = TextEditingController(
      text: widget.product.detailedDescription,
    );
    tagsController = TextEditingController(
      text: widget.product.tags.join(', '),
    );
    _specifications =
        widget.product.specifications.entries
            .map((entry) => MapEntry(entry.key, entry.value.toString()))
            .toList();
    existingMultipleImages = List.from(widget.product.multipleImages);
  }

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();
    categoryController.dispose();
    subCategoryController.dispose();
    shortDescriptionController.dispose();
    detailedDescriptionController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  void addSpecification() =>
      setState(() => _specifications.add(const MapEntry('', '')));
  void updateSpecification(int index, String key, String value) =>
      setState(() => _specifications[index] = MapEntry(key, value));
  void removeSpecification(int index) =>
      setState(() => _specifications.removeAt(index));

  Future<void> pickMainBannerImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        newMainBannerImageBytes = bytes;
        newMainBannerImageName = pickedFile.name;
        mainBannerImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickMultipleImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final List<List<int>> bytesList = [];
      final List<String> names = [];
      final List<File> files = [];
      for (var file in pickedFiles) {
        final bytes = await file.readAsBytes();
        bytesList.add(bytes);
        names.add(file.name);
        files.add(File(file.path));
      }
      setState(() {
        newMultipleImagesBytes.addAll(bytesList);
        newMultipleImagesNames.addAll(names);
        newMultipleImages.addAll(files);
      });
    }
  }

  void removeExistingImage(int index) =>
      setState(() => existingMultipleImages.removeAt(index));
  void removeNewImage(int index) =>
      setState(() => newMultipleImages.removeAt(index));

  Future<void> submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final tags =
          tagsController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      final Map<String, dynamic> specifications = {};
      for (var spec in _specifications) {
        if (spec.key.trim().isNotEmpty && spec.value.trim().isNotEmpty) {
          specifications[spec.key.trim()] = spec.value.trim();
        }
      }

      final body = {
        'productId': widget.product.id,
        'productName': productNameController.text,
        'price': double.parse(priceController.text),
        'discountPrice': double.parse(discountPriceController.text),
        'stock': int.parse(stockController.text),
        'stockAvailable': int.parse(stockController.text) > 0,
        'category': categoryController.text,
        'subCategory': subCategoryController.text,
        'tags': tags,
        'shortDescription': shortDescriptionController.text,
        'detailedDescription': detailedDescriptionController.text,
        'specifications': specifications,
      };

      final productService = ProductService();

      if (newMainBannerImageBytes != null ||
          newMultipleImagesBytes.isNotEmpty) {
        await productService.updateProductWithImageBytes(
          body: body,
          mainBannerImageBytes: newMainBannerImageBytes,
          mainBannerImageName: newMainBannerImageName,
          newMultipleImagesBytes:
              newMultipleImagesBytes.isNotEmpty
                  ? newMultipleImagesBytes
                  : null,
          newMultipleImagesNames:
              newMultipleImagesNames.isNotEmpty
                  ? newMultipleImagesNames
                  : null,
          existingMultipleImages: existingMultipleImages,
        );
      } else {
        await productService.updateProduct(body: body);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
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
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        onTap: pickMainBannerImage,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child:
                              mainBannerImage != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      mainBannerImage!,
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
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: const Color(0xFFF8FAFC),
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey,
                                                  size: 40,
                                                ),
                                              ),
                                    ),
                                  ),
                        ),
                      ),
                      if (mainBannerImage == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Tap to change image',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      const Text(
                        'Additional Images',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: pickMultipleImages,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Add More Images'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (existingMultipleImages.isNotEmpty) ...[
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
                            itemCount: existingMultipleImages.length,
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
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          existingMultipleImages[index],
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    color: const Color(
                                                      0xFFF8FAFC,
                                                    ),
                                                    child: const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                      size: 30,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap:
                                              () => removeExistingImage(index),
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
                      if (newMultipleImages.isNotEmpty) ...[
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
                            itemCount: newMultipleImages.length,
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
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          newMultipleImages[index],
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => removeNewImage(index),
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
                      TextFormField(
                        controller: productNameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name *',
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: priceController,
                              decoration: const InputDecoration(
                                labelText: 'Original Price (₹) *',
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
                              controller: discountPriceController,
                              decoration: const InputDecoration(
                                labelText: 'Discounted Price (₹) *',
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: stockController,
                              decoration: const InputDecoration(
                                labelText: 'Stock Quantity *',
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
                              controller: categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Category *',
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: subCategoryController,
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
                              controller: tagsController,
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
                        controller: shortDescriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Short Description',
                          prefixIcon: Icon(Icons.description_outlined),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: detailedDescriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Detailed Description',
                          prefixIcon: Icon(Icons.article_outlined),
                          border: OutlineInputBorder(),
                        ),
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
                                const Text(
                                  'Product Specifications',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: addSpecification,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add Specification'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF7C3AED),
                                  ),
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
                                    Icon(
                                      Icons.settings_outlined,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No specifications added',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Click "Add Specification" to add product features',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _specifications.length,
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final spec = _specifications[index];
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: spec.key,
                                          decoration: const InputDecoration(
                                            labelText: 'Specification Name',
                                            hintText:
                                                'e.g., Brand, Color, Size',
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 12,
                                                ),
                                          ),
                                          onChanged:
                                              (value) => updateSpecification(
                                                index,
                                                value,
                                                spec.value,
                                              ),
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 12,
                                                ),
                                          ),
                                          onChanged:
                                              (value) => updateSpecification(
                                                index,
                                                spec.key,
                                                value,
                                              ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed:
                                            () => removeSpecification(index),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
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
                              onPressed: submitProduct,
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
    );
  }
}

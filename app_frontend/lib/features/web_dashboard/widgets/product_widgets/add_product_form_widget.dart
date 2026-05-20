// // ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

// import 'package:app_frontend/features/seller/products/service/product_service.dart';
// import 'package:app_frontend/features/seller/products/model/product_model.dart';
// import 'package:app_frontend/utils/common/custom_text_field.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:html' as html;
// import 'dart:io';

// class ProductFormWidget extends StatefulWidget {
//   final ProductModel? product;
//   final VoidCallback onSuccess;

//   const ProductFormWidget({super.key, this.product, required this.onSuccess});

//   @override
//   State<ProductFormWidget> createState() => _ProductFormWidgetState();
// }

// class _ProductFormWidgetState extends State<ProductFormWidget> {
//   final formKey = GlobalKey<FormState>();
//   late TextEditingController productNameController;
//   late TextEditingController priceController;
//   late TextEditingController discountPriceController;
//   late TextEditingController stockController;
//   late TextEditingController categoryController;
//   late TextEditingController subCategoryController;
//   late TextEditingController shortDescriptionController;
//   late TextEditingController detailedDescriptionController;
//   late TextEditingController tagsController;

//   List<MapEntry<String, String>> _specifications = [];

//   List<int>? mainBannerImageBytes;
//   String? mainBannerImageName;
//   String? mainBannerImageUrl;
//   List<List<int>> multipleImagesBytes = [];
//   List<String> multipleImageNames = [];
//   List<String> multipleImageUrls = [];

//   File? mainBannerImageFile;
//   List<File> newMultipleImageFiles = [];
//   List<String> existingMultipleImages = [];

//   final ImagePicker picker = ImagePicker();
//   bool isLoading = false;
//   bool isEditMode = false;

//   @override
//   void initState() {
//     super.initState();
//     isEditMode = widget.product != null;

//     if (isEditMode) {
//       productNameController = TextEditingController(
//         text: widget.product!.productName,
//       );
//       priceController = TextEditingController(
//         text: widget.product!.price.toString(),
//       );
//       discountPriceController = TextEditingController(
//         text: widget.product!.discountPrice.toString(),
//       );
//       stockController = TextEditingController(
//         text: widget.product!.stock.toString(),
//       );
//       categoryController = TextEditingController(
//         text: widget.product!.category,
//       );
//       subCategoryController = TextEditingController(
//         text: widget.product!.subCategory,
//       );
//       shortDescriptionController = TextEditingController(
//         text: widget.product!.shortDescription,
//       );
//       detailedDescriptionController = TextEditingController(
//         text: widget.product!.detailedDescription,
//       );
//       tagsController = TextEditingController(
//         text: widget.product!.tags.join(', '),
//       );

//       _specifications =
//           widget.product!.specifications.entries
//               .map((entry) => MapEntry(entry.key, entry.value.toString()))
//               .toList();

//       existingMultipleImages = List.from(widget.product!.multipleImages);
//     } else {
//       productNameController = TextEditingController();
//       priceController = TextEditingController();
//       discountPriceController = TextEditingController();
//       stockController = TextEditingController();
//       categoryController = TextEditingController();
//       subCategoryController = TextEditingController();
//       shortDescriptionController = TextEditingController();
//       detailedDescriptionController = TextEditingController();
//       tagsController = TextEditingController();
//     }
//   }

//   @override
//   void dispose() {
//     if (!isEditMode && mainBannerImageUrl != null) {
//       html.Url.revokeObjectUrl(mainBannerImageUrl!);
//     }
//     for (var url in multipleImageUrls) {
//       html.Url.revokeObjectUrl(url);
//     }
//     productNameController.dispose();
//     priceController.dispose();
//     discountPriceController.dispose();
//     stockController.dispose();
//     categoryController.dispose();
//     subCategoryController.dispose();
//     shortDescriptionController.dispose();
//     detailedDescriptionController.dispose();
//     tagsController.dispose();
//     super.dispose();
//   }

//   void addSpecification() =>
//       setState(() => _specifications.add(const MapEntry('', '')));

//   void updateSpecification(int index, String key, String value) =>
//       setState(() => _specifications[index] = MapEntry(key, value));

//   void removeSpecification(int index) =>
//       setState(() => _specifications.removeAt(index));

//   Future<void> pickMainBannerImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final bytes = await pickedFile.readAsBytes();
//       final blob = html.Blob([bytes]);
//       final url = html.Url.createObjectUrlFromBlob(blob);

//       setState(() {
//         mainBannerImageBytes = bytes;
//         mainBannerImageName = pickedFile.name;
//         mainBannerImageUrl = url;
//       });
//     }
//   }

//   Future<void> pickMultipleImages() async {
//     final pickedFiles = await picker.pickMultiImage();

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
//         multipleImageUrls.addAll(urls);
//         multipleImagesBytes.addAll(bytesList);
//         multipleImageNames.addAll(names);
//       });
//     }
//   }

//   void removeMultipleImage(int index) {
//     if (!isEditMode) {
//       html.Url.revokeObjectUrl(multipleImageUrls[index]);
//     }

//     setState(() {
//       multipleImageUrls.removeAt(index);
//       multipleImagesBytes.removeAt(index);
//       multipleImageNames.removeAt(index);
//     });
//   }

//   Future<void> pickEditMainBannerImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final bytes = await pickedFile.readAsBytes();

//       setState(() {
//         mainBannerImageBytes = bytes;
//         mainBannerImageName = pickedFile.name;
//         mainBannerImageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> pickEditMultipleImages() async {
//     final pickedFiles = await picker.pickMultiImage();

//     if (pickedFiles.isNotEmpty) {
//       final List<List<int>> bytesList = [];
//       final List<String> names = [];
//       final List<File> files = [];
//       final List<String> urls = [];

//       for (var file in pickedFiles) {
//         final bytes = await file.readAsBytes();
//         final blob = html.Blob([bytes]);
//         final url = html.Url.createObjectUrlFromBlob(blob);

//         urls.add(url);
//         bytesList.add(bytes);
//         names.add(file.name);
//         files.add(File(file.path));
//       }

//       setState(() {
//         multipleImageUrls.addAll(urls);
//         multipleImagesBytes.addAll(bytesList);
//         multipleImageNames.addAll(names);
//         newMultipleImageFiles.addAll(files);
//       });
//     }
//   }

//   void removeExistingImage(int index) =>
//       setState(() => existingMultipleImages.removeAt(index));

//   void removeNewEditImage(int index) {
//     if (index < multipleImageUrls.length) {
//       html.Url.revokeObjectUrl(multipleImageUrls[index]);
//       setState(() {
//         multipleImageUrls.removeAt(index);
//         multipleImagesBytes.removeAt(index);
//         multipleImageNames.removeAt(index);
//         newMultipleImageFiles.removeAt(index);
//       });
//     }
//   }

//   Future<void> submitProduct() async {
//     if (!formKey.currentState!.validate()) return;

//     if (!isEditMode && mainBannerImageBytes == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a main banner image')),
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       final tags =
//           tagsController.text
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
//         if (isEditMode) 'productId': widget.product!.id,
//         'productName': productNameController.text,
//         'price': double.parse(priceController.text),
//         'discountPrice': double.parse(discountPriceController.text),
//         'stock': int.parse(stockController.text),
//         'stockAvailable': int.parse(stockController.text) > 0,
//         'category': categoryController.text,
//         'subCategory': subCategoryController.text,
//         'tags': tags,
//         'shortDescription': shortDescriptionController.text,
//         'detailedDescription': detailedDescriptionController.text,
//         'specifications': specifications,
//       };

//       final productService = ProductService();

//       if (isEditMode) {
//         if (mainBannerImageBytes != null || multipleImagesBytes.isNotEmpty) {
//           await productService.updateProductWithImageBytes(
//             body: body,
//             mainBannerImageBytes: mainBannerImageBytes,
//             mainBannerImageName: mainBannerImageName,
//             newMultipleImagesBytes:
//                 multipleImagesBytes.isNotEmpty ? multipleImagesBytes : null,
//             newMultipleImagesNames:
//                 multipleImageNames.isNotEmpty ? multipleImageNames : null,
//             existingMultipleImages: existingMultipleImages,
//           );
//         } else {
//           await productService.updateProduct(body: body);
//         }

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Product updated successfully'),
//               backgroundColor: Colors.green,
//             ),
//           );

//           widget.onSuccess();
//         }
//       } else {
//         await productService.addProductWithImageBytes(
//           body: body,
//           mainBannerImageBytes: mainBannerImageBytes!,
//           mainBannerImageName: mainBannerImageName!,
//           multipleImagesBytes: multipleImagesBytes,
//           multipleImagesNames: multipleImageNames,
//         );

//         if (mainBannerImageUrl != null) {
//           html.Url.revokeObjectUrl(mainBannerImageUrl!);
//         }

//         for (var url in multipleImageUrls) {
//           html.Url.revokeObjectUrl(url);
//         }

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Product added successfully'),
//               backgroundColor: Colors.green,
//             ),
//           );

//           widget.onSuccess();
//         }
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
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final isSmallScreen = screenSize.width < 800;

//     return isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       OutlinedButton(
//                         onPressed: widget.onSuccess,
//                         style: OutlinedButton.styleFrom(
//                           padding: EdgeInsets.all(16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text('Cancel'),
//                       ),

//                       const SizedBox(width: 16),

//                       ElevatedButton(
//                         onPressed: submitProduct,
//                         style: ElevatedButton.styleFrom(
//                           elevation: 0,
//                           backgroundColor: const Color(0xFF7C3AED),
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.all(16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           isEditMode ? 'Save Changes' : 'Add Product',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                   children: [
//                     Expanded(
//                       flex: 60,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,

//                         children: [
//                           // Left side
//                           Container(
//                             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.04),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),

//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Basic Information',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 20 : 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 16),
//                                 Text(
//                                   'Product Name *',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFF1E293B),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),

//                                 AppTextField(
//                                   controller: productNameController,
//                                   hintText: 'Product Name *',
//                                   icon: Icons.shopping_bag_outlined,
//                                   validator:
//                                       (value) =>
//                                           value?.isEmpty ?? true
//                                               ? 'Please enter product name'
//                                               : null,
//                                 ),

//                                 const SizedBox(height: 16),

//                                 Text(
//                                   'Short Description *',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFF1E293B),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),

//                                 TextFormField(
//                                   controller: shortDescriptionController,
//                                   cursorColor: Colors.deepPurple,
//                                   maxLines: 2,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                   decoration: InputDecoration(
//                                     hintText: "Short Description",
//                                     hintStyle: const TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                     filled: true,
//                                     fillColor: Colors.white,

//                                     contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 16,
//                                     ),

//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Colors.grey.withOpacity(0.6),
//                                         width: 0.5,
//                                       ),
//                                     ),

//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Colors.grey.withOpacity(0.6),
//                                         width: 0.5,
//                                       ),
//                                     ),

//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Colors.grey.withOpacity(0.6),
//                                         width: 0.5,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   'Detailed Description *',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFF1E293B),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),

//                                 TextFormField(
//                                   controller: detailedDescriptionController,
//                                   cursorColor: Colors.deepPurple,
//                                   maxLines: 4,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                   ),
//                                   decoration: InputDecoration(
//                                     hintText: "Detailed Description",
//                                     hintStyle: const TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                     filled: true,
//                                     fillColor: Colors.white,

//                                     contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 16,
//                                     ),

//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Colors.grey.withOpacity(0.6),
//                                         width: 0.5,
//                                       ),
//                                     ),

//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Colors.grey.withOpacity(0.6),
//                                         width: 0.5,
//                                       ),
//                                     ),

//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Colors.grey.withOpacity(0.6),
//                                         width: 0.5,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 24),

//                           Container(
//                             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.04),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Product Images',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 20 : 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),

//                                 const Text(
//                                   'Main Banner Image *',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF1E293B),
//                                   ),
//                                 ),

//                                 const SizedBox(height: 12),

//                                 GestureDetector(
//                                   onTap:
//                                       isEditMode
//                                           ? pickEditMainBannerImage
//                                           : pickMainBannerImage,
//                                   child:
//                                       !isEditMode
//                                           ? DottedBorder(
//                                             options:
//                                                 RoundedRectDottedBorderOptions(
//                                                   radius: Radius.circular(12),
//                                                   color: Colors.grey,
//                                                   dashPattern: [6, 4],
//                                                 ),
//                                             child: Container(
//                                               width: double.infinity,
//                                               height: 320,
//                                               decoration: BoxDecoration(
//                                                 color: const Color(0xFFF8FAFC),
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                               ),
//                                               child: _buildMainBannerPreview(),
//                                             ),
//                                           )
//                                           : Container(
//                                             width: 560,
//                                             height: 320,
//                                             decoration: BoxDecoration(
//                                               color: const Color(0xFFF8FAFC),
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                               border: Border.all(
//                                                 color: Colors.grey.shade300,
//                                               ),
//                                             ),
//                                             child: _buildMainBannerPreview(),
//                                           ),
//                                 ),

//                                 if (isEditMode && mainBannerImageFile == null)
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 8),
//                                     child: Text(
//                                       'Tap to change image',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 SizedBox(height: 24),
//                                 const Text(
//                                   'Additional Images',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF1E293B),
//                                   ),
//                                 ),

//                                 const SizedBox(height: 12),
//                                 DottedBorder(
//                                   options: RoundedRectDottedBorderOptions(
//                                     radius: Radius.circular(12),
//                                     dashPattern: const [6, 4],
//                                     color: Colors.grey,
//                                   ),

//                                   child: InkWell(
//                                     onTap:
//                                         isEditMode
//                                             ? pickEditMultipleImages
//                                             : pickMultipleImages,
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: Container(
//                                       height: 80,
//                                       width: double.infinity,
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 12,
//                                         horizontal: 16,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         color: Colors.white,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const Icon(
//                                             Icons.add_photo_alternate,
//                                             color: Colors.grey,
//                                           ),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             isEditMode
//                                                 ? 'Add More Images'
//                                                 : 'Add Images',
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(height: 24),

//                                 _buildAdditionalImagesPreview(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 24),
//                     Expanded(
//                       flex: 40,
//                       child: Column(
//                         children: [
//                           // Container(
//                           //   padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                           //   decoration: BoxDecoration(
//                           //     color: Colors.white,
//                           //     borderRadius: BorderRadius.circular(16),
//                           //     boxShadow: [
//                           //       BoxShadow(
//                           //         color: Colors.black.withOpacity(0.04),
//                           //         blurRadius: 10,
//                           //         offset: const Offset(0, 2),
//                           //       ),
//                           //     ],
//                           //   ),
//                           //   child: Column(
//                           //     crossAxisAlignment: CrossAxisAlignment.center,
//                           //     children: [
//                           //       Align(
//                           //         alignment: Alignment.centerLeft,
//                           //         child: Text(
//                           //           'Publish',
//                           //           style: TextStyle(
//                           //             fontSize: isSmallScreen ? 20 : 24,
//                           //             fontWeight: FontWeight.bold,
//                           //             color: Colors.black,
//                           //           ),
//                           //         ),
//                           //       ),
//                           //       Row(
//                           //         mainAxisAlignment:
//                           //             MainAxisAlignment.spaceBetween,
//                           //         children: [
//                           //           Text(
//                           //             'Status',
//                           //             style: TextStyle(
//                           //               fontSize: 14,
//                           //               fontWeight: FontWeight.w500,
//                           //               color: Color(0xFF1E293B),
//                           //             ),
//                           //           ),
//                           //           Row(
//                           //             children: [
//                           //               CupertinoSwitch(
//                           //                 value: false,
//                           //                 onChanged: (value) {},
//                           //               ),
//                           //               Text(
//                           //                 "Draft",
//                           //                 style: const TextStyle(
//                           //                   color: Colors.black,
//                           //                   fontSize: 14,
//                           //                   fontWeight: FontWeight.w600,
//                           //                 ),
//                           //               ),
//                           //             ],
//                           //           ),
//                           //         ],
//                           //       ),

//                           //       const SizedBox(height: 16),
//                           //       Row(
//                           //         mainAxisAlignment:
//                           //             MainAxisAlignment.spaceBetween,
//                           //         children: [
//                           //           Text(
//                           //             'Visiblity',
//                           //             style: TextStyle(
//                           //               fontSize: 14,
//                           //               fontWeight: FontWeight.w500,
//                           //               color: Color(0xFF1E293B),
//                           //             ),
//                           //           ),

//                           //           Text(
//                           //             "Public",
//                           //             style: const TextStyle(
//                           //               color: Colors.black,
//                           //               fontSize: 14,
//                           //               fontWeight: FontWeight.w600,
//                           //             ),
//                           //           ),
//                           //         ],
//                           //       ),
//                           //       SizedBox(height: 16),
//                           //       Divider(color: Colors.grey.withOpacity(0.3)),
//                           //       SizedBox(height: 16),
//                           //       ElevatedButton(
//                           //         onPressed: () {},
//                           //         style: ElevatedButton.styleFrom(
//                           //           backgroundColor: Colors.deepPurple,
//                           //           foregroundColor: Colors.white,
//                           //           elevation: 0,
//                           //           padding: const EdgeInsets.symmetric(
//                           //             horizontal: 24,
//                           //             vertical: 16,
//                           //           ),
//                           //           shape: RoundedRectangleBorder(
//                           //             borderRadius: BorderRadius.circular(8),
//                           //           ),
//                           //         ),
//                           //         child: const Text(
//                           //           'Save Product',
//                           //           style: TextStyle(
//                           //             fontSize: 15,
//                           //             fontWeight: FontWeight.w600,
//                           //           ),
//                           //         ),
//                           //       ),
//                           //       ElevatedButton(
//                           //         onPressed: () {},
//                           //         style: ElevatedButton.styleFrom(
//                           //           backgroundColor: Colors.white,
//                           //           foregroundColor: Colors.black,
//                           //           elevation: 0,
//                           //           padding: const EdgeInsets.symmetric(
//                           //             horizontal: 24,
//                           //             vertical: 16,
//                           //           ),
//                           //           shape: RoundedRectangleBorder(
//                           //             borderRadius: BorderRadius.circular(8),
//                           //             side: BorderSide(
//                           //               color: Colors.grey.withOpacity(0.5),
//                           //               width: 0.5,
//                           //             ),
//                           //           ),
//                           //         ),
//                           //         child: const Text(
//                           //           'Save as Draft',
//                           //           style: TextStyle(
//                           //             fontSize: 15,
//                           //             fontWeight: FontWeight.w600,
//                           //             color: Colors.black,
//                           //           ),
//                           //         ),
//                           //       ),
//                           //       TextButton(
//                           //         onPressed: () {},
//                           //         style: TextButton.styleFrom(
//                           //           foregroundColor: Colors.black,
//                           //           padding: const EdgeInsets.symmetric(
//                           //             horizontal: 16,
//                           //             vertical: 12,
//                           //           ),
//                           //           textStyle: const TextStyle(
//                           //             fontSize: 15,
//                           //             fontWeight: FontWeight.w500,
//                           //           ),
//                           //         ),
//                           //         child: const Text('Discard'),
//                           //       ),
//                           //     ],
//                           //   ),
//                           // ),

//                           // SizedBox(height: 24),
//                           Container(
//                             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.04),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),

//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Pricing',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 20 : 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 16),

//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Price *',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xFF1E293B),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     AppTextField(
//                                       controller: priceController,
//                                       hintText: 'Original Price (₹)',
//                                       icon: Icons.currency_rupee,
//                                       keyboardType: TextInputType.number,
//                                       validator:
//                                           (value) =>
//                                               value?.isEmpty ?? true
//                                                   ? 'Please enter price'
//                                                   : null,
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 24),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Discount Price *',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xFF1E293B),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     AppTextField(
//                                       controller: discountPriceController,
//                                       hintText:
//                                           'Calculated Discounted Price (₹)',
//                                       icon: Icons.local_offer_outlined,
//                                       keyboardType: TextInputType.number,
//                                       validator:
//                                           (value) =>
//                                               value?.isEmpty ?? true
//                                                   ? 'Please enter discounted price'
//                                                   : null,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           SizedBox(height: 24),
//                           Container(
//                             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.04),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),

//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Inventory & Categories',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 20 : 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 16),

//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,

//                                         children: [
//                                           Text(
//                                             'Stock Quantity *',
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w500,
//                                               color: Color(0xFF1E293B),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           AppTextField(
//                                             controller: stockController,
//                                             hintText: 'Stock Quantity',
//                                             icon: Icons.inventory_2_outlined,
//                                             keyboardType: TextInputType.number,

//                                             validator:
//                                                 (value) =>
//                                                     value?.isEmpty ?? true
//                                                         ? 'Please enter stock quantity'
//                                                         : null,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Category *',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xFF1E293B),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     AppTextField(
//                                       controller: categoryController,
//                                       hintText: 'Category',
//                                       icon: Icons.category_outlined,
//                                       validator:
//                                           (value) =>
//                                               value?.isEmpty ?? true
//                                                   ? 'Please enter category'
//                                                   : null,
//                                     ),
//                                   ],
//                                 ),

//                                 const SizedBox(height: 16),

//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Sub Category *',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xFF1E293B),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     AppTextField(
//                                       controller: subCategoryController,
//                                       hintText: 'Sub Category',
//                                       icon: Icons.subdirectory_arrow_right,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 24),

//                           Container(
//                             padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.04),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),

//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Tags',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 20 : 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 16),

//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Tags',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xFF1E293B),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     AppTextField(
//                                       controller: tagsController,
//                                       hintText: 'Tags (comma separated)',
//                                       icon: Icons.local_offer_outlined,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 Container(
//                   padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.04),
//                         blurRadius: 10,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Product Specifications',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 20 : 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),

//                           TextButton.icon(
//                             onPressed: addSpecification,
//                             icon: const Icon(Icons.add, size: 18),
//                             label: const Text('Add Specification'),
//                             style: TextButton.styleFrom(
//                               foregroundColor: const Color(0xFF7C3AED),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 16),

//                       if (_specifications.isEmpty)
//                         Container(
//                           padding: const EdgeInsets.all(32),
//                           alignment: Alignment.center,
//                           child: Column(
//                             children: [
//                               Icon(
//                                 Icons.settings_outlined,
//                                 size: 48,
//                                 color: Colors.grey.shade400,
//                               ),

//                               const SizedBox(height: 8),

//                               Text(
//                                 'No specifications added',
//                                 style: TextStyle(
//                                   color: Colors.grey.shade500,
//                                   fontSize: 14,
//                                 ),
//                               ),

//                               const SizedBox(height: 4),

//                               Text(
//                                 'Click "Add Specification" to add product features',
//                                 style: TextStyle(
//                                   color: Colors.grey.shade400,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       else
//                         ListView.separated(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: _specifications.length,
//                           separatorBuilder:
//                               (context, index) => const SizedBox(height: 12),
//                           itemBuilder: (context, index) {
//                             final spec = _specifications[index];

//                             return Row(
//                               children: [
//                                 Expanded(
//                                   child: AppTextField(
//                                     controller: TextEditingController(
//                                       text: spec.key,
//                                     ),
//                                     hintText: 'Specification Name',
//                                     icon: Icons.settings,
//                                     onFieldSubmitted:
//                                         (value) => updateSpecification(
//                                           index,
//                                           value,
//                                           spec.value,
//                                         ),
//                                   ),
//                                 ),

//                                 const SizedBox(width: 12),

//                                 Expanded(
//                                   child: AppTextField(
//                                     controller: TextEditingController(
//                                       text: spec.value,
//                                     ),
//                                     hintText: 'Specification Value',
//                                     icon: Icons.info_outline,
//                                     onFieldSubmitted:
//                                         (value) => updateSpecification(
//                                           index,
//                                           spec.key,
//                                           value,
//                                         ),
//                                   ),
//                                 ),

//                                 IconButton(
//                                   onPressed: () => removeSpecification(index),
//                                   icon: const Icon(
//                                     Icons.delete_outline,
//                                     color: Colors.red,
//                                   ),
//                                   tooltip: 'Remove',
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//   }

//   Widget _buildMainBannerPreview() {
//     final bool hasImage =
//         (isEditMode &&
//             (mainBannerImageFile != null || widget.product != null)) ||
//         (!isEditMode && mainBannerImageUrl != null);

//     if (hasImage) {
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child:
//                 isEditMode
//                     ? (mainBannerImageFile != null
//                         ? Image.file(
//                           mainBannerImageFile!,
//                           fit: BoxFit.cover,
//                           width: 560,
//                           height: 320,
//                         )
//                         : Image.network(
//                           widget.product!.mainBannerImage,
//                           fit: BoxFit.cover,
//                           width: 560,
//                           height: 320,
//                           errorBuilder:
//                               (context, error, stackTrace) => Container(
//                                 width: 560,
//                                 height: 320,
//                                 color: const Color(0xFFF8FAFC),
//                                 child: const Icon(
//                                   Icons.broken_image,
//                                   color: Colors.grey,
//                                   size: 40,
//                                 ),
//                               ),
//                         ))
//                     : Image.network(
//                       mainBannerImageUrl!,
//                       fit: BoxFit.cover,
//                       width: 560,
//                       height: 320,
//                     ),
//           ),
//           Positioned(
//             top: 8,
//             right: 8,
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (isEditMode) {
//                     if (mainBannerImageUrl != null) {
//                       html.Url.revokeObjectUrl(mainBannerImageUrl!);
//                     }
//                     mainBannerImageBytes = null;
//                     mainBannerImageName = null;
//                     mainBannerImageUrl = null;
//                     mainBannerImageFile = null;
//                   } else {
//                     if (mainBannerImageUrl != null) {
//                       html.Url.revokeObjectUrl(mainBannerImageUrl!);
//                     }
//                     mainBannerImageBytes = null;
//                     mainBannerImageName = null;
//                     mainBannerImageUrl = null;
//                   }
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(6.0),
//                   child: Icon(Icons.close, size: 16, color: Colors.black),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.cloud_upload, size: 40, color: Colors.grey.shade400),
//         const SizedBox(height: 8),
//         Text(
//           'Click to upload or drag and drop',
//           style: TextStyle(
//             color: Colors.grey.shade600,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         Text(
//           'SVG, PNG, JPG, or GIF (max. 800x400px)',
//           style: TextStyle(
//             color: Colors.grey.shade500,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
//           ),
//           child: Text(
//             "Select File",
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalImagesPreview() {
//     if (isEditMode) {
//       if (existingMultipleImages.isEmpty &&
//           newMultipleImageFiles.isEmpty &&
//           multipleImageUrls.isEmpty) {
//         return const SizedBox.shrink();
//       }

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (existingMultipleImages.isNotEmpty) ...[
//             const Text(
//               'Existing Images',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF64748B),
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 100,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: existingMultipleImages.length,
//                 itemBuilder:
//                     (context, index) => Container(
//                       width: 100,
//                       margin: const EdgeInsets.only(right: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               existingMultipleImages[index],
//                               fit: BoxFit.cover,
//                               width: 100,
//                               height: 100,
//                               errorBuilder:
//                                   (context, error, stackTrace) => Container(
//                                     color: const Color(0xFFF8FAFC),
//                                     child: const Icon(
//                                       Icons.broken_image,
//                                       color: Colors.grey,
//                                       size: 30,
//                                     ),
//                                   ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 4,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () => removeExistingImage(index),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.5),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.close,
//                                   size: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//               ),
//             ),
//             const SizedBox(height: 12),
//           ],
//           if (multipleImageUrls.isNotEmpty) ...[
//             const Text(
//               'New Images',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF64748B),
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 100,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: multipleImageUrls.length,
//                 itemBuilder:
//                     (context, index) => Container(
//                       width: 100,
//                       margin: const EdgeInsets.only(right: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               multipleImageUrls[index],
//                               fit: BoxFit.cover,
//                               width: 100,
//                               height: 100,
//                             ),
//                           ),
//                           Positioned(
//                             top: 4,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () => removeMultipleImage(index),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.5),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.close,
//                                   size: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//               ),
//             ),
//           ],
//         ],
//       );
//     }

//     if (multipleImageUrls.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return SizedBox(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: multipleImageUrls.length,
//         itemBuilder:
//             (context, index) => Container(
//               width: 100,
//               margin: const EdgeInsets.only(right: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       multipleImageUrls[index],
//                       fit: BoxFit.cover,
//                       width: 100,
//                       height: 100,
//                     ),
//                   ),
//                   Positioned(
//                     top: 4,
//                     right: 4,
//                     child: GestureDetector(
//                       onTap: () => removeMultipleImage(index),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.close,
//                           size: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/utils/common/custom_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:io';

class ProductFormWidget extends StatefulWidget {
  final ProductModel? product;
  final VoidCallback onSuccess;

  const ProductFormWidget({super.key, this.product, required this.onSuccess});

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController productNameController;
  late TextEditingController priceController;
  late TextEditingController discountPriceController;
  late TextEditingController stockController;
  late TextEditingController categoryController;
  late TextEditingController subCategoryController;
  late TextEditingController shortDescriptionController;
  late TextEditingController detailedDescriptionController;
  late TextEditingController tagsInputController;

  List<MapEntry<String, String>> _specifications = [];

  List<int>? mainBannerImageBytes;
  String? mainBannerImageName;
  String? mainBannerImageUrl;
  List<List<int>> multipleImagesBytes = [];
  List<String> multipleImageNames = [];
  List<String> multipleImageUrls = [];

  File? mainBannerImageFile;
  List<File> newMultipleImageFiles = [];
  List<String> existingMultipleImages = [];

  List<String> _selectedTags = [];
  final List<String> _suggestedTags = [
    'Hot',
    'New',
    'Popular',
    'Best Seller',
    'Featured',
    'Limited',
    'Trending',
    'Sale',
  ];

  final ImagePicker picker = ImagePicker();
  bool isLoading = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.product != null;

    if (isEditMode) {
      productNameController = TextEditingController(
        text: widget.product!.productName,
      );
      priceController = TextEditingController(
        text: widget.product!.price.toString(),
      );
      discountPriceController = TextEditingController(
        text: widget.product!.discountPrice.toString(),
      );
      stockController = TextEditingController(
        text: widget.product!.stock.toString(),
      );
      categoryController = TextEditingController(
        text: widget.product!.category,
      );
      subCategoryController = TextEditingController(
        text: widget.product!.subCategory,
      );
      shortDescriptionController = TextEditingController(
        text: widget.product!.shortDescription,
      );
      detailedDescriptionController = TextEditingController(
        text: widget.product!.detailedDescription,
      );
      tagsInputController = TextEditingController();

      _specifications =
          widget.product!.specifications.entries
              .map((entry) => MapEntry(entry.key, entry.value.toString()))
              .toList();
      _selectedTags = List.from(widget.product!.tags);

      existingMultipleImages = List.from(widget.product!.multipleImages);
    } else {
      productNameController = TextEditingController();
      priceController = TextEditingController();
      discountPriceController = TextEditingController();
      stockController = TextEditingController();
      categoryController = TextEditingController();
      subCategoryController = TextEditingController();
      shortDescriptionController = TextEditingController();
      detailedDescriptionController = TextEditingController();
      _selectedTags = [];
      tagsInputController = TextEditingController();
    }
  }

  @override
  void dispose() {
    if (!isEditMode && mainBannerImageUrl != null) {
      html.Url.revokeObjectUrl(mainBannerImageUrl!);
    }
    for (var url in multipleImageUrls) {
      html.Url.revokeObjectUrl(url);
    }
    productNameController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();
    categoryController.dispose();
    subCategoryController.dispose();
    shortDescriptionController.dispose();
    detailedDescriptionController.dispose();
    tagsInputController.dispose();
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
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      setState(() {
        mainBannerImageBytes = bytes;
        mainBannerImageName = pickedFile.name;
        mainBannerImageUrl = url;
      });
    }
  }

  Future<void> pickMultipleImages() async {
    final pickedFiles = await picker.pickMultiImage();

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
        multipleImageUrls.addAll(urls);
        multipleImagesBytes.addAll(bytesList);
        multipleImageNames.addAll(names);
      });
    }
  }

  void removeMultipleImage(int index) {
    if (!isEditMode) {
      html.Url.revokeObjectUrl(multipleImageUrls[index]);
    }

    setState(() {
      multipleImageUrls.removeAt(index);
      multipleImagesBytes.removeAt(index);
      multipleImageNames.removeAt(index);
    });
  }

  Future<void> pickEditMainBannerImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      setState(() {
        mainBannerImageBytes = bytes;
        mainBannerImageName = pickedFile.name;
        mainBannerImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> pickEditMultipleImages() async {
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final List<List<int>> bytesList = [];
      final List<String> names = [];
      final List<File> files = [];
      final List<String> urls = [];

      for (var file in pickedFiles) {
        final bytes = await file.readAsBytes();
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        urls.add(url);
        bytesList.add(bytes);
        names.add(file.name);
        files.add(File(file.path));
      }

      setState(() {
        multipleImageUrls.addAll(urls);
        multipleImagesBytes.addAll(bytesList);
        multipleImageNames.addAll(names);
        newMultipleImageFiles.addAll(files);
      });
    }
  }

  void removeExistingImage(int index) =>
      setState(() => existingMultipleImages.removeAt(index));

  void removeNewEditImage(int index) {
    if (index < multipleImageUrls.length) {
      html.Url.revokeObjectUrl(multipleImageUrls[index]);
      setState(() {
        multipleImageUrls.removeAt(index);
        multipleImagesBytes.removeAt(index);
        multipleImageNames.removeAt(index);
        newMultipleImageFiles.removeAt(index);
      });
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_selectedTags.contains(tag.trim())) {
      setState(() {
        _selectedTags.add(tag.trim());
      });
    }
    tagsInputController.clear();
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  void _addSuggestedTag(String tag) {
    if (!_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
      });
    }
  }

  Future<void> submitProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (!isEditMode && mainBannerImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a main banner image')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final tags = _selectedTags;

      final Map<String, dynamic> specifications = {};

      for (var spec in _specifications) {
        if (spec.key.trim().isNotEmpty && spec.value.trim().isNotEmpty) {
          specifications[spec.key.trim()] = spec.value.trim();
        }
      }

      final body = {
        if (isEditMode) 'productId': widget.product!.id,
        'productName': productNameController.text,
        'price': double.parse(priceController.text),
        'discountPrice': double.parse(discountPriceController.text),
        'stock': int.parse(stockController.text),
        'stockAvailable': int.parse(stockController.text) > 0,
        'category': categoryController.text,
        'subCategory': subCategoryController.text,
        'tags': _selectedTags,
        'shortDescription': shortDescriptionController.text,
        'detailedDescription': detailedDescriptionController.text,
        'specifications': specifications,
      };

      final productService = ProductService();

      if (isEditMode) {
        if (mainBannerImageBytes != null || multipleImagesBytes.isNotEmpty) {
          await productService.updateProductWithImageBytes(
            body: body,
            mainBannerImageBytes: mainBannerImageBytes,
            mainBannerImageName: mainBannerImageName,
            newMultipleImagesBytes:
                multipleImagesBytes.isNotEmpty ? multipleImagesBytes : null,
            newMultipleImagesNames:
                multipleImageNames.isNotEmpty ? multipleImageNames : null,
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
      } else {
        await productService.addProductWithImageBytes(
          body: body,
          mainBannerImageBytes: mainBannerImageBytes!,
          mainBannerImageName: mainBannerImageName!,
          multipleImagesBytes: multipleImagesBytes,
          multipleImagesNames: multipleImageNames,
        );

        if (mainBannerImageUrl != null) {
          html.Url.revokeObjectUrl(mainBannerImageUrl!);
        }

        for (var url in multipleImageUrls) {
          html.Url.revokeObjectUrl(url);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
              backgroundColor: Colors.green,
            ),
          );

          widget.onSuccess();
        }
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

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF7C3AED).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: HugeIcon(
                            icon:
                                isEditMode
                                    ? HugeIcons.strokeRoundedEdit01
                                    : HugeIcons.strokeRoundedDiamondPlus,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          isEditMode ? 'Edit Product' : 'Add New Product',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: widget.onSuccess,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: submitProduct,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isEditMode ? 'Save Changes' : 'Add Product',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Expanded(
                      flex: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Left side
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
                                  'Basic Information',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 20 : 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 16),
                                Text(
                                  'Product Name *',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                AppTextField(
                                  controller: productNameController,
                                  hintText: 'Product Name *',
                                  icon: Icons.shopping_bag_outlined,
                                  validator:
                                      (value) =>
                                          value?.isEmpty ?? true
                                              ? 'Please enter product name'
                                              : null,
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  'Short Description *',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: shortDescriptionController,
                                  cursorColor: Colors.deepPurple,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Short Description",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,

                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.6),
                                        width: 0.5,
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.6),
                                        width: 0.5,
                                      ),
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.6),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Detailed Description *',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: detailedDescriptionController,
                                  cursorColor: Colors.deepPurple,
                                  maxLines: 6,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Detailed Description",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,

                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.6),
                                        width: 0.5,
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.6),
                                        width: 0.5,
                                      ),
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.6),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

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
                                  'Product Images',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 20 : 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                const Text(
                                  'Main Banner Image *',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                GestureDetector(
                                  onTap:
                                      isEditMode
                                          ? pickEditMainBannerImage
                                          : pickMainBannerImage,
                                  child:
                                      !isEditMode
                                          ? DottedBorder(
                                            options:
                                                RoundedRectDottedBorderOptions(
                                                  radius: Radius.circular(12),
                                                  color: Colors.grey,
                                                  dashPattern: [6, 4],
                                                ),
                                            child: Container(
                                              width: double.infinity,
                                              height: 320,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8FAFC),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: _buildMainBannerPreview(),
                                            ),
                                          )
                                          : Container(
                                            width: 560,
                                            height: 320,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            child: _buildMainBannerPreview(),
                                          ),
                                ),

                                if (isEditMode && mainBannerImageFile == null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Tap to change image',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 24),
                                const Text(
                                  'Additional Images',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),

                                const SizedBox(height: 12),
                                DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: Radius.circular(12),
                                    dashPattern: const [6, 4],
                                    color: Colors.grey,
                                  ),

                                  child: InkWell(
                                    onTap:
                                        isEditMode
                                            ? pickEditMultipleImages
                                            : pickMultipleImages,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add_photo_alternate,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            isEditMode
                                                ? 'Add More Images'
                                                : 'Add Images',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                _buildAdditionalImagesPreview(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      flex: 40,
                      child: Column(
                        children: [
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
                                  'Pricing',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 20 : 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price *',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AppTextField(
                                      controller: priceController,
                                      hintText: 'Original Price (₹)',
                                      icon: Icons.currency_rupee,
                                      keyboardType: TextInputType.number,
                                      validator:
                                          (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Please enter price'
                                                  : null,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Discount Price *',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AppTextField(
                                      controller: discountPriceController,
                                      hintText:
                                          'Calculated Discounted Price (₹)',
                                      icon: Icons.local_offer_outlined,
                                      keyboardType: TextInputType.number,
                                      validator:
                                          (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Please enter discounted price'
                                                  : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),
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
                                  'Inventory & Categories',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 20 : 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            'Stock Quantity *',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          AppTextField(
                                            controller: stockController,
                                            hintText: 'Stock Quantity',
                                            icon: Icons.inventory_2_outlined,
                                            keyboardType: TextInputType.number,

                                            validator:
                                                (value) =>
                                                    value?.isEmpty ?? true
                                                        ? 'Please enter stock quantity'
                                                        : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category *',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AppTextField(
                                      controller: categoryController,
                                      hintText: 'Category',
                                      icon: Icons.category_outlined,
                                      validator:
                                          (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Please enter category'
                                                  : null,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sub Category *',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AppTextField(
                                      controller: subCategoryController,
                                      hintText: 'Sub Category',
                                      icon: Icons.subdirectory_arrow_right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          // Updated Tags Section
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
                                  'Tags',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 20 : 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Tag input field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add Tags',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: tagsInputController,
                                      onFieldSubmitted:
                                          (value) => _addTag(value),
                                      decoration: InputDecoration(
                                        hintText: 'Type a tag and press Enter',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.local_offer_outlined,
                                          color: Colors.grey,
                                        ),
                                        suffixIcon:
                                            tagsInputController.text.isNotEmpty
                                                ? IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      tagsInputController
                                                          .clear();
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.clear,
                                                    size: 18,
                                                  ),
                                                )
                                                : null,
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.6),
                                            width: 0.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.6),
                                            width: 0.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(0.6),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Selected tags display
                                if (_selectedTags.isNotEmpty) ...[
                                  Text(
                                    'Selected Tags',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        _selectedTags.map((tag) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3E8FF),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color(
                                                  0xFF7C3AED,
                                                ).withOpacity(0.3),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  tag,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF7C3AED),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                InkWell(
                                                  onTap: () => _removeTag(tag),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF7C3AED,
                                                      ).withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(
                                                        2.0,
                                                      ),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 12,
                                                        color: Color(
                                                          0xFF7C3AED,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Suggested tags
                                Text(
                                  'Suggested Tags',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      _suggestedTags.map((suggestedTag) {
                                        final isSelected = _selectedTags
                                            .contains(suggestedTag);
                                        return GestureDetector(
                                          onTap:
                                              () => _addSuggestedTag(
                                                suggestedTag,
                                              ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? const Color(
                                                        0xFF7C3AED,
                                                      ).withOpacity(0.1)
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? const Color(
                                                          0xFF7C3AED,
                                                        )
                                                        : Colors.grey
                                                            .withOpacity(0.4),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Text(
                                              suggestedTag,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    isSelected
                                                        ? const Color(
                                                          0xFF7C3AED,
                                                        )
                                                        : Colors.grey.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product Specifications',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
                              (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final spec = _specifications[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Specification Name',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        initialValue: spec.key,
                                        decoration: InputDecoration(
                                          hintText: 'e.g., Brand, Color, Size',
                                          hintStyle: const TextStyle(
                                            fontSize: 13,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
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
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Specification Value',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        initialValue: spec.value,
                                        decoration: InputDecoration(
                                          hintText: 'e.g., Nike, Black, XL',
                                          hintStyle: const TextStyle(
                                            fontSize: 13,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
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
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => removeSpecification(index),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Remove',
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildMainBannerPreview() {
    final bool hasImage =
        (isEditMode &&
            (mainBannerImageFile != null || widget.product != null)) ||
        (!isEditMode && mainBannerImageUrl != null);

    if (hasImage) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                isEditMode
                    ? (mainBannerImageFile != null
                        ? Image.file(
                          mainBannerImageFile!,
                          fit: BoxFit.cover,
                          width: 560,
                          height: 320,
                        )
                        : Image.network(
                          widget.product!.mainBannerImage,
                          fit: BoxFit.cover,
                          width: 560,
                          height: 320,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 560,
                                height: 320,
                                color: const Color(0xFFF8FAFC),
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                        ))
                    : Image.network(
                      mainBannerImageUrl!,
                      fit: BoxFit.cover,
                      width: 560,
                      height: 320,
                    ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isEditMode) {
                    if (mainBannerImageUrl != null) {
                      html.Url.revokeObjectUrl(mainBannerImageUrl!);
                    }
                    mainBannerImageBytes = null;
                    mainBannerImageName = null;
                    mainBannerImageUrl = null;
                    mainBannerImageFile = null;
                  } else {
                    if (mainBannerImageUrl != null) {
                      html.Url.revokeObjectUrl(mainBannerImageUrl!);
                    }
                    mainBannerImageBytes = null;
                    mainBannerImageName = null;
                    mainBannerImageUrl = null;
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.close, size: 16, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          'Click to Upload Images',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'SVG, PNG, JPG, or GIF (max. 800x400px)',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
          ),
          child: Text(
            "Select File",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalImagesPreview() {
    if (isEditMode) {
      if (existingMultipleImages.isEmpty &&
          newMultipleImageFiles.isEmpty &&
          multipleImageUrls.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        border: Border.all(color: Colors.grey.shade300),
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
                                  (context, error, stackTrace) => Container(
                                    color: const Color(0xFFF8FAFC),
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
                              onTap: () => removeExistingImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
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
          if (multipleImageUrls.isNotEmpty) ...[
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
                itemCount: multipleImageUrls.length,
                itemBuilder:
                    (context, index) => Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              multipleImageUrls[index],
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => removeMultipleImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
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
        ],
      );
    }

    if (multipleImageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: multipleImageUrls.length,
        itemBuilder:
            (context, index) => Container(
              width: 100,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      multipleImageUrls[index],
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => removeMultipleImage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
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
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/seller/products/bloc/add_product_bloc.dart';
import 'package:app_frontend/features/seller/products/bloc/add_product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/add_product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:app_frontend/utils/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddProductBloc(ProductService()),
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

  final productNameController = TextEditingController();

  final bannerController = TextEditingController();

  final image1Controller = TextEditingController();

  final image2Controller = TextEditingController();

  final image3Controller = TextEditingController();

  final priceController = TextEditingController();

  final stockController = TextEditingController();

  final categoryController = TextEditingController();

  final subCategoryController = TextEditingController();

  final shortDescController = TextEditingController();

  final detailDescController = TextEditingController();

  final specControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void submitProduct() {
    final body = {
      "productName": productNameController.text.trim(),

      "mainBannerImage": bannerController.text.trim(),

      "multipleImages": [
        image1Controller.text.trim(),
        image2Controller.text.trim(),
        image3Controller.text.trim(),
      ],

      "price": double.parse(priceController.text.trim()),

      "discountPrice": 999,

      "stock": int.parse(stockController.text.trim()),

      "category": categoryController.text.trim(),

      "subCategory": subCategoryController.text.trim(),

      "tags": ["hot"],

      "shortDescription": shortDescController.text.trim(),

      "detailedDescription": detailDescController.text.trim(),

      "specifications": {
        "brand": specControllers[0].text,
        "color": specControllers[1].text,
        "storage": specControllers[2].text,
        "ram": specControllers[3].text,
        "display": specControllers[4].text,
      },
    };

    context.read<AddProductBloc>().add(SubmitProductEvent(body));
  }

  Widget customField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 52,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13),

        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),

          prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade600),

          suffixIcon: Icon(Icons.edit, size: 16, color: Colors.grey.shade500),

          hintText: hint,

          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ),
    );
  }

  Widget imageUploadBox({
    required double width,
    required double height,
    required String text,
  }) {
    return Container(
      width: width,
      height: height,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.amber.shade200,
          style: BorderStyle.solid,
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: Colors.amber.shade700, size: 28),

          const SizedBox(height: 8),

          Text(
            text,
            style: TextStyle(
              color: Colors.amber.shade700,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget specField(TextEditingController controller, String hint) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(14),
      ),

      child: TextFormField(
        controller: controller,

        decoration: InputDecoration(
          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 14),

          prefixIcon: Icon(
            Icons.widgets_outlined,
            size: 18,
            color: Colors.grey.shade700,
          ),

          suffixIcon: Icon(Icons.edit, size: 16, color: Colors.grey.shade500),

          hintText: hint,

          hintStyle: const TextStyle(fontSize: 13),
        ),
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
        onMenuTap: () {
          Scaffold.of(context).openDrawer();
        },
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }

            if (state is AddProductError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),

              child: Stack(
                children: [
                  RedCorner(),
                  BlueCenter(),
                  YellowCorner(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// MAIN CONTAINER
                      Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),

                        child: Form(
                          key: formKey,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              /// MAIN BANNER
                              Text(
                                "Main Banner Image",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 10),

                              imageUploadBox(
                                width: double.infinity,
                                height: 120,
                                text: "Upload Main Banner",
                              ),

                              const SizedBox(height: 22),

                              /// ADDITIONAL IMAGES
                              Text(
                                "Additional Images",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  imageUploadBox(
                                    width: 88,
                                    height: 88,
                                    text: "",
                                  ),

                                  imageUploadBox(
                                    width: 88,
                                    height: 88,
                                    text: "",
                                  ),

                                  imageUploadBox(
                                    width: 88,
                                    height: 88,
                                    text: "",
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              customField(
                                controller: productNameController,
                                hint: "iPhone 15 Pro",
                                icon: Icons.phone_iphone,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: customField(
                                      controller: priceController,
                                      hint: "999.99",
                                      icon: Icons.attach_money,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: customField(
                                      controller: stockController,
                                      hint: "50",
                                      icon: Icons.inventory_2_outlined,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: customField(
                                      controller: categoryController,
                                      hint: "Electronics",
                                      icon: Icons.grid_view_rounded,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: customField(
                                      controller: subCategoryController,
                                      hint: "Smartphones",
                                      icon: Icons.layers_outlined,
                                    ),
                                  ),
                                ],
                              ),

                              customField(
                                controller: shortDescController,
                                hint: "Latest Apple iPhone 15 Pro",
                                icon: Icons.description_outlined,
                              ),

                              Container(
                                height: 120,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),

                                decoration: BoxDecoration(
                                  color: const Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(16),
                                ),

                                child: TextFormField(
                                  controller: detailDescController,
                                  maxLines: 5,

                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        "The iPhone 15 Pro features a titanium design, A17 Pro chip, and advanced camera system.",
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              /// SPECIFICATIONS
                              Container(
                                padding: const EdgeInsets.all(16),

                                decoration: BoxDecoration(
                                  color: const Color(0xffFAFAFA),
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.auto_awesome,
                                          size: 18,
                                          color: Colors.amber.shade700,
                                        ),

                                        const SizedBox(width: 6),

                                        const Text(
                                          "Specifications",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    specField(specControllers[0], "Apple"),

                                    specField(
                                      specControllers[1],
                                      "Natural Titanium",
                                    ),

                                    specField(specControllers[2], "256GB"),

                                    specField(specControllers[3], "8GB"),

                                    specField(
                                      specControllers[4],
                                      "6.1-inch Super Retina XDR",
                                    ),

                                    Container(
                                      height: 48,
                                      width: double.infinity,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),

                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                      ),

                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [
                                          Icon(Icons.add, size: 18),

                                          SizedBox(width: 6),

                                          Text("Add Specification"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              /// BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 58,

                                child: ElevatedButton(
                                  onPressed:
                                      state is AddProductLoading
                                          ? null
                                          : submitProduct,

                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xffFDBB12),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),

                                  child:
                                      state is AddProductLoading
                                          ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                          : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,

                                            children: [
                                              Text(
                                                "Publish Product",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                              ),

                                              SizedBox(width: 10),

                                              Icon(
                                                Icons.check,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                            ],
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
          },
        ),
      ),
    );
  }
}

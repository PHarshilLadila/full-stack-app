import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductImagePreview extends StatefulWidget {
  final ProductModel product;

  const ProductImagePreview({super.key, required this.product});

  @override
  State<ProductImagePreview> createState() => _ProductImagePreviewState();
}

class _ProductImagePreviewState extends State<ProductImagePreview> {
  late String selectedImage;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.product.mainBannerImage;
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [
      widget.product.mainBannerImage,
      ...widget.product.multipleImages,
    ];

    final screenWidth = MediaQuery.of(context).size.width;

    /// RESPONSIVE BREAKPOINTS
    final bool isSmallTablet = screenWidth < 800;
    final bool isTablet = screenWidth >= 800 && screenWidth < 1024;
    final bool isSmallDesktop = screenWidth >= 1024 && screenWidth < 1400;
    final bool isBigDesktop = screenWidth >= 1400;

    /// RESPONSIVE SIZES
    double previewWidth = 320;
    double previewHeight = 260;
    double thumbnailSize = 70;
    double containerPadding = 16;

    if (isSmallTablet) {
      previewWidth = screenWidth * 0.85;
      previewHeight = 300;
      thumbnailSize = 70;
      containerPadding = 14;
    } else if (isTablet) {
      previewWidth = 520;
      previewHeight = 360;
      thumbnailSize = 80;
      containerPadding = 18;
    } else if (isSmallDesktop) {
      previewWidth = 620;
      previewHeight = 420;
      thumbnailSize = 85;
      containerPadding = 22;
    } else if (isBigDesktop) {
      previewWidth = 720;
      previewHeight = 520;
      thumbnailSize = 90;
      containerPadding = 24;
    }

    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          /// MAIN IMAGE
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                selectedImage,
                width: previewWidth,
                height: previewHeight,
                fit: BoxFit.fill,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: previewWidth,
                      height: previewHeight,
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

          const SizedBox(height: 18),

          /// THUMBNAIL IMAGES
          SizedBox(
            height: thumbnailSize + 10,
            width: previewWidth,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),

              itemBuilder: (context, index) {
                final image = allImages[index];

                final isSelected = selectedImage == image;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImage = image;
                    });
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(2),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),

                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),

                      child: Image.network(
                        image,
                        width: thumbnailSize,
                        height: thumbnailSize,
                        fit: BoxFit.cover,

                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: thumbnailSize,
                              height: thumbnailSize,
                              color: const Color(0xFFF8FAFC),
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

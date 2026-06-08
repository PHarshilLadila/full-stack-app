import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentlyViewedSection extends StatelessWidget {
  const RecentlyViewedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        "brand": "AND",
        "name": "Flared Palazzo Pants",
        "price": "₹1,299",
        "image":
            "https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=600",
      },
      {
        "brand": "Clarks",
        "name": "Suede Chelsea Boots",
        "price": "₹4,999",
        "image":
            "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600",
      },
      {
        "brand": "Bewakoof",
        "name": "Crew Neck Sweatshirt",
        "price": "₹799",
        "image":
            "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600",
      },
      {
        "brand": "FabAlley",
        "name": "Bohemian Maxi Dress",
        "price": "₹1,899",
        "image":
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600",
      },
      {
        "brand": "Roadster",
        "name": "Classic Denim Jacket",
        "price": "₹1,599",
        "image":
            "https://images.unsplash.com/photo-1542272604-787c3835535d?w=600",
      },
    ];

    return Container(
      width: double.infinity,
      color: Color(0xfff1f5f9),
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Activity",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff4F46E5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Recently Viewed",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff111827),
                    ),
                  ),
                ],
              ),

              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      "View History",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff4F46E5),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xff4F46E5),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          /// PRODUCT GRID
          Row(
            children:
                products.map((product) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: RecentlyViewedCard(
                        brand: product["brand"]!,
                        name: product["name"]!,
                        price: product["price"]!,
                        image: product["image"]!,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class RecentlyViewedCard extends StatelessWidget {
  final String brand;
  final String name;
  final String price;
  final String image;

  const RecentlyViewedCard({
    super.key,
    required this.brand,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 325,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child: Image.network(image, fit: BoxFit.cover),
            ),
          ),

          /// CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xff9CA3AF),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff111827),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff111827),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xffEEF2FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                          color: Color(0xff4F46E5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

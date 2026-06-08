import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BestSellersSection extends StatelessWidget {
  const BestSellersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        "rank": "01",
        "brand": "Marks & Spencer",
        "name": "Ribbed Turtleneck",
        "rating": "4.9 (847)",
        "price": "₹1,899",
        "oldPrice": "₹2,599",
        "sold": "2.4k sold",
        "image":
            "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=300",
      },
      {
        "rank": "02",
        "brand": "Tommy Hilfiger",
        "name": "Oxford Button-Down",
        "rating": "4.8 (631)",
        "price": "₹2,499",
        "oldPrice": "₹3,299",
        "sold": "1.9k sold",
        "image":
            "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=300",
      },
      {
        "rank": "03",
        "brand": "Biba",
        "name": "Ethnic Kurta Set",
        "rating": "4.7 (528)",
        "price": "₹1,599",
        "oldPrice": "₹2,299",
        "sold": "1.7k sold",
        "image":
            "https://images.unsplash.com/photo-1583391733981-8498402d1c8a?w=300",
      },
      {
        "rank": "04",
        "brand": "Fossil",
        "name": "Leather Bifold Wallet",
        "rating": "4.6 (412)",
        "price": "₹1,299",
        "oldPrice": "₹1,999",
        "sold": "1.2k sold",
        "image":
            "https://images.unsplash.com/photo-1627123424574-724758594e93?w=300",
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      color: const Color(0xffF5F7FA),
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
                    "Top Picks",
                    style: GoogleFonts.inter(
                      color: const Color(0xff4F46E5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Best Sellers",
                    style: GoogleFonts.inter(
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
                      "View All",
                      style: GoogleFonts.inter(
                        color: const Color(0xff4F46E5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
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

          /// LIST
          Column(
            children:
                products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// RANK
                          SizedBox(
                            width: 60,
                            child: Text(
                              product["rank"]!,
                              style: GoogleFonts.inter(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xffD6DCE5),
                              ),
                            ),
                          ),

                          /// IMAGE
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(product["image"]!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(width: 18),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product["brand"]!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xff9CA3AF),
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  product["name"]!,
                                  style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff111827),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xffF59E0B),
                                      size: 14,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xffF59E0B),
                                      size: 14,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xffF59E0B),
                                      size: 14,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xffF59E0B),
                                      size: 14,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xffF59E0B),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      product["rating"]!,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xff6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// PRICE
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    product["price"]!,
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff111827),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    product["oldPrice"]!,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      color: const Color(0xff9CA3AF),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              Text(
                                product["sold"]!,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xff10B981),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),

                              SizedBox(
                                height: 35,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xff4F46E5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Add to Cart",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// BUTTON
                        ],
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

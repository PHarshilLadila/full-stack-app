import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoBannerSection extends StatelessWidget {
  const PromoBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF5F7FA),
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 50,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _bannerCard(
                  image:
                      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
                  tag: 'NEW ARRIVAL',
                  title: 'Summer Essentials\nFor Her',
                  buttonText: 'Shop Women',
                  buttonColor: Colors.white,
                  buttonTextColor: Colors.black,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _bannerCard(
                  image:
                      'https://images.unsplash.com/photo-1507679799987-c73779587ccf',
                  tag: 'EXCLUSIVE',
                  title: 'Street Style\nFor Him',
                  buttonText: 'Shop Men',
                  buttonColor: const Color(0xff4F46E5),
                  buttonTextColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 36),

          Container(
            height: 82,
            decoration: BoxDecoration(
              color: const Color(0xff071330),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: const [
                Expanded(
                  child: FeatureItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Free Shipping',
                    subtitle: 'On orders above ₹999',
                  ),
                ),
                Expanded(
                  child: FeatureItem(
                    icon: Icons.refresh,
                    title: 'Easy Returns',
                    subtitle: '30-day hassle-free returns',
                  ),
                ),
                Expanded(
                  child: FeatureItem(
                    icon: Icons.shield_outlined,
                    title: 'Secure Payments',
                    subtitle: '100% secure & encrypted',
                  ),
                ),
                Expanded(
                  child: FeatureItem(
                    icon: Icons.headset_mic_outlined,
                    title: '24/7 Support',
                    subtitle: 'Always here to help',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _bannerCard({
    required String image,
    required String tag,
    required String title,
    required String buttonText,
    required Color buttonColor,
    required Color buttonTextColor,
  }) {
    return Container(
      height: 255,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(.55),
              Colors.black.withOpacity(.10),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tag,
              style: GoogleFonts.inter(
                color: const Color(0xffFF9D00),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 42,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.inter(
                      color: buttonTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xff4F46E5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
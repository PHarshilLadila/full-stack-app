import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CommonFooter extends StatelessWidget {
  const CommonFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final isTablet =
        MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width < 1200;

    return Container(
      color: Color(0xFF0F172A),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal:
            isMobile
                ? 20
                : isTablet
                ? 40
                : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Footer Content
          if (isMobile)
            _buildMobileFooter()
          else if (isTablet)
            _buildTabletFooter()
          else
            _buildDesktopFooter(),

          const SizedBox(height: 48),

          // Divider
          Divider(color: Colors.grey.shade800, height: 1),

          const SizedBox(height: 24),

          // Bottom Bar
          _buildBottomBar(isMobile),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Column
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "V",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Velmora',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Your destination for premium fashion,\nbeauty, and lifestyle. Discover the best\nbrands, curated just for you.',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              // Social Icons
              Row(
                children: [
                  _buildSocialIcon(HugeIcons.strokeRoundedFacebook01),
                  const SizedBox(width: 12),
                  _buildSocialIcon(HugeIcons.strokeRoundedInstagram),
                  const SizedBox(width: 12),
                  _buildSocialIcon(HugeIcons.strokeRoundedTwitter),
                  const SizedBox(width: 12),
                  _buildSocialIcon(HugeIcons.strokeRoundedYoutube),
                ],
              ),
            ],
          ),
        ),

        // Company Column
        Expanded(
          child: _FooterColumn(
            title: 'Company',
            items: const ['About Us', 'Careers', 'Press', 'Blog', 'Investors'],
          ),
        ),

        // Help Column
        Expanded(
          child: _FooterColumn(
            title: 'Help',
            items: const [
              'Customer Support',
              'Track Order',
              'Returns & Exchanges',
              'FAQs',
              'Accessibility',
            ],
          ),
        ),

        // Legal Column
        Expanded(
          child: _FooterColumn(
            title: 'Legal',
            items: const [
              'Privacy Policy',
              'Terms of Service',
              'Cookie Policy',
              'Size Guide',
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletFooter() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VELMORA',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your destination for premium fashion, beauty, and lifestyle. Discover the best brands, curated just for you.',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Social Icons
                  Row(
                    children: [
                      _buildSocialIcon(HugeIcons.strokeRoundedFacebook01),
                      const SizedBox(width: 12),
                      _buildSocialIcon(HugeIcons.strokeRoundedInstagram),
                      const SizedBox(width: 12),
                      _buildSocialIcon(HugeIcons.strokeRoundedTwitter),
                    ],
                  ),
                ],
              ),
            ),

            // Company Column
            Expanded(
              child: _FooterColumn(
                title: 'Company',
                items: const [
                  'About Us',
                  'Careers',
                  'Press',
                  'Blog',
                  'Investors',
                ],
              ),
            ),

            // Help Column
            Expanded(
              child: _FooterColumn(
                title: 'Help',
                items: const [
                  'Customer Support',
                  'Track Order',
                  'Returns & Exchanges',
                  'FAQs',
                  'Size Guide',
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: _FooterColumn(
                title: 'Legal',
                items: const [
                  'Privacy Policy',
                  'Terms of Service',
                  'Cookie Policy',
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Section
        Center(
          child: Column(
            children: [
              Text(
                'VELMORA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your destination for premium fashion,\nbeauty, and lifestyle. Discover the best\nbrands, curated just for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              // Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(HugeIcons.strokeRoundedFacebook01),
                  const SizedBox(width: 16),
                  _buildSocialIcon(HugeIcons.strokeRoundedInstagram),
                  const SizedBox(width: 16),
                  _buildSocialIcon(HugeIcons.strokeRoundedTwitter),
                  const SizedBox(width: 16),
                  _buildSocialIcon(HugeIcons.strokeRoundedYoutube),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Company Section
        _FooterColumn(
          title: 'Company',
          items: const ['About Us', 'Careers', 'Press', 'Blog', 'Investors'],
        ),

        const SizedBox(height: 32),

        // Help Section
        _FooterColumn(
          title: 'Help',
          items: const [
            'Customer Support',
            'Track Order',
            'Returns & Exchanges',
            'FAQs',
            'Accessibility',
            'Size Guide',
          ],
        ),

        const SizedBox(height: 32),

        // Legal Section
        _FooterColumn(
          title: 'Legal',
          items: const ['Privacy Policy', 'Terms of Service', 'Cookie Policy'],
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isMobile) {
    return Column(
      children: [
        if (isMobile) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '© 2026 Velmora. All rights reserved.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 Velmora. All rights reserved.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              Row(
                children: [
                  _buildFooterLink('Privacy Policy'),
                  const SizedBox(width: 24),
                  _buildFooterLink('Terms of Service'),
                  const SizedBox(width: 24),
                  _buildFooterLink('Cookie Policy'),
                  const SizedBox(width: 24),
                  _buildFooterLink('Sitemap'),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {
        // Handle navigation
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
      ),
    );
  }

  Widget _buildSocialIcon(List<List<dynamic>> icon) {
    return InkWell(
      onTap: () {
        // Handle social media navigation
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: HugeIcon(icon: icon, size: 18, color: Colors.grey.shade400),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 18 : 16,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GestureDetector(
              onTap: () {
                // Handle footer item navigation
              },
              child: Text(
                item,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: isMobile ? 14 : 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

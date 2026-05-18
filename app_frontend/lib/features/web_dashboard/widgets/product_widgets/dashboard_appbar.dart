// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';

import 'package:app_frontend/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:app_frontend/features/seller/seller_profile/view/seller_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatefulWidget {
  final String title;
  final String subtitle;

  const CommonAppBar({super.key, required this.title, required this.subtitle});

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  late UserBloc _userBloc;
  Map<String, dynamic>? sellerStats;

  // Current display values
  String _currentTitle = '';
  String _currentSubtitle = '';

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userService: UserService());
    _currentTitle = widget.title;
    _currentSubtitle = widget.subtitle;
    _loadUserData();
    _loadSellerStats();
  }

  @override
  void didUpdateWidget(covariant CommonAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update title and subtitle when widget changes (screen changes)
    if (oldWidget.title != widget.title ||
        oldWidget.subtitle != widget.subtitle) {
      setState(() {
        _currentTitle = widget.title;
        _currentSubtitle = widget.subtitle;
      });
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      _userBloc.add(FetchUserProfile(token));
    }
  }

  Future<void> _loadSellerStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      try {
        final stats = await UserService().getSellerStats(token);
        setState(() {
          sellerStats = stats;
        });
      } catch (e) {
        debugPrint("Error loading seller stats: $e");
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_id');

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          String userName = "Seller";
          String userEmail = "seller@velmora.com";
          String profileImage = "";
          String userRole = "seller";

          if (state is UserLoaded) {
            userName = state.user.fullName;
            userEmail = state.user.email;
            profileImage = state.user.profileImage ?? "";
            userRole = state.user.role;
            log("Profile image loaded: $profileImage");
          }

          String displayInitial =
              userName.isNotEmpty ? userName[0].toUpperCase() : 'S';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentSubtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search, color: Color(0xFF64748B)),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Profile Avatar with Popup Menu
                    GestureDetector(
                      onTap: () {
                        _showProfileMenu(
                          context,
                          userName,
                          userEmail,
                          profileImage,
                          userRole,
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _buildProfileAvatar(
                          profileImage,
                          displayInitial,
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
    );
  }

  Widget _buildProfileAvatar(String profileImageUrl, String displayInitial) {
    final bool hasValidImage =
        profileImageUrl.isNotEmpty &&
        (profileImageUrl.startsWith('http') ||
            profileImageUrl.startsWith('https'));

    if (hasValidImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          profileImageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF7C3AED),
                  ),
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            log("Image loading error: $error");
            return Center(
              child: Text(
                displayInitial,
                style: const TextStyle(
                  color: Color(0xFF7C3AED),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text(
          displayInitial,
          style: const TextStyle(
            color: Color(0xFF7C3AED),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }
  }

  void _showProfileMenu(
    BuildContext context,
    String userName,
    String userEmail,
    String profileImageUrl,
    String userRole,
  ) {
    String displayName = userName;
    String displayEmail = userEmail;
    String displayInitial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'S';

    final bool hasValidImage =
        profileImageUrl.isNotEmpty &&
        (profileImageUrl.startsWith('http') ||
            profileImageUrl.startsWith('https'));

    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      shadowColor: Colors.black26,
      color: Colors.white,
      items: [
        /// PROFILE HEADER
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFFC084FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                /// PROFILE IMAGE
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child:
                      hasValidImage
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              profileImageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    displayInitial,
                                    style: const TextStyle(
                                      color: Color(0xFF7C3AED),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          : Center(
                            child: Text(
                              displayInitial,
                              style: const TextStyle(
                                color: Color(0xFF7C3AED),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                ),
                const SizedBox(width: 12),

                /// USER INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayEmail,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          userRole.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),

        const PopupMenuItem<String>(
          value: 'profile',
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: Color(0xFF475569)),
              SizedBox(width: 12),
              Text(
                'View Profile',
                style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
              ),
              Spacer(),
              Text(
                '⌘P',
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),

        const PopupMenuItem<String>(
          value: 'orders',
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 20,
                color: Color(0xFF475569),
              ),
              SizedBox(width: 12),
              Text(
                'My Orders',
                style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
              ),
              Spacer(),
              Text(
                '⌘O',
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),

        const PopupMenuItem<String>(
          value: 'settings',
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 20, color: Color(0xFF475569)),
              SizedBox(width: 12),
              Text(
                'Account Settings',
                style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
              ),
              Spacer(),
              Text(
                '⌘S',
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),

        const PopupMenuItem<String>(
          value: 'billing',
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: 20,
                color: Color(0xFF475569),
              ),
              SizedBox(width: 12),
              Text(
                'Billing & Payments',
                style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem<String>(
          value: 'logout',
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: Color(0xFFEF4444)),
              SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                '⌘L',
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleMenuItemClick(context, value);
      }
    });
  }

  void _handleMenuItemClick(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SellerProfileScreen()),
        );
        break;
      case 'orders':
        _showSnackbar(context, 'Opening My Orders...');
        break;
      case 'settings':
        _showSnackbar(context, 'Opening Account Settings...');
        break;
      case 'billing':
        _showSnackbar(context, 'Opening Billing & Payments...');
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout, color: Color(0xFFEF4444), size: 28),
              SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }
}

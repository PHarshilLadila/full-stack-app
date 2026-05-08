// lib/features/home/view/home_screen.dart

// ignore_for_file: deprecated_member_use

import 'package:app_frontend/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:app_frontend/features/customer/profile/view/edit_user_screen.dart';
import 'package:app_frontend/features/customer/profile/view/full_screen_profile_image.dart';
import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userService: UserService());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      _userBloc.add(FetchUserProfile(token));
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            AppBackround(),
            SafeArea(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFFFFD700)),
                          SizedBox(height: 20),
                          Text(
                            'Loading profile...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  } else if (state is UserLoaded) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                color:
                                    Colors
                                        .transparent, // Important: makes background transparent
                                shape: const CircleBorder(),
                                clipBehavior:
                                    Clip.hardEdge, // Clips the ripple effect to circle
                                child: InkWell(
                                  onTap: () {
                                    _userBloc = UserBloc(
                                      userService: UserService(),
                                    );
                                    _loadUserData();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.6,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.home,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.settings_outlined,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Profile Icon
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => FullScreenProfileImage(
                                        profileImage:
                                            (state.user.profileImage != null &&
                                                    state
                                                        .user
                                                        .profileImage!
                                                        .isNotEmpty)
                                                ? state.user.profileImage!
                                                : "https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&o=5&pid=1.9",
                                      ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(
                                (state.user.profileImage != null &&
                                        state.user.profileImage!.isNotEmpty)
                                    ? state.user.profileImage!
                                    : "https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&o=5&pid=1.9",
                                width: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Welcome Text
                          Text(
                            state.user.fullName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'You are successfully logged in.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 18),
                          // User Details Card
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                infoRow(
                                  icon: Icons.person_outline,
                                  label: 'Full Name',
                                  value: state.user.fullName,
                                ),
                                SizedBox(height: 8),
                                infoRow(
                                  icon: Icons.alternate_email,
                                  label: 'Username',
                                  value: state.user.username,
                                ),
                                SizedBox(height: 8),

                                infoRow(
                                  icon: Icons.email_outlined,
                                  label: 'Email',
                                  value: state.user.email,
                                ),
                                SizedBox(height: 8),

                                infoRow(
                                  icon: Icons.call_outlined,
                                  label: 'Mobile',
                                  value: state.user.mobile,
                                ),
                                SizedBox(height: 8),

                                infoRow(
                                  icon: Icons.calendar_today,
                                  label: 'Member Since',
                                  value: _formatDate(state.user.createdAt),
                                ),
                                SizedBox(height: 8),

                                SizedBox(
                                  height: 26,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditUserScreen(
                                                user: state.user,
                                              ),
                                        ),
                                      );
                                      if (result == true) {
                                        // Refresh user data after update
                                        final prefs =
                                            await SharedPreferences.getInstance();
                                        final token = prefs.getString(
                                          'auth_token',
                                        );
                                        if (token != null) {
                                          _userBloc.add(
                                            FetchUserProfile(token),
                                          );
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.amber,
                                      ),
                                      padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 0,
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    label: const Text(
                                      "Edit Details",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is UserError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.error}',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _loadUserData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD700),
                              foregroundColor: Colors.black87,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      'Press Logout to exit',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }
}

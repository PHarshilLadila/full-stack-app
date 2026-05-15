// // ignore_for_file: deprecated_member_use

// import 'dart:ui';

// import 'package:app_frontend/features/customer/profile/bloc/user_bloc.dart';
// import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
// import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
// import 'package:app_frontend/features/customer/profile/service/user_service.dart';
// import 'package:app_frontend/features/customer/profile/view/edit_user_screen.dart';
// import 'package:app_frontend/features/customer/profile/view/full_screen_profile_image.dart';
// import 'package:app_frontend/utils/common/app_backround.dart';
// import 'package:app_frontend/utils/common/custom_appbar.dart';
// import 'package:app_frontend/utils/common/custom_loader.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CustomerProfileScreen extends StatefulWidget {
//   const CustomerProfileScreen({super.key});

//   @override
//   State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
// }

// class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
//   late UserBloc _userBloc;

//   @override
//   void initState() {
//     super.initState();
//     _userBloc = UserBloc(userService: UserService());
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token != null) {
//       _userBloc.add(FetchUserProfile(token));
//     }
//   }

//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('user_role');
//     await prefs.remove('user_id');

//     if (mounted) {
//       Navigator.pushReplacementNamed(context, '/auth');
//     }
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _userBloc,
//       child: Scaffold(
//         key: _scaffoldKey,
//         extendBodyBehindAppBar: true,
//         backgroundColor: Colors.white,
//         drawer: SafeArea(
//           child: Drawer(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(24),
//                 bottomRight: Radius.circular(24),
//               ),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(24),
//                       bottomRight: Radius.circular(24),
//                     ),
//                     border: Border.all(color: Colors.white.withOpacity(0.2)),
//                   ),
//                   child: BlocBuilder<UserBloc, UserState>(
//                     builder: (context, state) {
//                       String userName = "Customer";
//                       if (state is UserLoaded) {
//                         userName = state.user.fullName.split(' ')[0];
//                       }

//                       return Column(
//                         children: [
//                           const SizedBox(height: 40),
//                           CircleAvatar(
//                             radius: 40,
//                             backgroundColor: Colors.amber,
//                             child: const Icon(
//                               Icons.person,
//                               size: 40,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             userName,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.amber,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: const Text(
//                               "Customer",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 30),
//                           ListTile(
//                             leading: const Icon(
//                               Icons.home,
//                               color: Colors.black,
//                             ),
//                             title: const Text(
//                               "Home",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                           ListTile(
//                             leading: const Icon(
//                               Icons.person,
//                               color: Colors.black,
//                             ),
//                             title: const Text(
//                               "Profile",
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                           const Divider(color: Colors.grey),
//                           ListTile(
//                             leading: const Icon(
//                               Icons.logout,
//                               color: Colors.red,
//                             ),
//                             title: const Text(
//                               "Logout",
//                               style: TextStyle(color: Colors.red),
//                             ),
//                             onTap: _logout,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         appBar: CustomAppBar(
//           title: "My Profile",
//           onMenuTap: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//           onNotificationTap: () {},
//           onFavouriteTap: () {},
//           showMenu: true,
//           showNotification: true,
//           showFavourite: true,
//         ),
//         body: Stack(
//           children: [
//             const YellowCorner(),
//             const BlueCenter(),
//             const RedCorner(),
//             SafeArea(
//               child: BlocBuilder<UserBloc, UserState>(
//                 builder: (context, state) {
//                   if (state is UserLoading) {
//                     return const CustomLoader(loadingPageName: 'Profile');
//                   } else if (state is UserLoaded) {
//                     return SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               children: [
//                                 const SizedBox(height: 40),
//                                 // Profile Image
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder:
//                                             (context) => FullScreenProfileImage(
//                                               profileImage:
//                                                   (state.user.profileImage !=
//                                                               null &&
//                                                           state
//                                                               .user
//                                                               .profileImage!
//                                                               .isNotEmpty)
//                                                       ? state.user.profileImage!
//                                                       : "https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&o=5&pid=1.9",
//                                             ),
//                                       ),
//                                     );
//                                   },
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(24),
//                                     child: Image.network(
//                                       (state.user.profileImage != null &&
//                                               state
//                                                   .user
//                                                   .profileImage!
//                                                   .isNotEmpty)
//                                           ? state.user.profileImage!
//                                           : "https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&o=5&pid=1.9",
//                                       width: 160,
//                                       height: 160,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 // Welcome Text
//                                 Text(
//                                   state.user.fullName,
//                                   style: const TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.amber.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Text(
//                                     state.user.role.toUpperCase(),
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.amber,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 const Text(
//                                   'Welcome to your customer dashboard',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 18),
//                                 // User Details Card
//                                 Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(16),
//                                     border: Border.all(
//                                       color: Colors.grey.withOpacity(0.2),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       _infoRow(
//                                         icon: Icons.person_outline,
//                                         label: 'Full Name',
//                                         value: state.user.fullName,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       _infoRow(
//                                         icon: Icons.alternate_email,
//                                         label: 'Username',
//                                         value: state.user.username,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       _infoRow(
//                                         icon: Icons.email_outlined,
//                                         label: 'Email',
//                                         value: state.user.email,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       _infoRow(
//                                         icon: Icons.call_outlined,
//                                         label: 'Mobile',
//                                         value: state.user.mobile,
//                                       ),
//                                       const SizedBox(height: 8),
//                                       _infoRow(
//                                         icon: Icons.calendar_today,
//                                         label: 'Member Since',
//                                         value: _formatDate(
//                                           state.user.createdAt,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       SizedBox(
//                                         height: 36,
//                                         child: ElevatedButton.icon(
//                                           onPressed: () async {
//                                             final result = await Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder:
//                                                     (context) => EditUserScreen(
//                                                       user: state.user,
//                                                     ),
//                                               ),
//                                             );
//                                             if (result == true) {
//                                               await _loadUserData();
//                                             }
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.amber,
//                                             foregroundColor: Colors.black,
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                             ),
//                                           ),
//                                           icon: const Icon(
//                                             Icons.edit,
//                                             size: 18,
//                                           ),
//                                           label: const Text("Edit Details"),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 // Order History Section
//                                 Container(
//                                   padding: const EdgeInsets.all(16),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(16),
//                                     border: Border.all(
//                                       color: Colors.grey.withOpacity(0.2),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Row(
//                                         children: [
//                                           Icon(
//                                             Icons.history,
//                                             color: Colors.amber,
//                                           ),
//                                           SizedBox(width: 8),
//                                           Text(
//                                             'Recent Orders',
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 16),
//                                       const Center(
//                                         child: Text(
//                                           'No orders yet',
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 // Logout Button
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     onPressed: _logout,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red,
//                                       foregroundColor: Colors.white,
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 40,
//                                         vertical: 12,
//                                       ),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       'Logout',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else if (state is UserError) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.error_outline,
//                             color: Colors.red,
//                             size: 60,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Error: ${state.error}',
//                             style: const TextStyle(color: Colors.black),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: _loadUserData,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.amber,
//                               foregroundColor: Colors.black87,
//                             ),
//                             child: const Text('Retry'),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                   return const Center(
//                     child: CircularProgressIndicator(color: Colors.amber),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.06),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.amber, size: 24),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year}';
//     } catch (e) {
//       return dateString;
//     }
//   }

//   @override
//   void dispose() {
//     _userBloc.close();
//     super.dispose();
//   }
// }

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:ui';

import 'package:app_frontend/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend/features/customer/profile/service/user_service.dart';
import 'package:app_frontend/features/customer/profile/view/edit_user_screen.dart';
import 'package:app_frontend/features/customer/profile/view/full_screen_profile_image.dart';
import 'package:app_frontend/utils/common/app_backround.dart';
import 'package:app_frontend/utils/common/custom_appbar.dart';
import 'package:app_frontend/utils/common/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
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

  // Show beautiful logout confirmation dialog
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        size: 48,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    const Text(
                      'Logout Confirmation',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Message
                    const Text(
                      'Are you sure you want to logout?',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You will need to login again to access your account.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop(); // Close dialog
                              // Trigger logout event
                              _userBloc.add(LogoutUser());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          // Handle logout states
          if (state is UserLoggedOut) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Expanded(child: Text('Logged out successfully')),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            // Navigate to auth screen
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/auth',
                  (route) => false,
                );
              }
            });
          } else if (state is UserLogoutError) {
            // Show error but still logout locally
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text('Logged out but: ${state.error}')),
                  ],
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );

            // Still navigate to auth screen
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/auth',
                  (route) => false,
                );
              }
            });
          } else if (state is UserLoggingOut) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Logging out...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          drawer: SafeArea(
            child: Drawer(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        String userName = "Customer";
                        if (state is UserLoaded) {
                          userName = state.user.fullName.split(' ')[0];
                        }

                        return Column(
                          children: [
                            const SizedBox(height: 40),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.amber,
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Customer",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ListTile(
                              leading: const Icon(
                                Icons.home,
                                color: Colors.black,
                              ),
                              title: const Text(
                                "Home",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              title: const Text(
                                "Profile",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Divider(color: Colors.grey),
                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              title: const Text(
                                "Logout",
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () {
                                Navigator.pop(context); // Close drawer
                                _showLogoutConfirmationDialog(); // Show confirmation
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          appBar: CustomAppBar(
            title: "My Profile",
            onMenuTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            onNotificationTap: () {},
            onFavouriteTap: () {},
            showMenu: true,
            showNotification: true,
            showFavourite: true,
          ),
          body: Stack(
            children: [
              const YellowCorner(),
              const BlueCenter(),
              const RedCorner(),
              SafeArea(
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const CustomLoader(loadingPageName: 'Profile');
                    } else if (state is UserLoaded) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  // Profile Image
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (
                                                context,
                                              ) => FullScreenProfileImage(
                                                profileImage:
                                                    (state.user.profileImage !=
                                                                null &&
                                                            state
                                                                .user
                                                                .profileImage!
                                                                .isNotEmpty)
                                                        ? state
                                                            .user
                                                            .profileImage!
                                                        : "https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&o=5&pid=1.9",
                                              ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(
                                        (state.user.profileImage != null &&
                                                state
                                                    .user
                                                    .profileImage!
                                                    .isNotEmpty)
                                            ? state.user.profileImage!
                                            : "https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&o=5&pid=1.9",
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            width: 160,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
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
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      state.user.role.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Welcome to your customer dashboard',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  // User Details Card
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        _infoRow(
                                          icon: Icons.person_outline,
                                          label: 'Full Name',
                                          value: state.user.fullName,
                                        ),
                                        const SizedBox(height: 8),
                                        _infoRow(
                                          icon: Icons.alternate_email,
                                          label: 'Username',
                                          value: state.user.username,
                                        ),
                                        const SizedBox(height: 8),
                                        _infoRow(
                                          icon: Icons.email_outlined,
                                          label: 'Email',
                                          value: state.user.email,
                                        ),
                                        const SizedBox(height: 8),
                                        _infoRow(
                                          icon: Icons.call_outlined,
                                          label: 'Mobile',
                                          value: state.user.mobile,
                                        ),
                                        const SizedBox(height: 8),
                                        _infoRow(
                                          icon: Icons.calendar_today,
                                          label: 'Member Since',
                                          value: _formatDate(
                                            state.user.createdAt,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 36,
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              final result =
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              EditUserScreen(
                                                                user:
                                                                    state.user,
                                                              ),
                                                    ),
                                                  );
                                              if (result == true) {
                                                await _loadUserData();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                              foregroundColor: Colors.black,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                            ),
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18,
                                            ),
                                            label: const Text("Edit Details"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Order History Section
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.history,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Recent Orders',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        const Center(
                                          child: Text(
                                            'No orders yet',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Logout Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _showLogoutConfirmationDialog,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
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
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _loadUserData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black87,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
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

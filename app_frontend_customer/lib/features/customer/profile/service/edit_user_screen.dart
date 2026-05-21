// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:app_frontend_customer/features/customer/profile/bloc/user_bloc.dart';
import 'package:app_frontend_customer/features/customer/profile/bloc/user_event.dart';
import 'package:app_frontend_customer/features/customer/profile/bloc/user_state.dart';
import 'package:app_frontend_customer/features/customer/profile/model/user_model.dart';
import 'package:app_frontend_customer/utils/common/custom_loader.dart';
import 'package:app_frontend_customer/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel user;
  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;

  File? _selectedImageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _mobileController = TextEditingController(text: widget.user.mobile);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        context.read<UserBloc>().add(
          UpdateUserProfile(
            token: token,
            fullName: _fullNameController.text,
            username: _usernameController.text,
            email: _emailController.text,
            mobile: _mobileController.text,
            imageFile: _selectedImageFile,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.pop(context, true);
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
        } else if (state is UserUpdating) {
          setState(() => _isLoading = true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body:
            _isLoading
                ? CustomLoader(
                  loadingPageName: '',
                  isExtra: true,
                  extraText: "Updating Profile...",
                )
                : Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 200,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.transparent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(60),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(0.09),
                              blurRadius: 80,
                              spreadRadius: 80,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 200,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.transparent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.07),
                              blurRadius: 50,
                              spreadRadius: 40,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 200,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.transparent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.04),
                              blurRadius: 80,
                              spreadRadius: 80,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Profile Image Section
                            GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      image: DecorationImage(
                                        image:
                                            _selectedImageFile != null
                                                ? FileImage(_selectedImageFile!)
                                                : (widget.user.profileImage !=
                                                            null &&
                                                        widget
                                                            .user
                                                            .profileImage!
                                                            .isNotEmpty
                                                    ? NetworkImage(
                                                      widget.user.profileImage!,
                                                    )
                                                    : const NetworkImage(
                                                          "https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&o=5&pid=1.9",
                                                        )
                                                        as ImageProvider),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Colors.lightGreenAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tap to change profile picture',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Full Name Field
                            AppTextField(
                              controller: _fullNameController,
                              hintText: 'Full Name',
                              hugeIcon: HugeIcons.strokeRoundedUser02,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Username Field
                            AppTextField(
                              controller: _usernameController,
                              hintText: 'Username',
                              hugeIcon: HugeIcons.strokeRoundedUser03,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email Field
                            AppTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              hugeIcon: HugeIcons.strokeRoundedMail01,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Mobile Field
                            AppTextField(
                              controller: _mobileController,
                              hintText: 'Mobile Number',
                              hugeIcon: HugeIcons.strokeRoundedAiPhone01,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter mobile number';
                                }
                                if (value.length < 10) {
                                  return 'Please enter valid mobile number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightGreenAccent,
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: Colors.grey,
                                  disabledForegroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }
}

// lib/features/seller/seller_profile/profile/view/edit_user_screen.dart

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:app_frontend/features/seller/seller_profile/profile/bloc/user_bloc.dart';
import 'package:app_frontend/features/seller/seller_profile/profile/bloc/user_event.dart';
import 'package:app_frontend/features/seller/seller_profile/profile/bloc/user_state.dart';
import 'package:app_frontend/features/seller/seller_profile/profile/model/user_model.dart';
import 'package:app_frontend/features/seller/seller_profile/profile/service/image_upload_service';
import 'package:app_frontend/utils/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String? _uploadedImageUrl;
  bool _isLoading = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _mobileController = TextEditingController(text: widget.user.mobile);
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        _isUploading = true;
      });

      // Show uploading progress
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Uploading image...'),
            ],
          ),
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 2),
        ),
      );

      try {
        // Upload image to server
        final imageUrl = await ImageUploadService.uploadProfileImage(
          _selectedImageFile!,
        );

        if (imageUrl != null) {
          setState(() {
            _uploadedImageUrl = imageUrl;
            _isUploading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Upload failed');
        }
      } catch (e) {
        setState(() {
          _isUploading = false;
          _selectedImageFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        setState(() => _isLoading = true);

        // Use uploaded image URL if available, otherwise keep existing
        final profileImageUrl = _uploadedImageUrl ?? widget.user.profileImage;

        context.read<UserBloc>().add(
          UpdateUserProfile(
            token: token,
            fullName: _fullNameController.text.trim(),
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            mobile: _mobileController.text.trim(),
            profileImage: profileImageUrl,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        setState(() => _isLoading = false);

        if (state is UserUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
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
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _updateProfile,
              child: Text(
                'Save',
                style: TextStyle(
                  color: _isLoading ? Colors.grey : Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body:
            _isLoading
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFFFFD700)),
                      SizedBox(height: 16),
                      Text('Updating profile...'),
                    ],
                  ),
                )
                : Stack(
                  children: [
                    // Background decorative elements
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

                    // Main content
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Profile Image Section
                            GestureDetector(
                              onTap: _isUploading ? null : _pickAndUploadImage,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.amber,
                                        width: 3,
                                      ),
                                      image: DecorationImage(
                                        image: _getProfileImage(),
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
                                        color: Colors.amber,
                                        shape: BoxShape.circle,
                                      ),
                                      child:
                                          _isUploading
                                              ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.black,
                                                    ),
                                              )
                                              : const Icon(
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
                            Text(
                              _isUploading
                                  ? 'Uploading image...'
                                  : 'Tap to change profile picture',
                              style: TextStyle(
                                color:
                                    _isUploading ? Colors.amber : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Full Name Field
                            AppTextField(
                              controller: _fullNameController,
                              hintText: 'Full Name',
                              icon: Icons.person_outline,
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
                              icon: Icons.alternate_email,
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
                              icon: Icons.email_outlined,
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
                              icon: Icons.call_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter mobile number';
                                }
                                if (value.length != 10) {
                                  return 'Please enter valid 10-digit mobile number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Save Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: Colors.grey,
                                  disabledForegroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black,
                                          ),
                                        )
                                        : const Text(
                                          'Save Changes',
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

  ImageProvider _getProfileImage() {
    // Priority: Newly uploaded image > Selected local file > Existing profile image > Default
    if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty) {
      return NetworkImage(_uploadedImageUrl!);
    }
    if (_selectedImageFile != null) {
      return FileImage(_selectedImageFile!);
    }
    if (widget.user.profileImage != null &&
        widget.user.profileImage!.isNotEmpty) {
      return NetworkImage(widget.user.profileImage!);
    }
    return const NetworkImage(
      "https://tse1.mm.bing.net/th/id/OET.7252da000e8341b2ba1fb61c275c1f30?w=594&h=594&c=7&rs=1&o=5&pid=1.9",
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

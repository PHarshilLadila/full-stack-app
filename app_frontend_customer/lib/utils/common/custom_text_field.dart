// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final List<List<dynamic>> hugeIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconButton? sufixIcon;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.hugeIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.sufixIcon,
    this.onFieldSubmitted,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 14,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.lightGreenAccent,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,

        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 12),
          child: HugeIcon(
            icon: hugeIcon,
            color: Colors.grey,
            size: 22.0,
            strokeWidth: 2,
          ),
        ),

        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(left: 16.0),
        //   child: Icon(icon, color: Colors.grey),
        // ),
        suffixIcon: sufixIcon,
        contentPadding: contentPadding,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),
      ),

      validator: validator,
    );
  }
}

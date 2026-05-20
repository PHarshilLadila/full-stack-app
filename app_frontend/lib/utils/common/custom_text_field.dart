// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconButton? sufixIcon;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.sufixIcon,
    this.onFieldSubmitted,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 14,
    ),
    this.borderRadius = kIsWeb ? 12 : 100,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: kIsWeb ? Colors.deepPurple : Colors.amber,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,

      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 5),
          child: Icon(icon, color: Colors.grey, size: 20),
        ),
        suffixIcon: sufixIcon,
        contentPadding: contentPadding,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
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

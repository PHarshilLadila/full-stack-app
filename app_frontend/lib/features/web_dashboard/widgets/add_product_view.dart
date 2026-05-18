import 'package:app_frontend/features/seller/products/bloc/product_bloc.dart';
import 'package:app_frontend/features/seller/products/bloc/product_event.dart';
import 'package:app_frontend/features/seller/products/bloc/product_state.dart';
import 'package:app_frontend/features/seller/products/service/product_service.dart';
import 'package:app_frontend/features/seller/products/model/product_model.dart';
import 'package:app_frontend/features/web_dashboard/widgets/add_product_form_widget.dart';
import 'package:app_frontend/features/web_dashboard/widgets/dashboard_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:material_table_view/material_table_view.dart';
import 'package:material_table_view/table_view_typedefs.dart';

class AddProductView extends StatelessWidget {
  final VoidCallback onBack;

  const AddProductView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildBackButton(),
            const SizedBox(height: 24),
            AddProductFormWidget(onSuccess: onBack),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
          const SizedBox(width: 8),
          const Text(
            'Back to Products',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

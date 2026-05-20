import 'package:app_frontend/features/web_dashboard/widgets/product_widgets/add_product_form_widget.dart';

import 'package:flutter/material.dart';

class AddProductView extends StatelessWidget {
  final VoidCallback onBack;

  const AddProductView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            buildBackButton(),
            const SizedBox(height: 24),
            ProductFormWidget(onSuccess: onBack),
          ],
        ),
      ),
    );
  }

  Widget buildBackButton() {
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

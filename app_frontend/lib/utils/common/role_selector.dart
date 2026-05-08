import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleSelected;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.grey.withOpacity(0.06),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onRoleSelected('customer'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedRole == 'customer' ? Colors.amber : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: selectedRole == 'customer' ? Colors.black : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Customer',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selectedRole == 'customer' ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onRoleSelected('seller'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedRole == 'seller' ? Colors.amber : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.store_outlined,
                      size: 18,
                      color: selectedRole == 'seller' ? Colors.black : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Seller',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selectedRole == 'seller' ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
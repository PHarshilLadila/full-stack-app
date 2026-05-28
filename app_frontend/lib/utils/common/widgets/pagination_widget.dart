// lib/features/web_dashboard/widgets/product_widgets/pagination_widget.dart

import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final startItem = ((currentPage - 1) * itemsPerPage) + 1;
    final endItem =
        (currentPage * itemsPerPage) > totalItems
            ? totalItems
            : currentPage * itemsPerPage;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Showing info text
          Text(
            'Showing $startItem to $endItem of $totalItems products',
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          // Pagination buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First page button
              _buildPageButton(
                icon: Icons.first_page,
                onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
              ),
              const SizedBox(width: 8),
              // Previous page button
              _buildPageButton(
                icon: Icons.chevron_left,
                onPressed:
                    currentPage > 1
                        ? () => onPageChanged(currentPage - 1)
                        : null,
              ),
              const SizedBox(width: 8),
              // Page numbers
              ..._getPageNumbers(),
              const SizedBox(width: 8),
              // Next page button
              _buildPageButton(
                icon: Icons.chevron_right,
                onPressed:
                    currentPage < totalPages
                        ? () => onPageChanged(currentPage + 1)
                        : null,
              ),
              const SizedBox(width: 8),
              // Last page button
              _buildPageButton(
                icon: Icons.last_page,
                onPressed:
                    currentPage < totalPages
                        ? () => onPageChanged(totalPages)
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _getPageNumbers() {
    List<Widget> pages = [];
    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(1, totalPages);

    if (startPage > 1) {
      pages.add(_buildNumberButton(1));
      if (startPage > 2) {
        pages.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...', style: TextStyle(color: Color(0xFF64748B))),
          ),
        );
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      pages.add(_buildNumberButton(i));
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pages.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...', style: TextStyle(color: Color(0xFF64748B))),
          ),
        );
      }
      pages.add(_buildNumberButton(totalPages));
    }

    return pages;
  }

  Widget _buildPageButton({required IconData icon, VoidCallback? onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: 36,
      height: 36,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color:
              onPressed != null
                  ? const Color(0xFF7C3AED).withOpacity(0.3)
                  : Colors.grey.shade200,
        ),
      ),
      child: Icon(
        icon,
        size: 20,
        color:
            onPressed != null ? const Color(0xFF7C3AED) : Colors.grey.shade400,
      ),
    );
  }

  Widget _buildNumberButton(int pageNumber) {
    final isSelected = pageNumber == currentPage;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: MaterialButton(
        onPressed: () => onPageChanged(pageNumber),
        minWidth: 36,
        height: 36,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color:
                isSelected
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF7C3AED).withOpacity(0.3),
          ),
        ),
        color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent,
        child: Text(
          '$pageNumber',
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF7C3AED),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

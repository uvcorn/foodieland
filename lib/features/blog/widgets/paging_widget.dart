import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<int?> _generatePageList() {
    List<int?> pages = [];

    if (totalPages <= 7) {
      // যদি কম পেজ থাকে সব দেখাবে
      pages = List.generate(totalPages, (index) => index + 1);
    } else {
      if (currentPage <= 4) {
        pages = [1, 2, 3, 4, 5, null, totalPages];
      } else if (currentPage >= totalPages - 3) {
        pages = [
          1,
          null,
          totalPages - 4,
          totalPages - 3,
          totalPages - 2,
          totalPages - 1,
          totalPages,
        ];
      } else {
        pages = [
          1,
          null,
          currentPage - 1,
          currentPage,
          currentPage + 1,
          null,
          totalPages,
        ];
      }
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _generatePageList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          pages.map((page) {
            if (page == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text("...", style: TextStyle(fontSize: 16)),
              );
            }

            final isCurrent = page == currentPage;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () => onPageChanged(page),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Text(
                    "$page",
                    style: TextStyle(
                      color: isCurrent ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}

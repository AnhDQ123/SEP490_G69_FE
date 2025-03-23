import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/filter_controller.dart';

class FilterHeader extends GetView<FilterController> {
  const FilterHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.filter_list, size: 20),
            label: const Text(
              "Bộ lọc",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(
                  color: Color.fromRGBO(212, 163, 115, 1), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            onPressed: () {
              // Xử lý sự kiện bộ lọc nếu cần
            },
          ),
          const SizedBox(width: 12),
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.filterCategory.value.isNotEmpty
                  ? Chip(
                key: ValueKey(controller.filterCategory.value),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.filterCategory.value,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Khi bấm nút x, gọi đến removeCategoryFilter()
                        controller.removeCategoryFilter();
                      },
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ],
                ),
                backgroundColor:
                const Color.fromRGBO(212, 163, 115, 1),
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
              )
                  : const SizedBox.shrink(),
            );
          }),
        ],
      ),
    );
  }
}

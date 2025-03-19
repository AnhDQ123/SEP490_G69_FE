import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/filter_controller.dart';

class TopTabBar extends GetView<FilterController> {
  const TopTabBar({Key? key}) : super(key: key);

  Widget _buildTopTab(String title, int tabIndex, int currentTab) {
    final bool isSelected = tabIndex == currentTab;
    return InkWell(
      onTap: () => controller.switchTopTab(tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(bottom: BorderSide(color: Colors.black, width: 2))
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          final currentTab = controller.selectedTabIndex.value;
          return Row(
            children: [
              _buildTopTab("Các sản phẩm", 0, currentTab),
              _buildTopTab("Bán chạy", 1, currentTab),
              _buildTopTab("Đánh giá", 2, currentTab),
              _buildTopTab("Giá", 3, currentTab),
            ],
          );
        }),
      ),
    );
  }
}

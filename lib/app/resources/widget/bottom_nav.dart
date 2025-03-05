import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(), // Bo tròn khu vực FloatingActionButton
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.article, "Blog", 0, context),
          _buildNavItem(Icons.favorite, "Yêu thích", 1, context),
          SizedBox(width: 50), // Khoảng trống cho nút Home
          _buildNavItem(Icons.shopping_cart, "Giỏ hàng", 2, context),
          _buildNavItem(Icons.person, "Cá nhân", 3, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context) {
    bool isSelected = currentIndex == index;
    return InkWell(
      onTap: () {
        switch (index) {
      //     case 0:
      //       Get.toNamed(Routes.BLOG);
      //       break;
      //     case 1:
      //       Get.toNamed(Routes.FAVORITE);
      //       break;
      //     case 2:
      //       Get.toNamed(Routes.CART);
      //       break;
          case 3:
            Get.toNamed(Routes.PROFILE);
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Color.fromRGBO(212, 163, 115, 1) : Colors.grey),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Color.fromRGBO(212, 163, 115, 1) : Colors.grey)),
        ],
      ),
    );
  }
}

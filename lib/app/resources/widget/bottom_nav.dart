import 'package:ffb_fe_flutter/app/modules/cart/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../modules/cart/controllers/cart_controller.dart';
import '../../routes/app_pages.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNav({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
  }) : super(key: key);

  static const Color selectedColor = Color.fromRGBO(212, 163, 115, 1);
  static const Color unselectedColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        children: [
          Expanded(child: _buildNavItem(Icons.article, "Blog", 0)),
          Expanded(child: _buildNavItem(Icons.category, "Danh mục", 1)),
          Expanded(child: _buildNavItem(Icons.home, "Trang chủ", 2)),
          Expanded(child: _buildNavItem(Icons.shopping_cart, "Giỏ hàng", 3)),
          Expanded(child: _buildNavItem(Icons.person, "Cá nhân", 4)),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = (currentIndex == index);

    return InkWell(
      onTap: () {
        if (index == 3) {
          // Kiểm tra nếu CartController chưa có trong bộ nhớ thì put
          if (!Get.isRegistered<CartController>()) {
            Get.put(CartController());
          }

          // Sau đó mới gọi bottomSheet
          Get.bottomSheet(
            const CartView(),
            isScrollControlled: true, // Cho phép kéo full màn hình
          );
        } else {
          onItemSelected(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isSelected ? selectedColor : Colors.transparent,
              width: 3.0,
            ),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20.0,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              const SizedBox(height: 2.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.0,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

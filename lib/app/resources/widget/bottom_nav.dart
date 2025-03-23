import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/modules/cart/controllers/cart_controller.dart';
import 'package:ffb_fe_flutter/app/modules/cart/views/cart_view.dart';
import '../../routes/app_pages.dart';

class BottomNav extends StatefulWidget {
  final int initialIndex;

  const BottomNav({Key? key, this.initialIndex = 2}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int currentIndex;

  // Định nghĩa ánh xạ index - route (ngoại trừ giỏ hàng, dùng bottom sheet)
  final Map<int, String> routeMapping = {
    // Nếu có route cho Blog hoặc Danh mục thì có thể thêm vào
    // 0: Routes.BLOG,
    // 1: Routes.CATEGORY,
    2: Routes.HOME,
    4: Routes.PROFILE,
  };

  // Các biến tĩnh cho màu sắc
  static const Color selectedColor = Color.fromRGBO(212, 163, 115, 1);
  static const Color unselectedColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _onItemSelected(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 3) {
      // Nếu là giỏ hàng, kiểm tra CartController và mở bottom sheet
      if (!Get.isRegistered<CartController>()) {
        Get.put(CartController());
      }
      Get.bottomSheet(
        const CartView(),
        isScrollControlled: true,
      );
    } else {
      // Chuyển sang trang tương ứng nếu có trong ánh xạ
      String? route = routeMapping[index];
      if (route != null) {
        Get.toNamed(route);
      }
    }
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = (currentIndex == index);
    return InkWell(
      onTap: () => _onItemSelected(index),
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
}

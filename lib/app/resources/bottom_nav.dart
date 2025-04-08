import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/modules/cart/controllers/cart_controller.dart';
import 'package:ffb_fe_flutter/app/modules/cart/views/cart_view.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/home_view.dart';
import 'package:ffb_fe_flutter/app/modules/user_profile/profile/views/profile_view.dart';

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
          Expanded(child: _buildCartNavItem()),  // Thay đổi cho giỏ hàng
          Expanded(child: _buildNavItem(Icons.person, "Cá nhân", 4)),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = (currentIndex == index);

    return InkWell(
      onTap: () {
        onItemSelected(index); // Cập nhật chỉ mục hiện tại
        _navigateToPage(index); // Điều hướng đến trang tương ứng
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

  Widget _buildCartNavItem() {
    return InkWell(
      onTap: () {
        onItemSelected(3);
        _navigateToPage(3);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: currentIndex == 3 ? selectedColor : Colors.transparent,
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
                Icons.shopping_cart,
                size: 20.0,
                color: currentIndex == 3 ? selectedColor : unselectedColor,
              ),
              const SizedBox(height: 2.0),
              Text(
                "Giỏ hàng",
                style: TextStyle(
                  fontSize: 10.0,
                  color: currentIndex == 3 ? selectedColor : unselectedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
      // Get.to(() => BlogPage());
        break;
      case 1:
      // Get.to(() => CategoryPage());
        break;
      case 2:
        Get.to(() => HomeView()); // Chuyển đến trang Trang chủ
        break;
      case 3:
        Get.to(() => CartView()); // Chuyển đến trang Giỏ hàng
        break;
      case 4:
        Get.to(() => ProfileView()); // Chuyển đến trang Cá nhân
        break;
      default:
        break;
    }
  }
}

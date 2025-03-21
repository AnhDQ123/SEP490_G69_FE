import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class FoodTabs extends StatelessWidget {
  final HomeController controller;
  const FoodTabs({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // ✅ Giảm khoảng cách tổng thể
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // ✅ Nền nhẹ hơn giúp tabs nổi bật
          borderRadius: BorderRadius.circular(8), // ✅ Giữ bo góc mềm mại
        ),
        child: Row(
          children: [
            // ✅ Tab "Đồ ăn"
            Expanded(
              child: InkWell(
                onTap: () => controller.switchFoodTab(0),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 6), // ✅ Giảm padding chiều cao
                  decoration: BoxDecoration(
                    color: (controller.selectedFoodTab.value == 0)
                        ? const Color.fromRGBO(212, 163, 115, 1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Đồ ăn",
                      style: TextStyle(
                        fontSize: 12, // ✅ Giữ chữ nhỏ gọn
                        fontWeight: FontWeight.bold,
                        color: (controller.selectedFoodTab.value == 0)
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Tab "Chợ tươi sống"
            Expanded(
              child: InkWell(
                onTap: () => controller.switchFoodTab(1),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: (controller.selectedFoodTab.value == 1)
                        ? const Color.fromRGBO(212, 163, 115, 1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Chợ tươi sống",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: (controller.selectedFoodTab.value == 1)
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
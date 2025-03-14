import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class FoodTabs extends StatelessWidget {
  final HomeController controller;
  const FoodTabs({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => controller.switchFoodTab(0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: (controller.selectedFoodTab.value == 0)
                    ? Colors.orange.shade200
                    : Colors.grey.shade200,
                child: const Center(child: Text("Đồ ăn")),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => controller.switchFoodTab(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: (controller.selectedFoodTab.value == 1)
                    ? Colors.orange.shade200
                    : Colors.grey.shade200,
                child: const Center(child: Text("Chợ tươi sống")),
              ),
            ),
          ),
        ],
      );
    });
  }
}

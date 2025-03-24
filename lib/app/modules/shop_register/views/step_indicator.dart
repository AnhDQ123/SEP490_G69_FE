import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_register_controller.dart';

class StepIndicator extends StatelessWidget {
  final ShopRegisterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              bool isActive = controller.currentStep.value == index;
              return Column(
                children: [
                  Text(
                    "Bước ${index + 1}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.black : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.black : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              );
            }),
          ),
        ));
  }
}

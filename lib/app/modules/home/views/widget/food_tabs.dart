import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/responsive_utils.dart';
import '../../../../resources/text_style.dart';
import '../../controllers/home_controller.dart';

class FoodTabs extends StatelessWidget {
  final HomeController controller;
  const FoodTabs({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: UtilsReponsive.padding(context, horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(UtilsReponsive.width(8, context)),
        ),
        child: Row(
          children: [
            // Tab "Đồ ăn nhanh"
            Expanded(
              child: InkWell(
                onTap: () => controller.switchFoodTab(0),
                borderRadius:
                BorderRadius.circular(UtilsReponsive.width(8, context)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: UtilsReponsive.padding(context, vertical: 6),
                  decoration: BoxDecoration(
                    color: (controller.selectedFoodTab.value == 0)
                        ? const Color.fromRGBO(212, 163, 115, 1)
                        : Colors.transparent,
                    borderRadius:
                    BorderRadius.circular(UtilsReponsive.width(8, context)),
                  ),
                  child: Center(
                    child: TextConstant.subTile3(
                      context,
                      text: "Đồ ăn nhanh",
                      size: UtilsReponsive.formatFontSize(12, context),
                      fontWeight: FontWeight.bold,
                      color: (controller.selectedFoodTab.value == 0)
                          ? Colors.white
                          : Colors.black87,
                      textAlign: TextAlign.center, // đảm bảo căn giữa
                    ),
                  ),
                ),
              ),
            ),

            // Tab "Chợ tươi sống" với line height được điều chỉnh
            Expanded(
              child: InkWell(
                onTap: () => controller.switchFoodTab(1),
                borderRadius:
                BorderRadius.circular(UtilsReponsive.width(8, context)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: UtilsReponsive.padding(context, vertical: 6),
                  decoration: BoxDecoration(
                    color: (controller.selectedFoodTab.value == 1)
                        ? const Color.fromRGBO(212, 163, 115, 1)
                        : Colors.transparent,
                    borderRadius:
                    BorderRadius.circular(UtilsReponsive.width(8, context)),
                  ),
                  child: Center(
                    // Sử dụng Text widget trực tiếp để điều chỉnh height thông qua copyWith
                    child: Text(
                      "Đồ tươi sống",
                      textAlign: TextAlign.center,
                      style: TextConstant.textStyleDefine(
                        context,
                        size: UtilsReponsive.formatFontSize(12, context),
                        fontWeight: FontWeight.bold,
                        color: (controller.selectedFoodTab.value == 1)
                            ? Colors.white
                            : Colors.black87,
                      ).copyWith(height: 1.2),
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
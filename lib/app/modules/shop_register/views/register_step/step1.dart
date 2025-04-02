import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/text_style.dart';
import '../../controllers/shop_register_controller.dart';

class Step1 extends StatelessWidget {
  final ShopRegisterController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Using TextConstant for styling, pass context here
          TextConstant.titleH2(
            context,
            text: "Vui lòng chọn loại hình dịch vụ",
          ),
          SizedBox(height: 12),
          _buildServiceOption(
            context, // Pass context to the helper method
            title: "Đồ ăn nhanh",
            description:
            "Món chủ đạo của cửa hàng là món ăn/Thức uống được chế biến nhằm phục vụ cho mục đích ăn nhanh với trạng thái món ở mức độ cao nhất có thể như: bún, phở, mì, cơm, cháo vẫn còn nóng...",
            value: "COOKED",
          ),
          SizedBox(height: 8),
          _buildServiceOption(
            context, // Pass context to the helper method
            title: "Thực phẩm tươi sống",
            description:
            "Sản phẩm chủ đạo của cửa hàng là các sản phẩm có chất lượng và độ tươi sống đạt chuẩn, thường là các mặt hàng như thịt, cá, rau củ quả tươi...",
            value: "FRESH",
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOption(
      BuildContext context, { // Add BuildContext as a parameter
        required String title,
        required String description,
        required String value,
      }) {
    return Obx(() => GestureDetector(
      onTap: () => controller.selectedService(value),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.selectedService.value == value
                ? Colors.black
                : Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: controller.selectedService.value,
                  onChanged: (val) => controller.selectedService(val!),
                ),
                Expanded(
                  child: TextConstant.titleH3(
                    context,
                    text: title,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: TextConstant.subTile2(
                context,
                text: description,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

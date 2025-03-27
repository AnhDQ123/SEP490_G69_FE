import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddDiscountController extends GetxController {
  var originalPrice = 30000.obs; // Giá gốc
  var discountValue = TextEditingController(); // Giá trị giảm
  var finalPrice = "".obs; // Giá sau khi giảm

  var quantityOption = "all".obs; // Mặc định là toàn bộ số lượng
  var specificQuantity = TextEditingController(); // Số lượng cụ thể

  var timeOption = "today".obs; // Mặc định là "Trong hôm nay"
  var startDate = "".obs;
  var endDate = "".obs;
  var duration = TextEditingController(); // Nhập số giờ nếu chọn "Trong vòng"

  void calculateDiscount() {
    if (discountValue.text.isNotEmpty) {
      int discount = int.tryParse(discountValue.text) ?? 0;
      int finalPriceValue = originalPrice.value - discount;
      finalPrice.value = finalPriceValue > 0 ? "$finalPriceValue đồng" : "0 đồng";
    } else {
      finalPrice.value = "";
    }
  }
}

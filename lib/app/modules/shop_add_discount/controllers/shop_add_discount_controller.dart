import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/discount.dart';
import '../../../models/product_discount.dart';
import '../../../service/shop_service.dart';

class ShopAddDiscountController extends GetxController {
  final discountPercentController = TextEditingController();
  final discountedPriceController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  double currentProductPrice = 0;

  void setDefaultToday() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    startDateController.text = today;
    endDateController.text = today;
  }

  void pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      if (isStart) {
        startDateController.text = formatted;
      } else {
        endDateController.text = formatted;
      }
    }
  }

  void clampDiscountValue() {
    final text = discountPercentController.text;
    final value = int.tryParse(text);

    if (value == null) return;

    int clamped = value;

    if (value > 100) {
      clamped = 100;
    } else if (value < 0) {
      clamped = 0;
    }

    // Nếu đã khác thì cập nhật lại controller
    if (clamped.toString() != text) {
      discountPercentController.text = clamped.toString();
      discountPercentController.selection = TextSelection.fromPosition(
        TextPosition(offset: discountPercentController.text.length),
      );
    }

    updateDiscountPrice(currentProductPrice); // Cập nhật giá sau khi giảm
  }


  void updateDiscountPrice(double originalPrice) {
    final percent = double.tryParse(discountPercentController.text);
    if (percent != null) {
      final discounted = originalPrice * (1 - percent / 100);
      discountedPriceController.text = discounted.toStringAsFixed(0);
    } else {
      discountedPriceController.text = '';
    }
  }

  void loadDiscountToForm(Discount discount) {
    discountPercentController.text = (discount.amount * 100).toStringAsFixed(0);
    startDateController.text = discount.startDate.substring(0, 10);
    endDateController.text = discount.endDate.substring(0, 10);
    updateDiscountPrice(currentProductPrice);
  }

  bool validateFields() {
    if (discountPercentController.text.isEmpty ||
        startDateController.text.isEmpty ||
        endDateController.text.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thông tin');
      return false;
    }

    final percent = double.tryParse(discountPercentController.text);
    if (percent == null || percent <= 0 || percent > 100) {
      Get.snackbar('Lỗi', 'Phần trăm giảm phải nằm trong khoảng 1 - 100');
      return false;
    }

    return true;
  }

  Future<void> addDiscount(ProductDiscount product) async {
    if (!validateFields()) return;

    final discount = Discount(
      id: 0,
      amount: double.parse(discountPercentController.text),
      startDate: startDateController.text + " 00:00:00",
      endDate: endDateController.text + " 23:59:59",
      status: 'ACTIVE',
    );

    final result = await ShopService().addDiscount(
      productId: product.id,
      discount: discount,
    );

    if (result.success) {
      // 👇 Đảm bảo context vẫn còn hoạt động
      if (Get.context != null) {
        Navigator.of(Get.context!).pop(); // THAY CHO Get.back()
        await Future.delayed(Duration(milliseconds: 200));
        Get.snackbar('Thành công', result.message);
      }
    } else {
      Get.snackbar('Thất bại', result.message);
    }
  }



  Future<void> updateDiscount(ProductDiscount product, Discount oldDiscount) async {
    if (!validateFields()) return;

    final discount = Discount(
      id: oldDiscount.id,
      amount: (double.parse(discountPercentController.text) / 100),
      startDate: startDateController.text + "T00:00:00",
      endDate: endDateController.text + "T23:59:59",
      status: 'ACTIVE',
    );

    try {
      await ShopService().updateDiscountToProduct(product.id, discount);
      Get.back();
      Get.snackbar('Thành công', 'Đã cập nhật giảm giá');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật giảm giá');
    }
  }
}

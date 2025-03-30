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

  /// Đặt ngày mặc định là hôm nay
  void setDefaultToday() {
    final today = _formatDate(DateTime.now());
    startDateController.text = today;
    endDateController.text = today;
  }

  /// Hàm chọn ngày
  void pickDate({required bool isStart}) async {
    FocusScope.of(Get.context!).unfocus(); // Ẩn bàn phím

    final initial = isStart
        ? DateTime.now()
        : DateTime.tryParse(startDateController.text) ?? DateTime.now();

    final first = isStart
        ? DateTime.now()
        : DateTime.tryParse(startDateController.text) ?? DateTime.now();

    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatted = _formatDate(picked);
      if (isStart) {
        startDateController.text = formatted;

        // Reset end date nếu nhỏ hơn start
        final end = DateTime.tryParse(endDateController.text);
        if (end != null && picked.isAfter(end)) {
          endDateController.text = formatted;
        }
      } else {
        endDateController.text = formatted;
      }
    }
  }

  /// Clamp phần trăm giảm từ 0-100 và cập nhật giá sau khi giảm
  void clampDiscountValue() {
    final text = discountPercentController.text;
    final value = int.tryParse(text);

    if (value == null) return;

    final clamped = value.clamp(0, 100);
    if (clamped.toString() != text) {
      discountPercentController.text = clamped.toString();
      discountPercentController.selection = TextSelection.fromPosition(
        TextPosition(offset: discountPercentController.text.length),
      );
    }

    updateDiscountPrice(currentProductPrice);
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
    startDateController.text = _formatDateString(discount.startDate);
    endDateController.text = _formatDateString(discount.endDate);
    updateDiscountPrice(currentProductPrice);
  }

  /// Validate các trường và logic ngày tháng
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

    final start = DateTime.tryParse(startDateController.text);
    final end = DateTime.tryParse(endDateController.text);

    if (start == null || end == null) {
      Get.snackbar('Lỗi', 'Ngày không hợp lệ');
      return false;
    }

    if (end.isBefore(start)) {
      Get.snackbar('Lỗi', 'Ngày kết thúc không được trước ngày bắt đầu');
      return false;
    }

    return true;
  }

  Future<void> addDiscount(ProductDiscount product) async {
    if (!validateFields()) return;

    final discount = Discount(
      id: 0,
      amount: double.parse(discountPercentController.text) / 100,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: 'ACTIVE',
    );

    final result = await ShopService().addDiscount(
      productId: product.id,
      discount: discount,
    );

    if (result.success) {
      Get.back(result: true); // ✅ Trả về thành công
      Get.snackbar('Thành công', result.message);
    } else {
      Get.snackbar('Thất bại', result.message);
    }
  }

  Future<void> updateDiscount(ProductDiscount product, Discount oldDiscount) async {
    if (!validateFields()) return;

    final discount = Discount(
      id: oldDiscount.id,
      amount: double.parse(discountPercentController.text) / 100,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: 'ACTIVE',
    );

    try {
      final result = await ShopService().updateDiscountToProduct(product.id, discount);
      Get.back(result: true); // ✅ Trả về thành công
      Get.snackbar('Thành công', 'Đã cập nhật giảm giá');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật giảm giá');
    }
  }

  String _formatDate(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);

  String _formatDateString(String dateStr) {
    try {
      return _formatDate(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/voucher.dart';
import '../../../service/shop_service.dart';
import '../../shop_menu/controllers/shop_controller.dart';

class ShopVoucherAddController extends GetxController {
  final codeController = TextEditingController();
  final discountType = 'PERCENTAGE'.obs;
  final discountValueController = TextEditingController();
  final minOrderValueController = TextEditingController();
  final totalVouchersController = TextEditingController();
  final maxUsagePerCustomerController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final shopId = Get.find<ShopController>().shopId;

  final ShopService shopService = ShopService();

  Voucher? editingVoucher;

  void initialize(Voucher? voucher) {
    if (voucher == null) return;
    editingVoucher = voucher;
    codeController.text = voucher.code;
    discountType.value = voucher.discountType;
    discountValueController.text = voucher.discountValue.toString();
    minOrderValueController.text = voucher.minOrderValue.toString();
    totalVouchersController.text = voucher.totalVouchers.toString();
    maxUsagePerCustomerController.text = voucher.maxUsagePerCustomer.toString();
    startDateController.text = voucher.startDate;
    endDateController.text = voucher.endDate;
  }

  bool validateForm() {
    if (codeController.text.isEmpty ||
        discountValueController.text.isEmpty ||
        minOrderValueController.text.isEmpty ||
        totalVouchersController.text.isEmpty ||
        maxUsagePerCustomerController.text.isEmpty ||
        startDateController.text.isEmpty ||
        endDateController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ thông tin");
      return false;
    }

    final value = double.tryParse(discountValueController.text);
    if (value == null || value <= 0) {
      Get.snackbar("Lỗi", "Giá trị giảm giá không hợp lệ");
      return false;
    }

    if (discountType.value == 'PERCENTAGE' && value > 100) {
      Get.snackbar("Lỗi", "Phần trăm giảm giá không vượt quá 100%");
      return false;
    }

    return true;
  }

  Future<void> submitVoucher() async {
    if (!validateForm()) return;

    final voucher = Voucher(
      id: editingVoucher?.id ?? 0,
      code: codeController.text,
      discountType: discountType.value,
      discountValue: double.parse(discountValueController.text),
      minOrderValue: double.parse(minOrderValueController.text),
      totalVouchers: int.parse(totalVouchersController.text),
      usedVouchers: editingVoucher?.usedVouchers ?? 0,
      startDate: startDateController.text,
      endDate: endDateController.text,
      maxUsagePerCustomer: int.parse(maxUsagePerCustomerController.text),
      status: 'ACTIVE',
      shopId: shopId,
    );

    try {
      final result = editingVoucher == null
          ? await shopService.addVoucher(voucher)
          : await shopService.updateVoucher(voucher.code, voucher);

      if (result.success) {
        Get.back();
        Get.snackbar("Thành công", editingVoucher == null ? "Đã tạo voucher" : "Đã cập nhật voucher");
      } else {
        Get.snackbar("Lỗi", result.message);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Đã xảy ra lỗi: $e");
    }
  }

  Future<void> pickDate(TextEditingController controller) async {
    DateTime? initialDate = DateTime.now();  // Mặc định ngày hiện tại
    DateTime? firstDate = DateTime.now();  // Mặc định ngày bắt đầu từ hôm nay

    // Kiểm tra nếu là trường "Ngày kết thúc", cần cho phép chọn từ ngày bắt đầu trở đi
    if (controller == endDateController) {
      // Đặt ngày bắt đầu làm ngày tham chiếu cho ngày kết thúc
      DateTime? startDate = DateTime.tryParse(startDateController.text);
      if (startDate != null) {
        initialDate = startDate;  // Ngày kết thúc sẽ bắt đầu từ ngày bắt đầu
        firstDate = startDate;  // Ngày kết thúc không thể chọn trước ngày bắt đầu
      }
    }

    // Hiển thị DatePicker với các điều kiện đã thay đổi
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

}

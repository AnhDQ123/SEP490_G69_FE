import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/voucher.dart';
import '../../../service/shop_service.dart';

class ShopVoucherAddController extends GetxController {
  var codeController = TextEditingController();
  var discountType = 'PERCENTAGE'.obs;
  var discountValueController = TextEditingController();
  var minOrderValueController = TextEditingController();
  var totalVouchersController = TextEditingController();
  var maxUsagePerCustomerController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();

  final ShopService shopService = ShopService();

  // Hàm khởi tạo cho màn chỉnh sửa (edit)
  void initialize(Voucher voucher) {
    codeController.text = voucher.code;
    discountType.value = voucher.discountType;
    discountValueController.text = voucher.discountValue.toString();
    minOrderValueController.text = voucher.minOrderValue.toString();
    totalVouchersController.text = voucher.totalVouchers.toString();
    maxUsagePerCustomerController.text = voucher.maxUsagePerCustomer.toString();
    startDateController.text = voucher.startDate;
    endDateController.text = voucher.endDate;
  }

  // Hàm tạo voucher
  Future<void> addVoucher() async {
    final voucher = Voucher(
      id: 0,
      code: codeController.text,
      discountType: discountType.value,
      discountValue: double.parse(discountValueController.text),
      minOrderValue: double.parse(minOrderValueController.text),
      totalVouchers: int.parse(totalVouchersController.text),
      usedVouchers: 0,
      startDate: startDateController.text,
      endDate: endDateController.text,
      maxUsagePerCustomer: int.parse(maxUsagePerCustomerController.text),
      status: 'ACTIVE',
      shopId: 1,  // shopId cần phải được xác định
    );

    try {
      final result = await shopService.addVoucher(voucher);
      if (result.success) {
        Get.snackbar("Thành công", "Đã tạo mới voucher");
        Get.back();
      } else {
        Get.snackbar("Lỗi", "Không thể tạo voucher");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tạo voucher");
    }
  }

  Future<void> updateVoucher(int voucherId) async {

  }

}

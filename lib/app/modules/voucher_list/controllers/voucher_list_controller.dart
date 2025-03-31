import 'package:get/get.dart';

import '../../../models/voucher_model.dart';

class VoucherListController extends GetxController {
  var vouchers = <VoucherModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVouchers();
  }

  void fetchVouchers() async {
    isLoading.value = true;

    await Future.delayed(Duration(milliseconds: 500));

    vouchers.value = [
      VoucherModel(
        id: 1,
        code: 'NEWYEAR25',
        discountPercentage: 25,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 1, 31),
        status: VoucherStatus.ACTIVE,
        shopId: 123,
        usedCount: 42,
      ),
      VoucherModel(
        id: 2,
        code: 'SALE50',
        discountPercentage: 50,
        startDate: DateTime(2025, 2, 1),
        endDate: DateTime(2025, 2, 15),
        status: VoucherStatus.INACTIVE,
        shopId: 123,
        usedCount: 18,
      ),
      VoucherModel(
        id: 3,
        code: 'FREESHIP30',
        discountPercentage: 30,
        startDate: DateTime(2025, 3, 1),
        endDate: DateTime(2025, 3, 31),
        status: VoucherStatus.PENDING,
        shopId: 123,
        usedCount: 8,
      ),
    ];

    isLoading.value = false;
  }


  void deleteVoucher(int id) {
    vouchers.removeWhere((v) => v.id == id);
  }
}

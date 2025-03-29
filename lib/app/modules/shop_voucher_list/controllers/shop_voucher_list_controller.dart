import 'package:get/get.dart';
import '../../../models/voucher.dart';
import '../../../service/shop_service.dart';

class ShopVoucherListController extends GetxController {
  var vouchers = <Voucher>[].obs;  // Danh sách voucher
  var filteredVouchers = <Voucher>[].obs; // Danh sách voucher sau khi lọc
  final ShopService shopService = ShopService();

  @override
  void onInit() {
    super.onInit();
    fetchVouchers();  // Tải danh sách voucher khi khởi tạo
  }

  // Lấy danh sách voucher theo shopId
  Future<void> fetchVouchers() async {
    try {
      final vouchersList = await shopService.fetchVouchersByShop(1);  // shopId là 1 (có thể thay đổi theo nhu cầu)
      vouchers.assignAll(vouchersList);
      filteredVouchers.assignAll(vouchersList); // Cập nhật danh sách đã lọc
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách voucher");
    }
  }

  // Xoá voucher
  Future<void> deleteVoucher(int voucherId) async {
    try {
      final result = await shopService.deleteVoucher(voucherId);
      print(voucherId);
      if (result.success) {
        Get.snackbar("Thành công", "Đã xoá voucher");
        fetchVouchers();  // Sau khi xoá, tải lại danh sách voucher
      } else {
        Get.snackbar("Thất bại", result.message);
        print(result.message);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể xoá voucher");
    }
  }

  // Lọc voucher theo trạng thái
  void filterVouchers(String status) {
    if (status == "Tất cả") {
      filteredVouchers.assignAll(vouchers);
    } else {
      filteredVouchers.assignAll(
        vouchers.where((voucher) => voucher.status == status).toList(),
      );
    }
  }
}

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/voucher.dart';
import '../../../service/shop_service.dart';
import '../../shop_menu/controllers/shop_controller.dart';

class ShopVoucherListController extends GetxController {
  final vouchers = <Voucher>[].obs;
  final filteredVouchers = <Voucher>[].obs;
  final shopService = ShopService();

  final RxnString selectedStatus = RxnString(); // null = tất cả
  final RxnString selectedDiscountType = RxnString(); // null = tất cả
  final RxString searchKeyword = ''.obs;
  final Rx<VoucherSortType> sortType = VoucherSortType.none.obs;
  final shopId = Get.find<ShopController>().shopId;


  @override
  void onInit() {
    super.onInit();
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    try {
      final list = await shopService.fetchVouchersByShop(shopId);
      vouchers.assignAll(list);
      applyFilter();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách voucher");
    }
  }

  Future<void> deleteVoucher(String code) async {
    try {
      final result = await shopService.deleteVoucher(code);
      if (result.success) {
        Get.snackbar("Thành công", "Đã xoá voucher");
        await fetchVouchers();
      } else {
        Get.snackbar("Thất bại", result.message);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể xoá voucher: $e");
    }
  }


  void filterByStatus(String? status) {
    selectedStatus.value = status; // null = tất cả
    applyFilter();
  }

  void applyFilter() {
    filteredVouchers.value = vouchers.where((v) {
      final matchStatus = selectedStatus.value == null || v.status == selectedStatus.value;
      final matchType = selectedDiscountType.value == null || v.discountType.toUpperCase() == selectedDiscountType.value;
      final matchSearch = v.code.toLowerCase().contains(searchKeyword.value.toLowerCase());
      return matchStatus && matchType && matchSearch;
    }).toList();

    _applySort();
  }

  void _applySort() {
    switch (sortType.value) {
      case VoucherSortType.nameAsc:
        filteredVouchers.sort((a, b) => a.code.compareTo(b.code));
        break;
      case VoucherSortType.nameDesc:
        filteredVouchers.sort((a, b) => b.code.compareTo(a.code));
        break;
      case VoucherSortType.valueAsc:
        filteredVouchers.sort((a, b) => a.discountValue.compareTo(b.discountValue));
        break;
      case VoucherSortType.valueDesc:
        filteredVouchers.sort((a, b) => b.discountValue.compareTo(a.discountValue));
        break;
      case VoucherSortType.startDateAsc:
        filteredVouchers.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case VoucherSortType.startDateDesc:
        filteredVouchers.sort((a, b) => b.startDate.compareTo(a.startDate));
        break;
      case VoucherSortType.none:
      default:
        break;
    }
  }

  String formatCurrency(num amount) {
    final format = NumberFormat("#,##0", "vi_VN");
    return "${format.format(amount)}đ";
  }
}

enum VoucherSortType {
  none,
  nameAsc,
  nameDesc,
  valueAsc,
  valueDesc,
  startDateAsc,
  startDateDesc,
}
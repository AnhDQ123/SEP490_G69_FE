// import 'package:get/get.dart';
// import '../../../service/filter_api_service.dart';
//
// class FilterController extends GetxController {
//   final String categoryName = Get.arguments['categoryName'] as String;
//   final products = <Map<String, dynamic>>[].obs;
//   var selectedTabIndex = 0.obs;
//   var bottomNavIndex = 2.obs;
//
//   final FilterApiService _filterApiService = FilterApiService();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProductsByCategory(categoryName);
//   }
//
//   void fetchProductsByCategory(String category) async {
//     try {
//       final result = await _filterApiService.fetchProductsByCategory(category);
//       products.assignAll(result);
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
//     }
//   }
//
//   void switchTopTab(int index) {
//     selectedTabIndex.value = index;
//   }
//
//   void switchBottomNav(int index) {
//     bottomNavIndex.value = index;
//     switch (index) {
//       case 0:
//       // Xử lý điều hướng Blog
//         break;
//       case 1:
//       // Xử lý điều hướng Danh mục
//         break;
//       case 2:
//         Get.back();
//         break;
//       case 3:
//       // Xử lý điều hướng Giỏ hàng
//         break;
//       case 4:
//       // Xử lý điều hướng Cá nhân
//         break;
//     }
//   }
// }
//

import 'package:get/get.dart';
import '../../../service/filter_api_service.dart';
import '../../../service/home_api_service.dart';

class FilterController extends GetxController {
  // Sử dụng RxString để có thể cập nhật giá trị filter động
  final RxString filterCategory = (Get.arguments['categoryName'] as String).obs;

  // Danh sách sản phẩm hiện ra, kiểu Map<String, dynamic> (có thể điều chỉnh nếu dùng model khác)
  final products = <Map<String, dynamic>>[].obs;
  var selectedTabIndex = 0.obs;
  var bottomNavIndex = 2.obs;

  // Service để gọi API lọc theo danh mục
  final FilterApiService _filterApiService = FilterApiService();
  // Service dùng để lấy toàn bộ sản phẩm (API từ HomeApiService)
  final HomeApiService _homeApiService = HomeApiService();

  @override
  void onInit() {
    super.onInit();
    if (filterCategory.value.isNotEmpty) {
      fetchProductsByCategory(filterCategory.value);
    } else {
      fetchAllProducts();
    }
  }

  // Gọi API lọc theo danh mục
  void fetchProductsByCategory(String category) async {
    try {
      final result = await _filterApiService.fetchProductsByCategory(category);
      products.assignAll(result);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
    }
  }

  // Gọi API lấy toàn bộ sản phẩm
  void fetchAllProducts() async {
    try {
      final result = await _homeApiService.fetchAllProducts();
      // Giả sử model Product có phương thức toJson(), chuyển đổi sang Map nếu cần
      products.assignAll(result.map((p) => p.toJson()).toList());
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
    }
  }

  // Phương thức xoá filter: đặt filterCategory rỗng và lấy toàn bộ sản phẩm
  void removeCategoryFilter() async {
    try {
      filterCategory.value = '';
      fetchAllProducts();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
    }
  }

  void switchTopTab(int index) {
    selectedTabIndex.value = index;
    // Nếu cần xử lý lọc/sắp xếp theo tab, xử lý tại đây
  }

  void switchBottomNav(int index) {
    bottomNavIndex.value = index;
    switch (index) {
      case 0: // Blog
        break;
      case 1: // Danh mục
        break;
      case 2: // Trang chủ
        Get.back();
        break;
      case 3: // Giỏ hàng
        break;
      case 4: // Cá nhân
        break;
    }
  }
}

// // import 'package:get/get.dart';
// // import '../../../service/filter_api_service.dart';
// //
// // class FilterController extends GetxController {
// //   final String categoryName = Get.arguments['categoryName'] as String;
// //   final products = <Map<String, dynamic>>[].obs;
// //   var selectedTabIndex = 0.obs;
// //   var bottomNavIndex = 2.obs;
// //
// //   final FilterApiService _filterApiService = FilterApiService();
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchProductsByCategory(categoryName);
// //   }
// //
// //   void fetchProductsByCategory(String category) async {
// //     try {
// //       final result = await _filterApiService.fetchProductsByCategory(category);
// //       products.assignAll(result);
// //     } catch (e) {
// //       Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
// //     }
// //   }
// //
// //   void switchTopTab(int index) {
// //     selectedTabIndex.value = index;
// //   }
// //
// //   void switchBottomNav(int index) {
// //     bottomNavIndex.value = index;
// //     switch (index) {
// //       case 0:
// //       // Xử lý điều hướng Blog
// //         break;
// //       case 1:
// //       // Xử lý điều hướng Danh mục
// //         break;
// //       case 2:
// //         Get.back();
// //         break;
// //       case 3:
// //       // Xử lý điều hướng Giỏ hàng
// //         break;
// //       case 4:
// //       // Xử lý điều hướng Cá nhân
// //         break;
// //     }
// //   }
// // }
// //
//
// import 'package:get/get.dart';
// import '../../../service/filter_api_service.dart';
// import '../../../service/home_api_service.dart';
//
// class FilterController extends GetxController {
//   // Sử dụng RxString để có thể cập nhật giá trị filter động
//   final RxString filterCategory = (Get.arguments['categoryName'] as String).obs;
//
//   // Danh sách sản phẩm hiện ra, kiểu Map<String, dynamic> (có thể điều chỉnh nếu dùng model khác)
//   final products = <Map<String, dynamic>>[].obs;
//   var selectedTabIndex = 0.obs;
//   var bottomNavIndex = 2.obs;
//
//   // Service để gọi API lọc theo danh mục
//   final FilterApiService _filterApiService = FilterApiService();
//   // Service dùng để lấy toàn bộ sản phẩm (API từ HomeApiService)
//   final HomeApiService _homeApiService = HomeApiService();
//
//   @override
//   void onInit() {
//     super.onInit();
//     if (filterCategory.value.isNotEmpty) {
//       fetchProductsByCategory(filterCategory.value);
//     } else {
//       fetchAllProducts();
//     }
//   }
//
//   // Gọi API lọc theo danh mục
//   void fetchProductsByCategory(String category) async {
//     try {
//       final result = await _filterApiService.fetchProductsByCategory(category);
//       products.assignAll(result);
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
//     }
//   }
//
//   // Gọi API lấy toàn bộ sản phẩm
//   void fetchAllProducts() async {
//     try {
//       final result = await _homeApiService.fetchAllProducts();
//       // Giả sử model Product có phương thức toJson(), chuyển đổi sang Map nếu cần
//       products.assignAll(result.map((p) => p.toJson()).toList());
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
//     }
//   }
//
//   // Phương thức xoá filter: đặt filterCategory rỗng và lấy toàn bộ sản phẩm
//   void removeCategoryFilter() async {
//     try {
//       filterCategory.value = '';
//       fetchAllProducts();
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
//     }
//   }
//
//   void switchTopTab(int index) {
//     selectedTabIndex.value = index;
//     // Nếu cần xử lý lọc/sắp xếp theo tab, xử lý tại đây
//   }
//
//   void switchBottomNav(int index) {
//     bottomNavIndex.value = index;
//     switch (index) {
//       case 0: // Blog
//         break;
//       case 1: // Danh mục
//         break;
//       case 2: // Trang chủ
//         Get.back();
//         break;
//       case 3: // Giỏ hàng
//         break;
//       case 4: // Cá nhân
//         break;
//     }
//   }
// }

import 'package:get/get.dart';
import '../../../models/product.dart';
import '../../../service/filter_api_service.dart';
import '../../../service/home_api_service.dart';
import '../../../service/product_detail_service.dart';
import '../../../service/search_service.dart';

class FilterController extends GetxController {
  final RxString filterCategory = (Get.arguments?['categoryName'] ?? '').toString().obs;
  final RxBool isSearch = false.obs;  // Biến này sẽ giúp xác định xem người dùng đang tìm kiếm hay lọc theo category

  final products = <Product>[].obs;
  var selectedTabIndex = 0.obs;
  var bottomNavIndex = 2.obs;

  final FilterApiService _filterApiService = FilterApiService();
  final HomeApiService _homeApiService = HomeApiService();
  final ProductDetailApiService _productDetailApiService = ProductDetailApiService();

  @override
  void onInit() {
    super.onInit();

    final keyword = Get.arguments?['searchKeyword'];
    final category = Get.arguments?['categoryName'];

    if (keyword != null && keyword.toString().isNotEmpty) {
      print('🔍 Search mode with keyword: $keyword'); // 👈 THÊM LOG
      isSearch.value = true;
      fetchSimilarProducts(keyword.toString());
    } else if (category != null && category.toString().isNotEmpty) {
      isSearch.value = false;
      filterCategory.value = category.toString();
      fetchProductsByCategory(category.toString());
    } else {
      isSearch.value = false;
      fetchAllProducts();
    }
  }




  // Gọi API lọc theo danh mục
  void fetchProductsByCategory(String category) async {
    isSearch.value = false;  // Đánh dấu là người dùng đang lọc theo danh mục
    try {
      final result = await _filterApiService.fetchProductsByCategory(category);
      products.assignAll(result.map((p) => Product.fromJson(p)).toList());
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
    }
  }

  // Gọi API lấy sản phẩm tương tự (sử dụng từ khóa tìm kiếm)
  void fetchSimilarProducts(String keyword) async {
    isSearch.value = true;
    try {
      print('📨 Sending keyword to API: "$keyword"');
      final result = await _productDetailApiService.getSimilarProducts(keyword);
      products.assignAll(result);  // Vì getSimilarProducts() đã trả về List<Product>
      print('📦 Loaded similar products: ${products.length}');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải sản phẩm tương tự: $e');
    }
  }




  // Gọi API lấy toàn bộ sản phẩm
  void fetchAllProducts() async {
    isSearch.value = false;  // Đánh dấu là người dùng không tìm kiếm
    try {
      final result = await _homeApiService.fetchAllProducts();
      products.assignAll(result.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
    }
  }

  // API lấy sản phẩm bán chạy (Popular)
  void fetchPopularProducts() async {
    try {
      final result = await _homeApiService.fetchPopularProducts();

      // Kiểm tra dữ liệu trả về
      print('📦 Loaded popular products: $result');

      // Chuyển đổi dữ liệu trả về thành List<Product>
      products.assignAll(result.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList());
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải sản phẩm bán chạy: $e');
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

  // Chuyển tab: 0 - Các sản phẩm, 1 - Bán chạy, 2 - Đánh giá, 3 - Giá
  void switchTopTab(int index) {
    selectedTabIndex.value = index;
    if (index == 0) {
      if (filterCategory.value.isNotEmpty) {
        fetchProductsByCategory(filterCategory.value);  // Nếu lọc theo danh mục
      } else {
        fetchAllProducts();  // Nếu không lọc theo danh mục, lấy tất cả sản phẩm
      }
    } else if (index == 1) {
      fetchPopularProducts();  // Lấy sản phẩm bán chạy
    } else if (index == 2) {
      // Xử lý nếu cần: ví dụ, sắp xếp hoặc lọc theo đánh giá
    } else if (index == 3) {
      // Xử lý nếu cần: ví dụ, sắp xếp theo giá (defaultPrice)
    }
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

  void testCall() async {
    final result = await SearchService().searchProducts("Bánh mì");
    print("✅ API test: $result");
  }

}


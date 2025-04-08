// import 'package:get/get.dart';
// import '../../../models/product.dart';
// import '../../../service/filter_api_service.dart';
// import '../../../service/home_api_service.dart';
// import '../../../service/product_detail_service.dart';
// import '../../../service/search_service.dart';
//
// class FilterController extends GetxController {
//   // Thêm .obs cho các biến cần theo dõi
//   final RxString filterCategory = (Get.arguments?['categoryName'] ?? '').toString().obs;
//   final RxString searchKeyword = (Get.arguments?['searchKeyword'] ?? '').toString().obs;
//   final RxBool isSearch = false.obs;
//
//   final products = <Product>[].obs;
//   var selectedTabIndex = 0.obs;
//   var bottomNavIndex = 2.obs;
//
//   final FilterApiService _filterApiService = FilterApiService();
//   final HomeApiService _homeApiService = HomeApiService();
//   final ProductDetailApiService _productDetailApiService = ProductDetailApiService();
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     _handleInitialLoad();
//
//     // Thêm listener để theo dõi thay đổi
//     ever(filterCategory, (_) => _fetchProducts());
//     ever(searchKeyword, (_) => _fetchProducts());
//   }
//
//   void _handleInitialLoad() {
//     if (searchKeyword.value.isNotEmpty) {
//       print('🔍 Search mode with keyword: ${searchKeyword.value}');
//       isSearch.value = true;
//       fetchSimilarProducts(searchKeyword.value);
//     } else if (filterCategory.value.isNotEmpty) {
//       isSearch.value = false;
//       fetchProductsByCategory(filterCategory.value);
//     } else {
//       isSearch.value = false;
//       fetchAllProducts();
//     }
//   }
//
//   void _fetchProducts() {
//     if (isSearch.value) {
//       fetchSimilarProducts(searchKeyword.value);
//     } else if (filterCategory.value.isNotEmpty) {
//       fetchProductsByCategory(filterCategory.value);
//     } else {
//       fetchAllProducts();
//     }
//   }
//
//   // Cập nhật các phương thức API call để clear dữ liệu cũ trước khi fetch mới
//   void fetchProductsByCategory(String category) async {
//     try {
//       products.clear(); // Xóa dữ liệu cũ trước khi load mới
//       final result = await _filterApiService.fetchProductsByCategory(category);
//       products.assignAll(result.map((p) => Product.fromJson(p)).toList());
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
//     }
//   }
//
//   void fetchSimilarProducts(String keyword) async {
//     try {
//       products.clear(); // Xóa dữ liệu cũ trước khi load mới
//       final result = await _productDetailApiService.getSimilarProducts(keyword);
//       products.assignAll(result);
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể tải sản phẩm tương tự: $e');
//     }
//   }
//
//   // Gọi API lấy toàn bộ sản phẩm
//   void fetchAllProducts() async {
//     isSearch.value = false;  // Đánh dấu là người dùng không tìm kiếm
//     try {
//       final result = await _homeApiService.fetchAllProducts();
//       products.assignAll(result.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList());
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
//     }
//   }
//
//   // API lấy sản phẩm bán chạy (Popular)
//   void fetchPopularProducts() async {
//     try {
//       final result = await _homeApiService.fetchPopularProducts();
//
//       // Kiểm tra dữ liệu trả về
//       print('📦 Loaded popular products: $result');
//
//       // Chuyển đổi dữ liệu trả về thành List<Product>
//       products.assignAll(result.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList());
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể tải sản phẩm bán chạy: $e');
//     }
//   }
//
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
//   // Chuyển tab: 0 - Các sản phẩm, 1 - Bán chạy, 2 - Đánh giá, 3 - Giá
//   void switchTopTab(int index) {
//     selectedTabIndex.value = index;
//     if (index == 0) {
//       if (filterCategory.value.isNotEmpty) {
//         fetchProductsByCategory(filterCategory.value);  // Nếu lọc theo danh mục
//       } else {
//         fetchAllProducts();  // Nếu không lọc theo danh mục, lấy tất cả sản phẩm
//       }
//     } else if (index == 1) {
//       fetchPopularProducts();  // Lấy sản phẩm bán chạy
//     } else if (index == 2) {
//       // Xử lý nếu cần: ví dụ, sắp xếp hoặc lọc theo đánh giá
//     } else if (index == 3) {
//       // Xử lý nếu cần: ví dụ, sắp xếp theo giá (defaultPrice)
//     }
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
//
//   void testCall() async {
//     final result = await SearchService().searchProducts("Bánh mì");
//     print("✅ API test: $result");
//   }
//
// }
//

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../models/product.dart';
import '../../../service/filter_api_service.dart';
import '../../../service/home_api_service.dart';
import '../../../service/product_detail_service.dart';
import '../../../service/product_service.dart';
import '../../../service/search_service.dart';

class FilterController extends GetxController {
  // Thêm .obs cho các biến cần theo dõi
  final RxString filterCategory = (Get.arguments?['categoryName'] ?? '').toString().obs;
  final RxString searchKeyword = (Get.arguments?['searchKeyword'] ?? '').toString().obs;
  final RxBool isSearch = false.obs;

  final products = <Product>[].obs;
  var selectedTabIndex = 0.obs;
  var bottomNavIndex = 2.obs;

  final FilterApiService _filterApiService = FilterApiService();
  final HomeApiService _homeApiService = HomeApiService();
  final ProductDetailApiService _productDetailApiService = ProductDetailApiService();
  final ProductService _productService = ProductService();


  final ScrollController scrollController = ScrollController();
  final RxBool isInitialLoading = true.obs; // Cho lần load đầu tiên
  var currentPage = 1.obs;           // Trang hiện tại
  var isLoading = false.obs;         // Trạng thái đang load dữ liệu
  var hasMore = true.obs;            // Kiểm tra còn dữ liệu hay không
  final int pageSize = 10;           // Số sản phẩm mỗi trang


  @override
  void onInit() {
    super.onInit();
    _handleInitialLoad();

    scrollController.addListener(_scrollListener);

    // Thêm listener để theo dõi thay đổi
    ever(filterCategory, (_) => _fetchProducts());
    ever(searchKeyword, (_) => _fetchProducts());
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    // Chỉ load thêm nếu không có filter search hoặc category
    if (!isSearch.value && filterCategory.value.isEmpty) {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
        if (!isLoading.value && hasMore.value) {
          _fetchProducts(isLoadMore: true);
        }
      }
    }
  }


  void _handleInitialLoad() {
    if (searchKeyword.value.isNotEmpty) {
      print('🔍 Search mode with keyword: ${searchKeyword.value}');
      isSearch.value = true;
      fetchSimilarProducts(searchKeyword.value);
    } else if (filterCategory.value.isNotEmpty) {
      isSearch.value = false;
      fetchProductsByCategory(filterCategory.value);
    } else {
      isSearch.value = false;
      fetchAllProducts();
    }
  }

  void _fetchProducts({bool isLoadMore = false}) {
    if (isSearch.value) {
      fetchSimilarProducts(searchKeyword.value);
    } else if (filterCategory.value.isNotEmpty) {
      fetchProductsByCategory(filterCategory.value);
    } else {
      fetchAllProducts(isLoadMore: isLoadMore);
    }
  }


  // Cập nhật các phương thức API call để clear dữ liệu cũ trước khi fetch mới
  void fetchProductsByCategory(String category) async {
    try {
      products.clear(); // Xóa dữ liệu cũ trước khi load mới
      final result = await _filterApiService.fetchProductsByCategory(category);
      products.assignAll(result.map((p) => Product.fromJson(p)).toList());
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
    }
  }

  void fetchSimilarProducts(String keyword) async {
    try {
      products.clear(); // Xóa dữ liệu cũ trước khi load mới
      final result = await _productDetailApiService.getSimilarProducts(keyword);
      products.assignAll(result);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải sản phẩm tương tự: $e');
    }
  }


  // Gọi API lấy toàn bộ sản phẩm
  void fetchAllProducts({bool isLoadMore = false}) async {
    if (isLoading.value) return;
    if (isLoadMore && !hasMore.value) return;

    try {
      if (!isLoadMore) {
        products.clear();
        currentPage.value = 1;
        hasMore.value = true;
      }

      isLoading.value = true;

      final result = await _productService.fetchAllProducts(
          page: currentPage.value,
          size: pageSize
      );

      if (isLoadMore) {
        products.addAll(result);
      } else {
        products.assignAll(result);
      }

      hasMore.value = result.length >= pageSize;
      if (hasMore.value) currentPage.value++;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu sản phẩm: $e');
    } finally {
      isLoading.value = false;
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
  void removeCategoryFilter() {
    filterCategory.value = '';
    searchKeyword.value = '';
    isSearch.value = false;
    fetchAllProducts(); // Sẽ tự động reset trang và clear dữ liệu cũ
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



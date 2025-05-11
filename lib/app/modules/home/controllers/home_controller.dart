import 'package:ffb_fe_flutter/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../base/base_common.dart';
import '../../../models/banner.dart';
import '../../../service/home_api_service.dart';

class HomeController extends GetxController {
  // (0 = Đồ ăn, 1 = Chợ tươi sống)
  var selectedFoodTab = 0.obs;
  // Current index của BottomNav (2 = "Trang chủ" mặc định)
  var bottomNavIndex = 2.obs;
  // Banner
  final currentBannerIndex = 0.obs;
  var categoryList = <dynamic>[].obs;
  var productList = <Product>[].obs;

  // Dữ liệu từ API:
  var popularProductList = <Product>[].obs;   // Món ăn bán chạy (getPopular)
  var freshProductList = <Product>[].obs;       // Chợ tươi sống (getFresh)
  var cookedProductList = <Product>[].obs;      // Đồ ăn (getCooked)

  var bannerList = <BannerDTO>[].obs; // 👈 Thay vì List<String> → List<BannerDTO>

  final isLoading = false.obs;



  // Service gọi API
  final HomeApiService _apiService = HomeApiService();

  @override
  void onInit() {
    super.onInit();
    final userId = BaseCommon.instance.userId;
    print('🆔 User đang đăng nhập có ID: $userId');
    fetchCategories(page: 0, size: 20);
    fetchAllProducts();
    fetchPopularProducts();
    fetchFreshProducts();
    fetchCookedProducts();
    fetchBanners();
  }

  Future<void> refreshAllData() async {
    isLoading.value = true;
    try {
      await fetchCategories(page: 0, size: 20);
      await fetchAllProducts();
      await fetchPopularProducts();
      await fetchFreshProducts();
      await fetchCookedProducts();
      await fetchBanners();
    } catch (e) {
      print("❌ Lỗi khi refreshAllData: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchBanners() async {
    try {
      final data = await _apiService.fetchBanners();
      bannerList.value = data;
    } catch (e) {
      print('Lỗi khi fetch banners: $e');
    }
  }

  //call api category
  // Cập nhật phương thức fetchCategories với các tham số phân trang
  Future<void> fetchCategories({String? name, int page = 0, int size = 20}) async {
    try {
      final data = await _apiService.fetchCategories(name: name, page: page + 1, size: size);
      print('API categories data: $data');
      categoryList.value = data;
    } catch (e) {
      print('Lỗi khi fetch categories: $e');
    }
  }


  //API để lấy danh sách sản phẩm
  Future<void> fetchAllProducts() async {
    try {
      final data = await _apiService.fetchAllProducts();
      productList.value = data;
    } catch (e) {
      print('Lỗi khi fetch sản phẩm: $e');
    }
  }

  //API lấy danh sách sản phẩm bán chạy (getPopular)
  Future<void> fetchPopularProducts() async {
    try {
      final data = await _apiService.fetchPopularProducts();
      popularProductList.value = data;
    } catch (e) {
      print('Lỗi khi fetch món ăn bán chạy: $e');
    }
  }

  //API lấy sản phẩm chợ tươi sống (getFresh)
  Future<void> fetchFreshProducts() async {
    final userId = BaseCommon.instance.userId;

    // Chuyển userId từ String? thành int
    int userIdInt = int.tryParse(userId ?? '') ?? 0;

    try {
      final data = await _apiService.fetchFreshProducts(userId: userIdInt, top: 30);
      freshProductList.value = data;
    } catch (e) {
      print('Lỗi khi fetch sản phẩm chợ tươi sống: $e');
    }
  }



  //API lấy sản phẩm đồ ăn (getCooked)
  Future<void> fetchCookedProducts() async {
    final userId = BaseCommon.instance.userId;

    // Chuyển userId từ String? thành int
    int userIdInt = int.tryParse(userId ?? '') ?? 0;

    try {
      final data = await _apiService.fetchCookedProducts(userId: userIdInt, top: 30);
      cookedProductList.value = data;
    } catch (e) {
      print('Lỗi khi fetch sản phẩm đồ ăn: $e');
    }
  }



  //(0) cookedProductList,
  //(1) freshProductList.
  List<Product> get currentList =>
      selectedFoodTab.value == 0 ? cookedProductList : freshProductList;

  void switchFoodTab(int tabIndex) {
    selectedFoodTab.value = tabIndex;
  }

  void switchBottomNav(int index) {
    bottomNavIndex.value = index;
  }


}
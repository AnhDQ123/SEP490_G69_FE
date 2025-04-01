import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/service/shop_service.dart';

import '../../../service/product_service.dart';  // Import ShopService

class UserViewShopDetailController extends GetxController {
  // Các biến để lưu trữ thông tin shop
  var shopName = ''.obs;
  var shopDescription = ''.obs;
  var shopRate = 0.0.obs;
  var shopLogo = ''.obs;
  var shopBackgroundImage = ''.obs;
  var menuImage = ''.obs;
  var isLoading = true.obs;

  // Các biến để lưu trữ thông tin sản phẩm bán chạy
  var topSellingProducts = <Map<String, dynamic>>[].obs;

  final ShopService shopService = ShopService();  // Tạo instance của ShopService
  final ProductService productService = ProductService();  // Tạo instance của ProductService

  @override
  void onInit() {
    super.onInit();
    fetchShopDetails(1);  // Lấy thông tin shop với shopId là 1 (hoặc bất kỳ ID nào)
    fetchTopSellingProducts('1');  // Lấy sản phẩm bán chạy trong tháng của shopId 1 (đảm bảo shopId là String)
  }

  // Hàm gọi API để lấy thông tin shop
  Future<void> fetchShopDetails(int shopId) async {
    try {
      isLoading(true);  // Bắt đầu loading
      final shopData = await shopService.fetchShopProfile(shopId);  // Gọi API
      // Cập nhật các thông tin shop sau khi lấy được dữ liệu
      shopName.value = shopData.name;
      shopDescription.value = shopData.description ?? '';
      shopRate.value = shopData.rate;
      shopLogo.value = shopData.logo;
      shopBackgroundImage.value = shopData.backgroundImage;
      menuImage.value = shopData.menu ?? '';
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);  // Kết thúc loading
    }
  }

  // Hàm gọi API để lấy sản phẩm bán chạy trong tháng
  Future<void> fetchTopSellingProducts(String shopId) async {
    try {
      isLoading(true);  // Bắt đầu loading
      final products = await productService.getTopSellingProductsThisMonth(shopId);  // Gọi API
      topSellingProducts.value = products;  // Cập nhật danh sách sản phẩm bán chạy
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);  // Kết thúc loading
    }
  }
}


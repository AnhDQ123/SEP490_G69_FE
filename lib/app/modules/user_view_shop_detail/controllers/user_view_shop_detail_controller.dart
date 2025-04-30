import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/service/shop_service.dart';

import '../../../models/top_product.dart';
import '../../../service/product_service.dart';  // Import ShopService

class UserViewShopDetailController extends GetxController {
  // Các biến để lưu trữ thông tin shop
  var shopName = ''.obs;
  var shopDescription = Rx<String?>(null); // Thêm nullable
  var shopRate = 0.0.obs;
  var shopLogo = Rx<String?>(null);
  var shopBackgroundImage = Rx<String?>(null);
  var menuImage = Rx<String?>(null);
  var shopAddress = Rx<String?>(null); // Thêm nullable
  var shopPhone = Rx<String?>(null);
  var isLoading = true.obs;
  var shopOpenTime = ''.obs;
  var shopCloseTime = ''.obs;


  // Các biến để lưu trữ thông tin sản phẩm bán chạy
  var topSellingProducts = <TopProduct>[].obs;

  final String? shopNameFromArgs = Get.arguments?['shopName'];
  final int? shopIdFromArgs = Get.arguments?['shopId'];

  final ShopService shopService = ShopService();
  final ProductService productService = ProductService();

  @override
  void onInit() {
    super.onInit();
    // Use the passed shopId or default to 1 if not provided
    final shopId = shopIdFromArgs ?? 1;
    print("🏪 Đang tải thông tin cửa hàng ID: $shopId");
    print("🛒 Tham số nhận được - shopId: $shopIdFromArgs, shopName: $shopNameFromArgs");

    fetchShopDetails(shopId);

    fetchTopSellingProducts(shopId.toString());
  }

  // Hàm gọi API để lấy thông tin shop
  Future<void> fetchShopDetails(int shopId) async {
    try {
      isLoading(true);
      final shopData = await shopService.fetchShopProfile(shopId);
      print('📦 shopData.openTime: ${shopData.openTime}');
      print('📦 shopData.closeTime: ${shopData.closeTime}');
      print('📦 shopData.address: ${shopData.address}');


      // Xử lý các trường có thể null
      shopName.value = shopData.name ?? 'Không có tên';
      shopDescription.value = shopData.description; // Có thể null
      shopRate.value = shopData.rate ?? 0.0;
      shopLogo.value = shopData.logo; // Có thể null
      shopBackgroundImage.value = shopData.backgroundImage; // Có thể null
      menuImage.value = shopData.menu; // Có thể null
      shopAddress.value = shopData.address; // Có thể null
      shopPhone.value = shopData.phone; // Có thể null
      shopOpenTime.value = shopData.openTime.substring(0, 5);
      shopCloseTime.value = shopData.closeTime.substring(0, 5);

    } catch (e) {
      print('Error: $e');
      Get.snackbar('Lỗi', 'Không thể tải thông tin cửa hàng');
    } finally {
      isLoading(false);
    }
  }

  // Hàm gọi API để lấy sản phẩm bán chạy trong tháng
  Future<void> fetchTopSellingProducts(String shopId) async {
    try {
      isLoading(true);
      final products = await productService.getTopSellingProductsThisMonth(shopId);
      topSellingProducts.value = products;
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Lỗi', 'Không thể tải sản phẩm bán chạy');
    } finally {
      isLoading(false);
    }
  }


  Future<void> submitShopRating(double rating) async {
    if (shopIdFromArgs == null) return;
    final result = await shopService.rateShop(shopId: shopIdFromArgs!, newRate: rating);

    if (result.success) {
      // Cập nhật lại dữ liệu cửa hàng sau khi đánh giá
      await fetchShopDetails(shopIdFromArgs!);
      Get.snackbar('Thành công', result.message);
    } else {
      Get.snackbar('Lỗi', result.message);
    }
  }

}


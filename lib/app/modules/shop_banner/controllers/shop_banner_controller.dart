import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../models/banner.dart';
import '../../../service/shop_service.dart';

class ShopBannerController extends GetxController {
  var banners = <BannerDTO>[].obs;
  int shopId = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    shopId = args['shopId'];
    print("📦 Shop ID nhận được: $shopId"); // kiểm tra
    fetchBanners();
  }

  void fetchBanners() async {
    try {
      final result = await ShopService().fetchBannersByShop(shopId);
      banners.value = result;
    } catch (e) {
      print('❌ Lỗi khi lấy banners: $e');
    }
  }
}

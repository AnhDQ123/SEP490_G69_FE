import 'package:get/get.dart';
import '../../../models/ship_payment.dart';
import '../../../service/shop_service.dart';

class ShopManageShipperController extends GetxController {
  var shipperStats = <ShipPaymentDTO>[].obs;
  var isLoading = true.obs;
  late int shopId;

  @override
  void onInit() {
    super.onInit();
    shopId = Get.arguments['shopId'];
    fetchShipperStats();
  }

  void fetchShipperStats() async {
    try {
      isLoading.value = true;
      final result = await ShopService().fetchShipperPayments(shopId);
      shipperStats.value = result;
    } catch (e) {
      print("❌ Lỗi lấy danh sách shipper: $e");
      shipperStats.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

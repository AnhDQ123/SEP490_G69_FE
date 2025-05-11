import 'package:get/get.dart';
import '../../../service/order_service.dart';
import '../../../service/shipper_service.dart';

class ShipperQrController extends GetxController {
  final qrUrl = RxnString();
  final isLoading = true.obs;
  late int userId;

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments['userId'];
    fetchQr();
  }

  Future<void> fetchQr() async {
    try {
      isLoading.value = true;
      final result = await ShipperService().getQrCodeForShipper(userId);
      qrUrl.value = result;
    } catch (e) {
      print("❌ Lỗi fetch QR shipper: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

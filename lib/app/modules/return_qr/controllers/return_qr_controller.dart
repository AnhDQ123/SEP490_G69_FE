import 'package:get/get.dart';
import '../../../service/order_service.dart';

class ReturnQrController extends GetxController {
  final qrUrl = RxnString();
  final isLoading = true.obs;
  late int orderId;
  late int userId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    orderId = args['orderId'];
    userId = args['userId'];

    fetchQr();
  }

  Future<void> fetchQr() async {
    try {
      final result = await OrderService().generateQrForReturn(orderId, userId);
      qrUrl.value = result;
    } catch (e) {
      print("❌ Lỗi fetchQr: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

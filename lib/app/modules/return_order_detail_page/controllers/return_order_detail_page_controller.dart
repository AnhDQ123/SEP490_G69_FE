import 'package:get/get.dart';
import '../../../models/return_order.dart';
import '../../../service/order_service.dart';

class ReturnOrderDetailController extends GetxController {
  final orderId = 0.obs;
  final returnOrder = Rxn<ReturnOrder>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    orderId.value = Get.arguments;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    try {
      final result = await OrderService().fetchReturnDetail(orderId.value);
      returnOrder.value = result;
    } catch (e) {
      print("❌ Lỗi fetchReturnDetail: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Gọi API đồng ý yêu cầu trả hàng
  Future<void> acceptReturn() async {
    try {
      await OrderService().acceptReturn(orderId.value);
    } catch (e) {
      print("❌ Lỗi acceptReturn: $e");
      rethrow;
    }
  }

  /// ❌ Gọi API từ chối yêu cầu trả hàng
  Future<void> rejectReturn() async {
    try {
      await OrderService().rejectReturn(orderId.value);
    } catch (e) {
      print("❌ Lỗi rejectReturn: $e");
      rethrow;
    }
  }
}

import 'package:get/get.dart';
import '../../../models/cart.dart';

class CheckoutController extends GetxController {
  var selectedCarts = <CartDTO>[].obs; // Danh sách các shop với sản phẩm đã chọn
  var totalAmount = 0.0.obs; // Tổng tiền cần thanh toán

  @override
  void onInit() {
    super.onInit();
    // Nhận danh sách sản phẩm từ Get.arguments
    if (Get.arguments != null && Get.arguments is List<CartDTO>) {
      selectedCarts.assignAll(Get.arguments as List<CartDTO>);
      calculateTotalAmount();
    }
  }

  /// **Tính tổng tiền cần thanh toán**
  void calculateTotalAmount() {
    double total = 0;
    for (var shop in selectedCarts) {
      for (var item in shop.cartItemDTOList) {
        total += item.totalPrice;
        for (var option in item.cartItemOptionDTOList) {
          total += (option.price ?? 0) * option.quantity;
        }
      }
    }
    totalAmount.value = total;
  }

  /// **Xử lý khi nhấn nút "Đặt hàng"**
  void placeOrder() {
    // Thực hiện logic đặt hàng (API, lưu vào DB, v.v.)
    Get.snackbar("Thành công", "Đơn hàng đã được đặt!", snackPosition: SnackPosition.BOTTOM);

    // Quay về trang chính hoặc lịch sử đơn hàng sau khi đặt hàng thành công
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/home'); // Điều hướng về màn hình chính hoặc trang lịch sử đơn hàng
    });
  }
}

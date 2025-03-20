import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item.dart';

class CheckoutView extends StatelessWidget {
  final CheckoutController controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeliveryInfo(),
            _buildCartItems(),
            _buildTotalAmount(),
            _buildPlaceOrderButton(),
          ],
        ),
      ),
    );
  }

  /// **Hiển thị thông tin địa chỉ giao hàng**
  Widget _buildDeliveryInfo() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.red),
        title: const Text("Hoàng Hải Đăng  |  0964937641", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Số nhà 88/155, Xuân Đỉnh, Hà Nội"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  /// **Hiển thị danh sách sản phẩm đã chọn**
  Widget _buildCartItems() {
    return Obx(() {
      return Column(
        children: controller.selectedCarts.map((shop) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    shop.shopName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: shop.cartItemDTOList.map((item) => _buildCartItem(item)).toList(),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  /// **Hiển thị từng sản phẩm trong giỏ hàng**
  Widget _buildCartItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm
          Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 10),

          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("1 x ${item.productName}", style: const TextStyle(fontWeight: FontWeight.bold)),
                if (item.cartItemOptionDTOList.any((opt) => opt.typeId == 2))
                  Text("Size: ${item.cartItemOptionDTOList.firstWhere((opt) => opt.typeId == 2).optionName}"),
                if (item.cartItemOptionDTOList.any((opt) => opt.typeId == 3))
                  Text(
                    "Topping: ${item.cartItemOptionDTOList.where((opt) => opt.typeId == 3).map((opt) => opt.optionName).join(', ')}",
                  ),
              ],
            ),
          ),

          // Giá sản phẩm
          Text("${item.totalPrice}đ"),
        ],
      ),
    );
  }

  /// **Hiển thị tổng tiền**
  Widget _buildTotalAmount() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Tổng tiền:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() => Text("${controller.totalAmount.value}đ",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  /// **Nút đặt hàng**
  Widget _buildPlaceOrderButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () => controller.placeOrder(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Center(
          child: Text("Đặt hàng", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

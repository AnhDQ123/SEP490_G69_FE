import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/cart_item.dart';
import '../controllers/cart_controller.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item_option.dart';

class CartView extends StatelessWidget {
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Checkbox to select all items
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Obx(() {
                  bool allSelected = controller.isAllSelected();
                  return Checkbox(
                    value: allSelected,
                    onChanged: (bool? value) {
                      controller.toggleSelectAll(value ?? false);
                    },
                  );
                }),
                const Text("Chọn tất cả", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          // List of shops and their items
          Expanded(
            child: Obx(() {
              if (controller.carts.isEmpty) {
                return const Center(child: Text("Giỏ hàng trống"));
              }
              return ListView(
                children: controller.carts.map((shop) => _buildShopSection(shop)).toList(),
              );
            }),
          ),

          // Total amount and checkout button
          _buildTotalSection(),
        ],
      ),
    );
  }

  /// Widget to display a shop and its items
  Widget _buildShopSection(Cart shop) {
    return Card(
      margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Đảm bảo các item nằm trên cùng 1 hàng
              children: [
                const SizedBox(width: 8),
                // Checkbox chọn shop
                Obx(() {
                  bool isShopSelected = controller.isShopSelected(shop.shopId);
                  return Checkbox(
                    value: isShopSelected,
                    onChanged: (bool? value) {
                      controller.toggleShopSelection(shop.shopId, value ?? false);
                    },
                  );
                }),

                // Icon cửa hàng + tên cửa hàng
                const Icon(Icons.store, size: 24, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    shop.shopName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Nút xóa shop
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.removeShop(shop.shopId),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Danh sách sản phẩm
            Column(
              children: shop.cartItemDTOList.map((item) => _buildCartItem(shop.shopId, item)).toList(),
            ),
          ],
        ),
    );
  }

  /// Widget to display a single cart item
  Widget _buildCartItem(int shopId, CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox chọn sản phẩm
                Obx(() {
                  bool isSelected = controller.selectedItems[shopId]?.contains(item.productId) ?? false;
                  return Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      controller.toggleItemSelection(shopId, item.productId, value ?? false);
                    },
                  );
                }),

                // Hình ảnh sản phẩm
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.image ?? 'https://via.placeholder.com/100',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/default_food.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Thông tin sản phẩm
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên sản phẩm
                      Text(
                        item.productName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      // Chọn Size
                      if (item.cartItemOptionDTOList.any((option) => option.typeId == 2))
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CartItemOption>(
                              isDense: true,
                              value: item.cartItemOptionDTOList.firstWhere((option) => option.typeId == 2),
                              items: item.cartItemOptionDTOList
                                  .where((option) => option.typeId == 2)
                                  .map((option) => DropdownMenuItem(
                                value: option,
                                child: Text(option.optionName, style: const TextStyle(fontSize: 12)),
                              ))
                                  .toList(),
                              onChanged: (newSize) {
                                if (newSize != null) {
                                  controller.updateSize(shopId, item.productId, newSize);
                                }
                              },
                              icon: const Icon(Icons.arrow_drop_down, size: 12),
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),

                      // Giá sản phẩm
                      Text(
                        "${controller.formatCurrency(item.price ?? item.totalPrice / item.quantity)}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Nút xóa sản phẩm
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => controller.removeItem(shopId, item.productId),
                    ),
                    const SizedBox(height: 14),
                    _buildQuantityControl(
                      shopId: shopId,
                      productId: item.productId,
                      quantity: item.quantity,
                    ),
                  ],
                ),

              ],
            ),

            // **Hiển thị danh sách Food Option**
            if (item.cartItemOptionDTOList.any((option) => option.typeId == 3))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Thêm lựa chọn", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...item.cartItemOptionDTOList
                        .where((option) => option.typeId == 3)
                        .map((option) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(option.optionName),
                        Text(
                          "${controller.formatCurrency(option.price ?? 0)}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        _buildQuantityControl(
                          shopId: shopId,
                          productId: item.productId,
                          optionId: option.optionId,
                          quantity: option.quantity,
                        ),
                      ],
                    ))
                        .toList(),
                  ],
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text("Không có lựa chọn thêm nào", style: TextStyle(color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }

  /// Widget thay đổi số lượng
  Widget _buildQuantityControl({
    required int shopId,
    required int productId,
    int? optionId, // Nếu có optionId, nghĩa là điều chỉnh FoodOption
    required int quantity,
  }) {
    return Container(
      height: 24,
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút giảm
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.remove, size: 12),
              onPressed: () {
                if (quantity > 1) {
                  if (optionId == null) {
                    controller.updateProductQuantity(shopId, productId, quantity - 1);
                  } else {
                    controller.updateOptionQuantity(shopId, productId, optionId, quantity - 1);
                  }
                }
              },
            ),
          ),

          // Hiển thị số lượng
          Text(
            "$quantity",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          // Nút tăng
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.add, size: 16),
              onPressed: () {
                if (optionId == null) {
                  controller.updateProductQuantity(shopId, productId, quantity + 1);
                } else {
                  controller.updateOptionQuantity(shopId, productId, optionId, quantity + 1);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Widget to display the total amount and checkout button
  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            double totalAmount = controller.getTotalAmount();
            return Text(
              "Tổng tiền: ${controller.formatCurrency(totalAmount)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          }),
          OutlinedButton(
            onPressed: () => controller.proceedToCheckout(), // Gọi hàm kiểm tra và chuyển trang
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(color: Colors.black, width: 1.5),
            ),
            child: const Text(
              "Thanh toán",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

}
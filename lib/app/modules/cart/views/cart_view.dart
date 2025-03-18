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
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop header with checkbox and name
          ListTile(
            leading: Obx(() {
              bool isShopSelected = controller.isShopSelected(shop.shopId);
              return Checkbox(
                value: isShopSelected,
                onChanged: (bool? value) {
                  controller.toggleShopSelection(shop.shopId, value ?? false);
                },
              );
            }),
            title: Text(shop.shopName, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => controller.removeShop(shop.shopId),
            ),
          ),

          // List of items in the shop
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
      margin: EdgeInsets.zero, // Loại bỏ margin để dịch sang trái
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8), // Giảm padding
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start, // Dịch sang trái
              children: [
                // Checkbox to select the item
                Expanded(
                  flex: 0, // Tránh đẩy nội dung khác
                  child: Obx(() {
                    bool isSelected = controller.isItemSelected(shopId, item.productId);
                    return Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        controller.toggleItemSelection(shopId, item.productId, value ?? false);
                      },
                    );
                  }),
                ),

                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    (item.image != null && item.image!.isNotEmpty)
                        ? item.image!
                        : 'https://via.placeholder.com/100',
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

                const SizedBox(width: 8), // Giảm khoảng trống giữa hình ảnh và thông tin

                // Product details (name, size, price, quantity)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      // Size dropdown
                      if (item.cartItemOptionDTOList.any((option) => option.typeId == 2))
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
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
                                  /// controller.updateSize(shopId, item.productId, newSize);
                                }
                              },
                              icon: const Icon(Icons.arrow_drop_down, size: 12),
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),

                      // Price and quantity control
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${item.price ?? item.totalPrice / item.quantity}đ",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          _buildQuantityControl(
                            shopId: shopId,
                            productId: item.productId,
                            quantity: item.quantity,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Toppings (if any)
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
                          "${option.price}đ",
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
              ),
          ],
        ),
      ),
    );
  }


  /// Widget to handle quantity control (+ and - buttons)
  Widget _buildQuantityControl({
    required int shopId,
    required int productId,
    int? optionId,
    required int quantity,
  }) {
    return Container(
      height: 24,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 12),
              onPressed: () {
                if (quantity > 1) {
                  // controller.updateQuantity(shopId, productId, quantity - 1);
                }
              },
            ),
            Text(
              '$quantity',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 12),
              onPressed: () {
                // controller.updateQuantity(shopId, productId, quantity + 1);
              },
            ),
          ],
        ),
      )

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
      child: Column(
        children: [
          Obx(() {
            double totalAmount = controller.getTotalAmount();
            return Text(
              "Tổng tiền: ${controller.formatCurrency(totalAmount)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          }),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Thanh toán"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
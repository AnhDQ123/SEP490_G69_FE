// 📦 FILE: cart_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item.dart';
import '../controllers/cart_controller.dart';
import '../../../models/cart_item_option.dart';

class CartView extends StatelessWidget {
  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth < 360 ? 12.0 : (screenWidth < 480 ? 13.0 : 14.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "🛒 Giỏ hàng",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: baseFontSize + 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildSelectAllRow(baseFontSize),
          Expanded(
            child: Obx(() {
              if (controller.carts.isEmpty) {
                return Center(
                  child: Text(
                    "Giỏ hàng của bạn đang trống 😔",
                    style: TextStyle(fontSize: baseFontSize),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: controller.carts.length,
                itemBuilder: (_, index) {
                  return _buildShopSection(context, controller.carts[index], baseFontSize);
                },
              );
            }),
          ),
          _buildTotalSection(baseFontSize),
        ],
      ),
    );
  }

  Widget _buildSelectAllRow(double baseFontSize) {
    return Padding(
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
          Text("Chọn tất cả", style: TextStyle(fontSize: baseFontSize)),
        ],
      ),
    );
  }

  Widget _buildShopSection(BuildContext context, CartDTO shop, double baseFontSize) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShopHeader(shop, baseFontSize),
            const Divider(),
            ...shop.cartItemDTOList
                .map((item) => _buildCartItem(context, shop.shopId, item, baseFontSize))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildShopHeader(CartDTO shop, double baseFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Obx(() {
            bool isSelected = controller.isShopSelected(shop.shopId);
            return Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                controller.toggleShopSelection(shop.shopId, value ?? false);
              },
            );
          }),
          const Icon(Icons.store, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              shop.shopName,
              style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () => controller.removeShop(shop.shopId),
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, int shopId, CartItemDTO item, double baseFontSize) {
    if (!controller.productOptions.containsKey(item.productId)) {
      controller.fetchProductOptions(item.productId);
    }

    return Obx(() {
      List<CartItemOptionDTO> selectedSizes =
      item.cartItemOptionDTOList.where((o) => o.typeId == 2).toList();
      List<CartItemOptionDTO> selectedToppings =
      item.cartItemOptionDTOList.where((o) => o.typeId == 1).toList();
      CartItemOptionDTO? selectedSize =
      selectedSizes.isNotEmpty ? selectedSizes.first : null;

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.image.isNotEmpty
              ? Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.fastfood, size: 40),
        ),
        title: Text(
          item.productName,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: baseFontSize),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedSize != null)
              Text("Size: ${selectedSize.optionName}",
                  style: TextStyle(fontSize: baseFontSize - 1)),
            if (selectedToppings.isNotEmpty)
              Text("Topping: ${selectedToppings.map((e) => e.optionName).join(', ')}",
                  style: TextStyle(fontSize: baseFontSize - 1)),
            Text("Giá: ${controller.formatCurrency(item.totalPrice)}",
                style: TextStyle(fontSize: baseFontSize - 1)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => controller.updateProductQuantity(
                      shopId, item.productId, item.quantity.value - 1),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                ),
                Text('${item.quantity}',
                    style: TextStyle(fontSize: baseFontSize - 1)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => controller.updateProductQuantity(
                      shopId, item.productId, item.quantity.value + 1),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),

          ],
        ),
      );
    });
  }

  Widget _buildTotalSection(double baseFontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              return Text(
                "Tổng tiền: ${controller.formatCurrency(controller.getTotalAmount())}",
                style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
              );
            }),
          ),
          ElevatedButton(
            onPressed: () => controller.proceedToCheckout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text("Thanh toán", style: TextStyle(fontSize: baseFontSize)),
          ),
        ],
      ),
    );
  }
}
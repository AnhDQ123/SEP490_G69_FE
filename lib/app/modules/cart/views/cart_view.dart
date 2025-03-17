import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../models/cart_item.dart';
import '../../../models/shop.dart';
import '../../../models/food_option.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

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
          // Checkbox chọn tất cả
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Obx(() {
                  bool allSelected = cartController.selectedShops.length == cartController.cartItems.length;
                  return Checkbox(
                    value: allSelected,
                    onChanged: (value) {
                      if (value == true) {
                        cartController.selectedShops.assignAll(cartController.cartItems.keys);
                      } else {
                        cartController.selectedShops.clear();
                      }
                    },
                  );
                }),
                const Text("Chọn tất cả", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          // Danh sách sản phẩm trong giỏ hàng
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return const Center(child: Text("Giỏ hàng trống"));
              }
              return ListView(
                children: cartController.cartItems.entries.map((entry) {
                  return _buildShopSection(entry.key, entry.value);
                }).toList(),
              );
            }),
          ),

          // Tổng tiền & nút Thanh toán
          _buildTotalSection(),
        ],
      ),
    );
  }

  /// Widget hiển thị từng shop trong giỏ hàng
  Widget _buildShopSection(int shopId, RxList<CartItem> items) {
    Shop shop = cartController.shops.firstWhere((s) => s.shopId == shopId);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header của Shop
          ListTile(
            leading: Obx(() {
              bool isSelected = cartController.selectedShops.contains(shopId);
              return Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  if (value == true) {
                    cartController.selectedShops.add(shopId);
                  } else {
                    cartController.selectedShops.remove(shopId);
                  }
                },
              );
            }),
            title: Text(shop.shopName, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => cartController.cartItems.remove(shopId),
            ),
          ),

          // Danh sách sản phẩm trong shop
          Column(
            children: items.map((item) => _buildCartItem(shopId, item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int shopId, CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox bên trái
                Obx(() {
                  bool isSelected = cartController.selectedShops.contains(shopId);
                  return Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      if (value == true) {
                        cartController.selectedShops.add(shopId);
                      } else {
                        cartController.selectedShops.remove(shopId);
                      }
                    },
                  );
                }),

                // Hình ảnh lớn hơn
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.product.options.first.image,
                    width: 100, // Tăng kích thước ảnh
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Thông tin sản phẩm (Tên, Size, Giá & Số lượng)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên sản phẩm
                      Text(
                        item.product.productName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      // Dropdown chọn size
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<FoodOption>(
                            isDense: true,
                            value: item.selectedOptions.firstWhereOrNull((option) => option.isSize) ??
                                item.product.options.firstWhere((opt) => opt.isSize),
                            items: item.product.options.where((option) => option.isSize).map((FoodOption sizeOption) {
                              return DropdownMenuItem<FoodOption>(
                                value: sizeOption,
                                child: Text(
                                  sizeOption.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                            onChanged: (newSize) {
                              if (newSize != null) {
                                cartController.updateSize(shopId, item.product.productId, newSize);
                              }
                            },
                            icon: const Icon(Icons.arrow_drop_down, size: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end, // Để căn giá xuống dưới cùng
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Giá sản phẩm, căn xuống dưới cùng
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "${item.product.getBasePrice().toStringAsFixed(0)}đ",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

                // Nút xóa
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 22),
                      onPressed: () => cartController.removeItem(shopId, item.product.productId),
                    ),
                    SizedBox(height: 30),
                    // Nút tăng giảm số lượng (giữ nguyên vị trí hiện tại)
                    _buildQuantityControl(
                      shopId: shopId,
                      productId: item.product.productId,
                      quantity: item.selectedOptions.firstWhere((opt) => opt.isSize).quantity,
                    ),
                  ],
                ),
              ],
            ),
            if (item.selectedOptions.where((opt) => !opt.isSize).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Thêm lựa chọn", style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(
                      children: item.selectedOptions.where((opt) => !opt.isSize).map((option) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(option.name),
                            Text(
                              "${option.price.toStringAsFixed(0)}đ",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            _buildQuantityControl(
                              shopId: shopId,
                              productId: item.product.productId,
                              optionId: option.foodOptionId, // Chỉ truyền optionId khi xử lý tùy chọn
                              quantity: option.quantity,
                            )

                          ],
                        );
                      }).toList(),
                    ),
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
    int? optionId, // Nếu có optionId, nghĩa là điều chỉnh option thay vì product
    required int quantity,
  }) {
    return Container(
      height: 24, // Điều chỉnh chiều cao hợp lý
      width: 70,  // Tăng chiều rộng để không bị vỡ bố cục
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
              padding: EdgeInsets.zero, // Xóa padding mặc định
              constraints: const BoxConstraints(), // Xóa ràng buộc kích thước thừa
              icon: const Icon(Icons.remove, size: 12), // Nhỏ hơn
              onPressed: () {
                if (quantity > 1) {
                  if (optionId == null) {
                    cartController.updateProductQuantity(shopId, productId, quantity - 1);
                  } else {
                    cartController.updateOptionQuantity(shopId, productId, optionId, quantity - 1);
                  }
                }
              },
            ),
          ),

          // Số lượng sản phẩm
          Text(
            "$quantity",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Căn giữa số lượng
          ),

          // Nút tăng
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.add, size: 16), // Nhỏ hơn
              onPressed: () {
                if (optionId == null) {
                  cartController.updateProductQuantity(shopId, productId, quantity + 1);
                } else {
                  cartController.updateOptionQuantity(shopId, productId, optionId, quantity + 1);
                }
              },
            ),
          ),
        ],
      ),
    );
  }



  /// Widget hiển thị tổng tiền và nút thanh toán
  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        children: [
          // Tổng tiền
          Obx(() {
            double totalAmount = cartController.getTotalAmount();
            return Text(
              "Tổng tiền: ${totalAmount.toStringAsFixed(0)}đ",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          }),
          const SizedBox(height: 10),
          // Nút thanh toán
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

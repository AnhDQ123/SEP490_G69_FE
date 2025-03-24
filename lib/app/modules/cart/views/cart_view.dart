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
        title: const Text("Giỏ hàng",
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                children: controller.carts.map((shop) {
                  return _buildShopSection(context, shop);
                }).toList(),
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
  Widget _buildShopSection(BuildContext parentContext, CartDTO shop) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
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
            children: shop.cartItemDTOList
                .map((item) => _buildCartItem(parentContext, shop.shopId, item))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext parentContext, int shopId, CartItemDTO item) {
    final controller = Get.find<CartController>();

    // 🔹 Nếu Product chưa được lấy từ API, gọi fetchProductOptions
    if (!controller.productOptions.containsKey(item.productId)) {
      controller.fetchProductOptions(item.productId);
    }

    return Obx(() {
      List<CartItemOptionDTO> availableOptions =
          controller.productOptions[item.productId] ?? [];
      List<CartItemOptionDTO> availableSizes =
      availableOptions.where((opt) => opt.typeId == 2).toList();
      List<CartItemOptionDTO> availableFoodOptions =
      availableOptions.where((opt) => opt.typeId == 1).toList();

      // 🔹 Lấy Size đã chọn từ Cart
      CartItemOptionDTO? selectedSize =
      item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2);

      // 🔹 Nếu chưa có size, tìm size theo optionId từ Product API
      if (selectedSize == null && availableSizes.isNotEmpty) {
        selectedSize = availableSizes.firstWhereOrNull((opt) =>
        opt.optionId ==
            item.cartItemOptionDTOList
                .firstWhereOrNull((o) => o.typeId == 2)
                ?.optionId);
      }

      // 🔹 Lấy danh sách Food Option đã chọn trong giỏ hàng
      List<CartItemOptionDTO> selectedFoodOptions =
      item.cartItemOptionDTOList.where((opt) => opt.typeId == 1).toList();
      print("🔍 DEBUG | Sản phẩm: ${item.productName}, Food Options khả dụng: ${availableFoodOptions.map((e) => e.optionName).toList()}");
      print("🔍 DEBUG | Sản phẩm: ${item.productName}, Food Options đã chọn: ${selectedFoodOptions.map((e) => e.optionName).toList()}");


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
                  // Checkbox chọn sản phẩm
                  Obx(() {
                    bool isSelected = controller.selectedItems[shopId]
                        ?.contains(item.productId) ??
                        false;
                    return Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        controller.toggleItemSelection(
                            shopId, item.productId, value ?? false);
                      },
                    );
                  }),

                  // Hình ảnh sản phẩm
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: item.image != null && item.image!.isNotEmpty
                        ? FadeInImage.assetNetwork(
                      placeholder: 'assets/default_food.png',
                      image: item.image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/default_food.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : Image.asset(
                      'assets/default_food.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
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
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),

                        // 🔹 Hiển thị Size đã chọn
                        if (availableSizes.isNotEmpty)
                          GestureDetector(
                            onTap: () => _showSizeBottomSheet(parentContext,
                                availableSizes, shopId, item.productId),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    selectedSize?.optionName ?? "Chọn size",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      size: 14),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 4),

                        // 🏷️ Hiển thị giá của sản phẩm (Chỉ lấy từ Size)
                        Text(
                          "${controller.formatCurrency(selectedSize?.price ?? 0)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
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
                        onPressed: () =>
                            controller.removeItem(shopId, item.productId),
                      ),
                      const SizedBox(height: 14),
                      _buildQuantityControl(
                        shopId: shopId,
                        productId: item.productId,
                        quantity: item.quantity.value,
                      ),
                    ],
                  ),
                ],
              ),

              // 🔹 Hiển thị danh sách lựa chọn thêm nếu có
              if (availableFoodOptions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Thêm lựa chọn",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6), // Tạo khoảng cách giữa tiêu đề và danh sách

                      // 🔹 Hiển thị các lựa chọn đã chọn trong giỏ hàng
                      if (selectedFoodOptions.isNotEmpty)
                        Column(
                          children: selectedFoodOptions.map((option) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0), // Khoảng cách giữa các options
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Hiển thị Option đã chọn
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      option.optionName,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),

                                  // Hiển thị giá của lựa chọn bổ sung (Căn cứng độ rộng)
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${controller.formatCurrency(option.price * option.quantity)}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                                    ),
                                  ),

                                  const SizedBox(width: 40),

                                  // Dùng chung bộ điều khiển số lượng
                                  _buildQuantityControl(
                                    shopId: shopId,
                                    productId: item.productId,
                                    optionId: option.optionId,
                                    quantity: option.quantity,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                      // 🔹 Nếu có `Food Options` nhưng chưa chọn hết, hiển thị nút `+`
                      if (availableFoodOptions.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 24, color: Colors.grey),
                            onPressed: () {
                              _showFoodOptionBottomSheet(parentContext, availableFoodOptions, shopId, item.productId);
                            },
                          ),
                        ),
                    ],
                  ),
                )
              else
              // Nếu sản phẩm không có lựa chọn nào, hiển thị thông báo
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Không có lựa chọn thêm nào",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

            ],
          ),
        ),
      );
    });
  }

  void _showSizeBottomSheet(BuildContext context, List<CartItemOptionDTO> sizes,
      int shopId, int productId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Chọn kích thước",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Column(
                children: sizes.map((size) {
                  return ListTile(
                    title: Text(size.optionName,
                        style: const TextStyle(fontSize: 16)),
                    trailing:
                    Text("${controller.formatCurrency(size.price)}"),
                    onTap: () {
                      // 🔹 Cập nhật size đã chọn vào giỏ hàng
                      controller.updateSize(shopId, productId, size);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFoodOptionBottomSheet(BuildContext context, List<CartItemOptionDTO> options, int shopId, int productId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Chọn lựa chọn bổ sung", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Column(
                children: options.map((option) {
                  return ListTile(
                    title: Text(option.optionName, style: const TextStyle(fontSize: 14)),
                    trailing: Text("${controller.formatCurrency(option.price)}"),
                    onTap: () {
                      controller.addFoodOption(shopId, productId, option);
                      Navigator.pop(context); // Đóng BottomSheet sau khi chọn
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }


  /// Widget thay đổi số lượng
  Widget _buildQuantityControl({
    required int shopId,
    required int productId,
    int? optionId, // Nếu có optionId, nghĩa là đang cập nhật Food Option
    required int quantity,
  }) {
    return Container(
      height: 30,
      width: 60, // 🔹 Tăng chiều rộng để tránh tràn
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // 🔹 Cân bằng khoảng cách
        children: [
          // 🔹 Nút giảm số lượng
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.remove, size: 16),
              onPressed: () {
                if (quantity > 1) {
                  if (optionId == null) {
                    controller.updateProductQuantity(
                        shopId, productId, quantity - 1);
                  } else {
                    controller.updateOptionQuantity(
                        shopId, productId, optionId, quantity - 1);
                  }
                }
              },
            ),
          ),

          // 🔹 Hiển thị số lượng
          Flexible(
            child: Text(
              "$quantity",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          // 🔹 Nút tăng số lượng
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.add, size: 16),
              onPressed: () {
                if (optionId == null) {
                  controller.updateProductQuantity(
                      shopId, productId, quantity + 1);
                } else {
                  controller.updateOptionQuantity(
                      shopId, productId, optionId, quantity + 1);
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
            return Text(
              "Tổng tiền: ${controller.formatCurrency(controller.getTotalAmount())}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            );
          }),
          OutlinedButton(
            onPressed: () => controller.proceedToCheckout(),
            // Gọi hàm kiểm tra và chuyển trang
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(color: Colors.black, width: 1.5),
            ),
            child: const Text(
              "Thanh toán",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
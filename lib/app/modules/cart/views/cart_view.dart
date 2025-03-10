import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dùng DraggableScrollableSheet để bottomSheet có thể kéo lên/xuống
    return DraggableScrollableSheet(
      // Cho phép bottomSheet không full màn hình ngay
      expand: false,
      // Kích thước khởi đầu (80% chiều cao màn hình)
      initialChildSize: 0.8,
      // Kéo xuống ít nhất 40%
      minChildSize: 0.4,
      // Kéo lên tối đa 95%
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        // Dùng Material để có nền trắng, theme, v.v.
        return Material(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh "Giỏ hàng" giống AppBar đơn giản
              Container(
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: const Text(
                  "Giỏ hàng",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              // Checkbox "Chọn tất cả"
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Checkbox(
                        value: controller.isSelectAll.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.toggleSelectAll(value);
                          }
                        },
                      ),
                      const Text("Chọn tất cả"),
                    ],
                  ),
                );
              }),

              // Danh sách quán + món
              Expanded(
                child: Obx(
                      () => ListView.builder(
                    controller: scrollController, // Kết nối với DraggableScrollableSheet
                    itemCount: controller.cartList.length,
                    itemBuilder: (context, index) {
                      final vendor = controller.cartList[index];
                      return _buildVendorCard(vendor);
                    },
                  ),
                ),
              ),

              // Ghi chú phí
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  "Giá món đã bao gồm thuế, nhưng chưa bao gồm phí giao hàng và các chi phí khác.",
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                  ),
                ),
              ),

              // Tổng tiền + nút Thanh toán
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Obx(() {
                    final total = controller.totalCartPrice;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng tiền: ${_formatPrice(total)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: controller.checkout,
                          child: const Text("Thanh toán"),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Widget hiển thị 1 quán (vendor)
  Widget _buildVendorCard(vendor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên quán
          Text(
            vendor.vendorName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Danh sách món
          Column(
            children: vendor.items.map<Widget>((item) {
              return _buildCartItem(vendor, item);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Widget hiển thị 1 món trong giỏ hàng
  Widget _buildCartItem(vendor, item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox chọn
              Checkbox(
                value: item.isSelected,
                onChanged: (value) {
                  if (value != null) {
                    controller.toggleItemSelected(vendor, item, value);
                  }
                },
              ),

              // Ảnh placeholder
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: const Icon(Icons.image, size: 20),
              ),

              // Phần text (Tên + giá) co giãn
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên món
                    Text(
                      item.itemName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Giá (có discount thì hiển thị Wrap để tránh overflow)
                    if (item.discount > 0)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          Text(
                            _formatPrice(item.price),
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "${item.discount}%: ${_formatPrice(item.finalItemPrice)}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        _formatPrice(item.price),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              ),

              // Nút +/- số lượng
              Column(
                children: [
                  InkWell(
                    onTap: () => controller.changeItemQuantity(vendor, item, false),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(Icons.remove, size: 16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("${item.quantity}"),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => controller.changeItemQuantity(vendor, item, true),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(Icons.add, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // SubItems (topping)
          if (item.subItems.isNotEmpty) ...[
            const SizedBox(height: 8),
            Column(
              children: item.subItems.map<Widget>((sub) {
                return Container(
                  margin: const EdgeInsets.only(left: 48, bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("- ${sub.name}"),
                      ),
                      Text(_formatPrice(sub.price)),
                      // Nếu muốn +/- topping thì thêm ở đây
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // Ghi chú
          Container(
            margin: const EdgeInsets.only(left: 48, top: 4),
            child: Row(
              children: [
                const Icon(Icons.edit_note, color: Colors.grey, size: 20),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    onChanged: (value) => controller.updateNote(item, value),
                    decoration: const InputDecoration(
                      hintText: "Thêm ghi chú",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Định dạng giá, đơn giản: chuyển sang chuỗi kèm "đ"
  String _formatPrice(int price) {
    return "${price}đ";
  }
}

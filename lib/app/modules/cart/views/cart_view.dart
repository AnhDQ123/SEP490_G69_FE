import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  final Color accentColor = const Color.fromRGBO(212, 163, 115, 1);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Material(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: sử dụng màu chủ đạo với chữ trắng
              Container(
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: const Text(
                  "Giỏ hàng",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),

              // Checkbox "Chọn tất cả"
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: accentColor,
                        ),
                        child: Checkbox(
                          activeColor: accentColor,
                          value: controller.isSelectAll.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.toggleSelectAll(value);
                            }
                          },
                        ),
                      ),
                      const Text(
                        "Chọn tất cả",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }),

              // Danh sách giỏ hàng
              Expanded(
                child: Obx(
                      () => ListView.builder(
                    controller: scrollController,
                    itemCount: controller.cartList.length,
                    itemBuilder: (context, index) {
                      final vendor = controller.cartList[index];
                      return _buildVendorCard(vendor);
                    },
                  ),
                ),
              ),

              // Ghi chú về giá (bao gồm thuế nhưng chưa bao gồm phí giao hàng)
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

              // Tổng tiền và nút Thanh toán
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
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: controller.checkout,
                          child: const Text(
                            "Thanh toán",
                            style: TextStyle(fontSize: 16),
                          ),
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

  /// Widget hiển thị thông tin của 1 vendor (quán)
  Widget _buildVendorCard(vendor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          // Danh sách món của quán
          Column(
            children: vendor.items.map<Widget>((item) {
              return _buildCartItem(vendor, item);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Widget hiển thị thông tin của 1 món trong giỏ hàng
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
              // Checkbox chọn món
              Theme(
                data: ThemeData(unselectedWidgetColor: accentColor),
                child: Checkbox(
                  activeColor: accentColor,
                  value: item.isSelected,
                  onChanged: (value) {
                    if (value != null) {
                      controller.toggleItemSelected(vendor, item, value);
                    }
                  },
                ),
              ),
              // Ảnh đại diện món (placeholder)
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
              // Thông tin món: tên và giá
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên món
                    Text(
                      item.itemName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Giá món, hiển thị discount nếu có
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
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "${item.discount}%: ${_formatPrice(item.finalItemPrice)}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              // Nút tăng/giảm số lượng: sử dụng màu chủ đạo cho hiệu ứng
              Column(
                children: [
                  InkWell(
                    onTap: () => controller.changeItemQuantity(vendor, item, false),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.remove, size: 16, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.quantity}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => controller.changeItemQuantity(vendor, item, true),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.add, size: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Hiển thị các subItems (như topping)
          if (item.subItems.isNotEmpty) ...[
            const SizedBox(height: 8),
            Column(
              children: item.subItems.map<Widget>((sub) {
                return Container(
                  margin: const EdgeInsets.only(left: 48, bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("- ${sub.name}", style: const TextStyle(fontSize: 12)),
                      ),
                      Text(
                        _formatPrice(sub.price),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          // Ghi chú cho món
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

  /// Hàm định dạng giá đơn giản: chuyển sang chuỗi và thêm "đ"
  String _formatPrice(int price) {
    return "${price}đ";
  }
}

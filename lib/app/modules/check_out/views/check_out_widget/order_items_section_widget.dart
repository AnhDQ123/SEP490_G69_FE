import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/order.dart';
import '../../../../models/order_item.dart';
import '../../../../models/order_item_option.dart';
import '../../../../resources/assets_manager.dart';

class OrderItemsSectionWidget extends StatelessWidget {
  final Order order;
  const OrderItemsSectionWidget({Key? key, required this.order}) : super(key: key);

  Map<String, List<OrderItem>> _groupItemsByShop(List<OrderItem> items) {
    return {order.shopName: items};
  }

  double _calculateDiscountedPrice(OrderItem item) {
    // Ưu tiên sử dụng item.total nếu có
    if (item.total != null && item.total != item.price * item.quantity) {
      return item.total!;
    }

    // Nếu không thì kiểm tra discount
    if (item.discount == null || item.discount!.isEmpty) {
      return item.price * item.quantity;
    }

    final discountRate = (100 - (item.discount!.first.amount * 100)) / 100;
    return item.price * item.quantity * discountRate;
  }



  // Giá gốc của món
  double _calculateOriginalPrice(OrderItem item) {
    return item.price * item.quantity;
  }

  double _calculateOptionPrice(OrderItemOption option) {
    return option.price * option.quantity;
  }

  // Hàm định dạng giá theo VNĐ
  String _formatPrice(double price) {
    final formatter =
    NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    if (order.orderItem.isEmpty) {
      return const SizedBox.shrink();
    }
    final groupedItems = _groupItemsByShop(order.orderItem);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...groupedItems.entries.map((entry) {
          final shopName = entry.key;
          final shopItems = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildShopSection(shopName, shopItems, context),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildShopSection(
      String shopName, List<OrderItem> shopItems, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề shop (icon + tên)
        Row(
          children: [
            const Icon(Icons.store, size: 14, color: Colors.black54),
            const SizedBox(width: 4),
            Text(
              shopName,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        if (order.voucherId != null && order.voucherAmount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.discount, size: 14, color: Colors.redAccent),
                const SizedBox(width: 4),
                Text(
                  "Voucher: -${(order.voucherAmount * 100).toInt()}%",
                  style:
                  const TextStyle(fontSize: 10, color: Colors.redAccent),
                ),
              ],
            ),
          ),
        const Divider(),
        ...shopItems
            .map((item) => _buildMainItemWithOptions(item, context))
            .toList(),
      ],
    );
  }

  Widget _buildMainItemWithOptions(OrderItem item, BuildContext context) {
    final discountedPrice = _calculateDiscountedPrice(item);
    final originalPrice = _calculateOriginalPrice(item);
    // Lấy option với typeId == 2 làm size, nếu có
    OrderItemOption? sizeOption;
    try {
      sizeOption = item.orderItemOptions.firstWhere((option) => option.typeId == 2);
    } catch (e) {
      sizeOption = null;
    }
    // Lọc các option có typeId == 1
    final additionalOptions =
    item.orderItemOptions.where((option) => option.typeId == 1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainItemRow(item, originalPrice, discountedPrice, sizeOption, context),
        if (additionalOptions.isNotEmpty)
          Column(
            children: additionalOptions.map((option) {
              final optionPrice = _calculateOptionPrice(option);
              return _buildOptionRow(option, optionPrice, context);
            }).toList(),
          ),
      ],
    );
  }

  // Row hiển thị món chính: ảnh (với discount overlay), thông tin món (tên, quantity, size nếu có) và giá
  Widget _buildMainItemRow(OrderItem item, double originalPrice, double discountedPrice, OrderItemOption? sizeOption, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          // Ảnh món chính với overlay discount (nếu discount > 0)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  item.image.isNotEmpty ? item.image : ImageAssets.defaultFood,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    ImageAssets.defaultFood,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                ),
              ),
              if (item.discount != null && item.discount!.isNotEmpty && item.discount!.first.amount > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    color: Colors.redAccent,
                    child: Text(
                      "${(item.discount!.first.amount * 100).toInt()}%",
                      style: const TextStyle(fontSize: 8, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          // Thông tin món: số lượng, tên, và nếu có Size (từ option typeId == 2)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.quantity} x ${item.productName}",
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                ),
                if (sizeOption != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "Kích thước: ${sizeOption.optionName}",
                      style: const TextStyle(fontSize: 8, color: Colors.black54),
                    ),
                  ),
              ],
            ),
          ),
          // Hiển thị giá: nếu có discount thì hiển thị giá cũ bị gạch và giá mới (discounted)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.discount != null && item.discount!.isNotEmpty && item.discount!.first.amount > 0)
                Text(
                  _formatPrice(originalPrice),
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Text(
                _formatPrice(discountedPrice), // Dùng giá đã giảm ở đây //originalprice
                style: const TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // Row hiển thị 1 option (loại typeId == 1)
  Widget _buildOptionRow(OrderItemOption option, double optionPrice, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48.0, bottom: 6.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              option.image?.isNotEmpty == true ? option.image! : ImageAssets.defaultFood,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                ImageAssets.defaultFood,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "${option.quantity} x ${option.optionName}",
              style: const TextStyle(fontSize: 9, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatPrice(optionPrice),
            style: const TextStyle(fontSize: 9, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../models/check_out.dart';
import '../../../../models/checkout_option.dart';

class OrderItemsSectionWidget extends StatelessWidget {
  final CheckoutInfo checkout;
  const OrderItemsSectionWidget({Key? key, required this.checkout}) : super(key: key);

  // Hàm nhóm các món theo shopName
  Map<String, List<CheckoutItem>> _groupItemsByShop(List<CheckoutItem> items) {
    final Map<String, List<CheckoutItem>> shopMap = {};
    for (var item in items) {
      shopMap.putIfAbsent(item.shopName, () => []).add(item);
    }
    return shopMap;
  }

  // Tính giá món chính (có discount)
  double _calculateBasePrice(CheckoutItem item) {
    final discountRate = (100 - item.discount) / 100;
    return item.price * item.quantity * discountRate;
  }

  // Tính giá của 1 option (có quantity)
  int _calculateOptionPrice(CheckoutOption option) {
    return option.price * option.quantity;
  }

  @override
  Widget build(BuildContext context) {
    if (checkout.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final groupedItems = _groupItemsByShop(checkout.items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị danh sách các shop
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
                child: _buildShopSection(shopName, shopItems),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // Widget hiển thị 1 shop (tên shop + danh sách món)
  Widget _buildShopSection(String shopName, List<CheckoutItem> shopItems) {
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
                color: Colors.black,
              ),
            ),
          ],
        ),
        // Hiển thị voucher của shop nếu có
        if (checkout.vouchers.containsKey(shopName))
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Row(
              children: [
                const Icon(Icons.discount, size: 14, color: Colors.redAccent),
                const SizedBox(width: 4),
                Text(
                  "Voucher: ${checkout.vouchers[shopName]!.name} (-${checkout.vouchers[shopName]!.value.toInt()}đ)",
                  style: const TextStyle(fontSize: 10, color: Colors.redAccent),
                ),
              ],
            ),
          ),
        const Divider(),
        // Danh sách món của shop
        ...shopItems.map((item) => _buildMainItemWithOptions(item)).toList(),
      ],
    );
  }

  // Widget hiển thị món chính cùng option của nó
  Widget _buildMainItemWithOptions(CheckoutItem item) {
    final basePrice = _calculateBasePrice(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainItemRow(item, basePrice),
        if (item.options.isNotEmpty)
          Column(
            children: item.options.map((option) {
              final optionPrice = _calculateOptionPrice(option);
              return _buildOptionRow(option, optionPrice);
            }).toList(),
          ),
      ],
    );
  }

  // Row hiển thị món chính: ảnh, tên + quantity, size, giá
  Widget _buildMainItemRow(CheckoutItem item, double basePrice) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          // Ảnh món chính (60x60)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          // Thông tin món chính với chữ nhỏ hơn
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.quantity} x ${item.name}",
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                ),
                if (item.size.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "Size: ${item.size}",
                      style: const TextStyle(fontSize: 8, color: Colors.black54),
                    ),
                  ),
              ],
            ),
          ),
          // Giá món chính
          Text(
            "${basePrice.toStringAsFixed(0)}đ",
            style: const TextStyle(fontSize: 10, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Row hiển thị 1 option: ảnh, tên + quantity, giá
  Widget _buildOptionRow(CheckoutOption option, int optionPrice) {
    return Padding(
      padding: const EdgeInsets.only(left: 48.0, bottom: 6.0),
      child: Row(
        children: [
          // Ảnh option (40x40)
          if (option.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                option.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
          else
            const SizedBox(width: 40, height: 40),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "${option.quantity} x ${option.name}",
              style: const TextStyle(fontSize: 9, color: Colors.black),
            ),
          ),
          Text(
            "${optionPrice}đ",
            style: const TextStyle(fontSize: 9, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

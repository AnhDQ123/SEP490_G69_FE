import 'package:flutter/material.dart';
import '../../../models/order.dart';

typedef ActionWidgetBuilder = Widget Function(Order order, double total);

class OrderListWidget extends StatelessWidget {
  final List<Order> orders;
  final String status;
  final Color Function(String) getStatusColor;
  final ActionWidgetBuilder? actionWidgetBuilder;

  const OrderListWidget({
    Key? key,
    required this.orders,
    required this.status,
    required this.getStatusColor,
    this.actionWidgetBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          "Không có đơn hàng $status",
          style: const TextStyle(fontSize: 12),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        // Tính tổng tiền đơn hàng (áp dụng giảm giá và voucher)
        double itemsTotal = order.items.fold(0, (sum, item) {
          double discountAmount = item.price * ((item.discount ?? 0) / 100);
          return sum + ((item.price - discountAmount) * item.quantity);
        });

        double total = itemsTotal - (order.voucher?.value ?? 0);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên cửa hàng và trạng thái đơn hàng
                Row(
                  children: [
                    const Icon(Icons.store, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.shopName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(fontSize: 12, color: getStatusColor(status)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Danh sách món ăn
                Column(
                  children: order.items.map((item) {
                    return ListTile(
                      leading: Image.network(
                        item.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 50),

                      ),
                      title: Text(item.dishName),
                      subtitle: Text("SL: ${item.quantity}"),
                      trailing: Text(
                        "${item.price.toStringAsFixed(0)}đ",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
                const Divider(),

                // Tổng tiền
                Text(
                  "Tổng tiền: ${total.toStringAsFixed(0)}đ",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),

                // Các nút hành động
                actionWidgetBuilder != null ? actionWidgetBuilder!(order, total) : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}


import 'package:flutter/material.dart';
import '../../../../models/order.dart';
import '../../../my_order/views/order_list_widget.dart';

class ShopShippingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopShippingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đang giao",
      getStatusColor: getStatusColor,
      isShopView: true, // ✅ THÊM VÀO ĐÂY

      // ❌ Không có action (chỉ theo dõi)
      actionWidgetBuilder: (_, __) => const SizedBox.shrink(),
    );
  }
}

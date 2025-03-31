import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/order.dart';
import '../../../../models/order_item.dart';
import '../../../../models/order_item_option.dart';

class CostSummaryWidget extends StatelessWidget {
  final Order order;
  const CostSummaryWidget({Key? key, required this.order}) : super(key: key);

  // Phí ship cố định là 0 đồng
  double get shippingFee => 0;

  // Tính giá gốc của món: giá sản phẩm + giá các option (loại typeId == 1)
  double _calculateOriginalPrice(OrderItem item) {
    double productPrice = item.price * item.quantity;
    double optionsPrice = item.options
        .where((option) => option.typeId == 1)
        .fold(0.0, (sum, option) => sum + (option.price * option.quantity));
    return productPrice + optionsPrice;
  }

  // Tính giá sau discount cho từng món: giá gốc * (1 - discount)
  double _calculateDiscountedPrice(OrderItem item) {
    double original = _calculateOriginalPrice(item);
    return original * (1 - item.discount);
  }

  // Tổng tạm tính: tổng giá của tất cả các món sau discount
  double get computedSubTotal {
    return order.items.fold(0.0, (sum, item) => sum + _calculateDiscountedPrice(item));
  }

  // Giả sử order.voucherAmount là số phần trăm (ví dụ: 0.20 tương đương 20%)
  double get voucherPercentage => order.voucherAmount;

  // Số tiền giảm voucher = computedSubTotal * voucherPercentage
  double get voucherDiscount => computedSubTotal * voucherPercentage;

  // Tổng thanh toán = computedSubTotal - voucherDiscount (với phí ship = 0)
  double get finalTotal => computedSubTotal - voucherDiscount;

  String _formatPrice(double price) {
    final formatter =
    NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: const Color.fromRGBO(253, 200, 140, 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chi phí đơn hàng",
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),
          // Tạm tính
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.receipt, size: 14, color: Colors.black54),
                  SizedBox(width: 4),
                  Text("Đơn giá", style: TextStyle(fontSize: 10)),
                ],
              ),
              Text(_formatPrice(computedSubTotal),
                  style: const TextStyle(fontSize: 10)),
            ],
          ),
          const SizedBox(height: 2),
          // Phí ship
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.local_shipping, size: 14, color: Colors.black54),
                  SizedBox(width: 4),
                  Text("Phí ship", style: TextStyle(fontSize: 10)),
                ],
              ),
              Text(_formatPrice(shippingFee),
                  style: const TextStyle(fontSize: 10)),
            ],
          ),
          const SizedBox(height: 2),
          // Voucher
          if (voucherPercentage > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.discount, size: 14, color: Colors.black54),
                    SizedBox(width: 4),
                    Text("Voucher", style: TextStyle(fontSize: 10)),
                  ],
                ),
                Text(
                  "(-${(voucherPercentage * 100).toInt()}%) ${_formatPrice(voucherDiscount)}",
                  style: const TextStyle(fontSize: 10, color: Colors.redAccent),
                ),
              ],
            ),
          const Divider(),
          // Tổng thanh toán
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.attach_money, size: 14, color: Colors.black54),
                  SizedBox(width: 4),
                  Text("Tổng thanh toán", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(_formatPrice(finalTotal),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

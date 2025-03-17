import 'package:flutter/material.dart';
import '../../../../models/check_out.dart';

class CostSummaryWidget extends StatelessWidget {
  final CheckoutInfo checkout;
  const CostSummaryWidget({Key? key, required this.checkout}) : super(key: key);

  Widget _buildCostRow(String label, int amount, {bool isTotal = false}) {
    final textStyle = TextStyle(
      fontSize: isTotal ? 12 : 10,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );
    final display = (amount < 0) ? "-${amount.abs()}đ" : "${amount}đ";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textStyle)),
          Text(
            display,
            style: textStyle.copyWith(
              color: isTotal ? Colors.black : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng discount từ voucher của tất cả shop
    final discountTotal = checkout.vouchers.values.fold(
        0, (prev, voucher) => prev + voucher.value.toInt());

    // Phí ship chính là giá trị trong model
    final shippingFee = checkout.shippingFee;

    // Tính tổng tiền cuối cùng: tổng = tiền sản phẩm - voucher + phí ship
    final total = (checkout.subTotal - discountTotal) + shippingFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCostRow("Tiền sản phẩm", checkout.subTotal),
        _buildCostRow("Phí ship", shippingFee),
        if (discountTotal > 0) _buildCostRow("Voucher", -discountTotal),
        const Divider(),
        _buildCostRow("Thành tiền", total, isTotal: true),
      ],
    );
  }
}

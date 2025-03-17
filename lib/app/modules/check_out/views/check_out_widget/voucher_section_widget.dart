import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/check_out.dart';
import '../../../../models/voucher.dart';
import '../../controllers/check_out_controller.dart';

class VoucherSectionWidget extends StatelessWidget {
  final CheckoutInfo checkout;
  const VoucherSectionWidget({Key? key, required this.checkout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voucherCount = checkout.vouchers.length;
    final voucherNames = checkout.vouchers.values.map((voucher) => voucher.name).join(", ");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dòng hiển thị số lượng voucher
          Row(
            children: [
              const Icon(Icons.discount_outlined, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Mã giảm giá: ${voucherCount == 0 ? "Chưa có" : "$voucherCount voucher${voucherCount > 1 ? "s" : ""}"}",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  _showVoucherSelection(context);
                },
                child: const Text("Chọn mã", style: TextStyle(fontSize: 10)),
              )
            ],
          ),
          // Nếu có voucher, hiển thị tên các voucher ở dòng dưới
          if (voucherCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 3.0),
              child: Text(
                voucherNames,
                style: const TextStyle(fontSize: 10, color: Colors.redAccent),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  void _showVoucherSelection(BuildContext context) {
    // Lấy danh sách shop có trong đơn hàng (sử dụng Set để loại trùng)
    final shops = checkout.items.map((item) => item.shopName).toSet().toList();

    // Giả sử có một map các voucher khả dụng cho mỗi shop (dữ liệu mẫu)
    final Map<String, List<Voucher>> availableVouchers = {
      "Cơm rang Minh Nhật": [
        Voucher(name: 'SALE50', value: 5000),
        Voucher(name: 'NEW50', value: 6000),
      ],
      "Pho": [
        Voucher(name: 'SALE20', value: 2000),
        Voucher(name: 'OFF20', value: 2500),
      ],
    };

    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: shops.map((shop) {
                // Lấy danh sách voucher cho shop, nếu không có thì để rỗng
                final vouchers = availableVouchers[shop] ?? [];
                if (vouchers.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        shop,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...vouchers.map((voucher) {
                      return ListTile(
                        title: Text(voucher.name, style: const TextStyle(fontSize: 11)),
                        subtitle: Text("Giảm ${voucher.value.toInt()}đ", style: const TextStyle(fontSize: 10)),
                        onTap: () {
                          // Áp dụng voucher cho shop tương ứng thông qua controller
                          Get.find<CheckOutController>().applyVoucher(shop, voucher);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                    const Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

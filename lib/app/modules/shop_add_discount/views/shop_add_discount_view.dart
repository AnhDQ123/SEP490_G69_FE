import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/product_discount.dart';
import '../../../models/discount.dart';
import '../controllers/shop_add_discount_controller.dart';

class ShopAddDiscountView extends StatefulWidget {
  @override
  State<ShopAddDiscountView> createState() => _ShopAddDiscountViewState();
}

class _ShopAddDiscountViewState extends State<ShopAddDiscountView> {
  final ShopAddDiscountController controller = Get.put(ShopAddDiscountController());

  late final Map args;
  late final ProductDiscount product;
  late final bool isEdit;
  Discount? discount;

  @override
  void initState() {
    super.initState();
    args = Get.arguments;
    product = args['product'];
    isEdit = args['isEdit'] ?? false;
    discount = args['discount'];

    controller.currentProductPrice = product.defaultPrice;

    if (isEdit && discount != null) {
      controller.loadDiscountToForm(discount!);
    } else {
      controller.setDefaultToday();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Chỉnh sửa giảm giá' : 'Tạo giảm giá')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: product.name,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: '${product.defaultPrice.toInt()} đồng',
              readOnly: true,
              decoration: InputDecoration(labelText: 'Giá gốc'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller.discountPercentController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: 'Giá trị giảm (%)'),
              onChanged: (_) => controller.clampDiscountValue(),
            ),

            SizedBox(height: 10),
            TextFormField(
              controller: controller.discountedPriceController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Giá sau khi giảm'),
            ),
            SizedBox(height: 20),
            Text('Thời gian áp dụng:'),
            TextFormField(
              controller: controller.startDateController,
              decoration: InputDecoration(labelText: 'Ngày bắt đầu'),
              onTap: () => controller.pickDate(isStart: true),
              readOnly: true,
            ),
            TextFormField(
              controller: controller.endDateController,
              decoration: InputDecoration(labelText: 'Ngày kết thúc'),
              onTap: () => controller.pickDate(isStart: false),
              readOnly: true,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (isEdit && discount != null) {
                  controller.updateDiscount(product, discount!);
                } else {
                  controller.addDiscount(product);
                }
              },
              child: Text(isEdit ? 'Cập nhật giảm giá' : 'Áp dụng giảm giá cho sản phẩm'),
            )
          ],
        ),
      ),
    );
  }
}

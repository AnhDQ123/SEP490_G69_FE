import 'package:ffb_fe_flutter/app/models/product_discount.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/discount.dart';
import '../../../models/product.dart';
import '../../../routes/app_pages.dart';
import '../controllers/product_discount_controller.dart';

class ProductDiscountView extends StatelessWidget {
  final ProductDiscountController controller = Get.put(ProductDiscountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giảm giá"),
      ),
      body: Column(
        children: [
          // Danh sách sản phẩm đang giảm giá
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Danh sách sản phẩm đang giảm giá",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(() {
            return _buildDiscountProductTable(context, controller.discountProducts);
          }),

          // Danh sách sản phẩm chưa giảm giá
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Danh sách sản phẩm chưa giảm giá",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(() {
            return _buildNoDiscountProductTable(context, controller.noDiscountProducts);
          }),
        ],
      ),
    );
  }

  Widget _buildDiscountProductTable(BuildContext context, List<ProductDiscount> products) {
    return SingleChildScrollView(  // Cho phép kéo ngang
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12, // Giảm khoảng cách giữa các cột
        columns: [
          DataColumn(label: Text("Ảnh", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Tên", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("% Giảm", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("SL", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Từ", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Đến", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Hành động", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: products.take(5).map((product) {
          final activeDiscount = product.discount.firstWhere(
                  (discount) => discount.status == 'ACTIVE',
              orElse: () => Discount(id: 0, amount: 0, startDate: "N/A", endDate: "N/A", status: "N/A")
          );

          return DataRow(cells: [
            DataCell(
              Image.network(
                product.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            DataCell(
              Flexible(  // Dùng Flexible thay vì Expanded để tránh tràn
                child: Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,  // Thêm TextOverflow.ellipsis
                  maxLines: 1,  // Giới hạn số dòng cho tên
                ),
              ),
            ),
            DataCell(Text("${(product.discount[0].amount * 100).toString()}%")),
            DataCell(Text("${product.quantity}")),
            DataCell(Text(activeDiscount.startDate)),
            DataCell(Text(activeDiscount.endDate)),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Tạo hành động cho nút chỉnh sửa
                    },
                  ),
                ],
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildNoDiscountProductTable(BuildContext context, List<ProductDiscount> products) {
    return SingleChildScrollView(  // Cho phép kéo ngang
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12, // Giảm khoảng cách giữa các cột
        columns: [
          DataColumn(label: Text("Ảnh", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Tên sản phẩm", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Giá sản phẩm", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Số lượng còn lại", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Hành động", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: products.take(5).map((product) {
          return DataRow(cells: [
            DataCell(
              Image.network(
                product.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            DataCell(
              Flexible(  // Dùng Flexible thay vì Expanded để tránh tràn
                child: Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,  // Thêm TextOverflow.ellipsis
                  maxLines: 1,  // Giới hạn số dòng cho tên
                ),
              ),
            ),
            DataCell(Text(formatCurrency(product.defaultPrice))),
            DataCell(Text("${product.quantity}")),
            DataCell(
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Get.toNamed(Routes.ADD_DISCOUNT, arguments: product),
                )

            )

          ]);
        }).toList(),
      ),
    );
  }



  // Hàm format tiền có dấu phân cách
  String formatCurrency(double amount) {
    final format = NumberFormat("#,##0", "vi_VN");
    return format.format(amount);
  }
}

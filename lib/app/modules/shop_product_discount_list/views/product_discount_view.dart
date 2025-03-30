import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/discount.dart';
import '../../../routes/app_pages.dart';
import '../controllers/product_discount_controller.dart';
import '../../../models/product_discount.dart';

class ProductDiscountView extends StatelessWidget {
  final ProductDiscountController controller = Get.put(ProductDiscountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý giảm giá"),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _sectionTitle("🔥 Đang giảm giá"),
            Obx(() => _buildDiscountTable(controller.activeDiscountProducts)),
            const SizedBox(height: 12),
            _sectionTitle("📅 Sắp diễn ra"),
            Obx(() => _buildDiscountTable(controller.scheduledDiscountProducts)),
            const SizedBox(height: 12),
            _sectionTitle("🚫 Chưa có giảm giá"),
            Obx(() => _buildNoDiscountTable(controller.noDiscountProducts)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDiscountTable(List<ProductDiscount> products) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text("Không có sản phẩm trong danh sách này")),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        columns: [
          DataColumn(label: Text("Ảnh")),
          DataColumn(label: Text("Tên")),
          DataColumn(label: Text("% Giảm")),
          DataColumn(label: Text("SL")),
          DataColumn(label: Text("Từ")),
          DataColumn(label: Text("Đến")),
          DataColumn(label: Text("Hành động")),
        ],
        rows: products.map((product) {
          final discount = product.discount.first;
          return DataRow(cells: [
            DataCell(Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover)),
            DataCell(Text(product.name)),
            DataCell(Text("${(discount.amount * 100).toStringAsFixed(0)}%")),
            DataCell(Text("${product.quantity}")),
            DataCell(Text(formatDate(discount.startDate))),
            DataCell(Text(formatDate(discount.endDate))),
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await Get.toNamed(Routes.SHOP_ADD_DISCOUNT, arguments: {
                      'product': product,
                      'isEdit': true,
                      'discount': discount,
                    });
                    controller.fetchProducts();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteDiscount(product, discount),
                )
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildNoDiscountTable(List<ProductDiscount> products) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text("Không có sản phẩm trong danh sách này")),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,

        columns: [
          DataColumn(label: Text("Ảnh")),
          DataColumn(label: Text("Tên")),
          DataColumn(label: Text("Giá")),
          DataColumn(label: Text("SL còn lại")),
          DataColumn(label: Text("Hành động")),
        ],

        rows: products.map((product) {
          print(" - ${product.name}: ${product.defaultPrice} - ${product.quantity}");
          return DataRow(cells: [
            DataCell(Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover)),
            DataCell(Text(product.name)),
            DataCell(Text(formatCurrency(product.defaultPrice))),
            DataCell(Text("${product.quantity}")),
            DataCell(
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  await Get.toNamed(Routes.SHOP_ADD_DISCOUNT, arguments: {
                    'product': product,
                    'isEdit': false, // mặc định là tạo mới
                  });
                  controller.fetchProducts();
                },
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  void _confirmDeleteDiscount(ProductDiscount product, Discount discount) {
    Get.defaultDialog(
      title: "Xác nhận xoá",
      middleText: "Bạn có chắc muốn huỷ giảm giá này?",
      textCancel: "Huỷ",
      textConfirm: "Đồng ý",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        await controller.deleteDiscount(product, discount);
      },
    );
  }

  void _showSortBottomSheet() {
    final sortOptions = {
      SortType.none: "Mặc định",
      SortType.priceAsc: "Giá tăng dần",
      SortType.priceDesc: "Giá giảm dần",
      SortType.quantityAsc: "Tồn kho tăng dần",
      SortType.quantityDesc: "Tồn kho giảm dần",
    };

    final tempSort = controller.sortType.value.obs; // 👈 tạo Rx tạm

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Sắp xếp sản phẩm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Obx(() => DropdownButton<SortType>(
              isExpanded: true,
              value: tempSort.value,
              onChanged: (val) {
                if (val != null) tempSort.value = val;
              },
              items: sortOptions.entries.map((entry) {
                return DropdownMenuItem<SortType>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            )),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side: BorderSide(color: Colors.deepPurple),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onPressed: () => Get.back(),
                    child: Text("Huỷ"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      controller.sortType.value = tempSort.value;
                      controller.applySort();
                      Get.back();
                    },
                    child: Text("Áp dụng"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }


  String formatCurrency(double amount) {
    final format = NumberFormat("#,##0", "vi_VN");
    return format.format(amount);
  }

  String formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }
}

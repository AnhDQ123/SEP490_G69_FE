import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/voucher.dart';
import '../../../routes/app_pages.dart';
import '../controllers/shop_voucher_list_controller.dart';

class ShopVoucherListView extends StatelessWidget {
  final ShopVoucherListController controller = Get.put(ShopVoucherListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách Voucher"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Mở cửa sổ lọc khi người dùng nhấn vào nút lọc
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.filteredVouchers.isEmpty) {
          return Center(child: Text("Chưa có voucher nào"));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: DataTable(
              columnSpacing: 12,
              columns: [
                DataColumn(label: Text("Mã")),
                DataColumn(label: Text("Giá trị")),
                DataColumn(label: Text("Tổng/Đã dùng")),
                DataColumn(label: Text("Ngày bắt đầu")),
                DataColumn(label: Text("Ngày kết thúc")),
                DataColumn(label: Text("Trạng thái")),
                DataColumn(label: Text("Sử dụng tối đa")),
                DataColumn(label: Text("Hành động")), // Cột Hành động
              ],
              rows: controller.filteredVouchers.map((voucher) {
                return DataRow(cells: [
                  DataCell(Text(voucher.code)),
                  DataCell(Text(_formatDiscount(voucher))),  // Hiển thị giá trị dưới dạng % hoặc đ
                  DataCell(Text("${voucher.usedVouchers ?? 0}/${voucher.totalVouchers}")),
                  DataCell(Text("${_formatDate(voucher.startDate)}")),
                  DataCell(Text("${_formatDate(voucher.endDate)}")),
                  DataCell(Text(voucher.status)),
                  DataCell(Text("${voucher.maxUsagePerCustomer}")),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _navigateToEditVoucher(voucher);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _confirmDelete(voucher);
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.SHOP_VOUCHER_ADD);
        },
        child: Icon(Icons.add),
        tooltip: "Thêm Voucher",
      ),
    );
  }


  String _formatDiscount(Voucher v) {
    if (v.discountType == "PERCENTAGE" && v.discountValue != null) {
      return "${(v.discountValue * 100).toStringAsFixed(0)}%";  // Hiển thị phần trăm
    } else if (v.discountType == "AMOUNT" && v.discountValue != null) {
      return "${v.discountValue.toStringAsFixed(0)}đ";  // Hiển thị số tiền
    }
    return "N/A"; // Nếu không phải loại hợp lệ hoặc giá trị null
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(dt);  // Đảm bảo định dạng đúng
    } catch (_) {
      return dateStr; // Nếu không thể phân tích ngày, trả về chuỗi gốc
    }
  }

  void _confirmDelete(Voucher v) {
    final controller = Get.find<ShopVoucherListController>();
    Get.defaultDialog(
      title: "Xác nhận xoá",
      middleText: "Bạn có chắc muốn xoá mã '${v.code}'?",
      textCancel: "Huỷ",
      textConfirm: "Đồng ý",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        await controller.deleteVoucher(v.id);
        print(v.id);
      },
    );
  }

  void _navigateToEditVoucher(Voucher v) {
    Get.toNamed(Routes.SHOP_VOUCHER_ADD, arguments: v);
  }

  void _showFilterDialog() {
    Get.defaultDialog(
      title: "Lọc Voucher",
      content: Column(
        children: [
          ListTile(
            title: Text("Trạng thái"),
            trailing: DropdownButton<String>(
              onChanged: (String? newValue) {
                controller.filterVouchers(newValue!); // Lọc theo trạng thái
              },
              items: <String>['Tất cả', 'Đang hoạt động', 'Hết hạn']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      textCancel: "Huỷ",
      textConfirm: "Áp dụng",
      onConfirm: () {
        Get.back();
      },
    );
  }
}

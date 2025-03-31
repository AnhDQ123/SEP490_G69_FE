import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/voucher.dart';
import '../../../routes/app_pages.dart';
import '../controllers/shop_voucher_list_controller.dart';

class ShopVoucherListView extends StatelessWidget {
  final controller = Get.put(ShopVoucherListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách Voucher"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
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
                DataColumn(label: Text("Tên Mã giảm giá")),
                DataColumn(label: Text("Giá trị")),
                DataColumn(label: Text("Đã dùng / Tổng")),
                DataColumn(label: Text("Bắt đầu")),
                DataColumn(label: Text("Kết thúc")),
                DataColumn(label: Text("Trạng thái")),
                DataColumn(label: Text("Tối đa / KH")),
                DataColumn(label: Text("Hành động")),
              ],
              rows: controller.filteredVouchers.map(_buildRow).toList(),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SHOP_VOUCHER_ADD),
        child: Icon(Icons.add),
        tooltip: "Thêm Voucher",
      ),
    );
  }

  DataRow _buildRow(Voucher v) {
    return DataRow(cells: [
      DataCell(Text(v.code)),
      DataCell(Text(_formatDiscount(v))),
      DataCell(Text("${v.usedVouchers ?? 0}/${v.totalVouchers}")),
      DataCell(Text(_formatDate(v.startDate))),
      DataCell(Text(_formatDate(v.endDate))),
      DataCell(Text(_statusLabel(v.status))),
      DataCell(Text("${v.maxUsagePerCustomer}")),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Get.toNamed(Routes.SHOP_VOUCHER_ADD, arguments: v),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(v),
          ),
        ],
      )),
    ]);
  }

  String _formatDiscount(Voucher v) {
    final value = v.discountValue;

    if (value == null || value == 0) return "N/A";

    switch (v.discountType.toUpperCase()) {
      case "PERCENTAGE":
        return "${(value * 100).toStringAsFixed(0)}%";
      case "AMOUNT":
        return controller.formatCurrency(value); // 👈 Format tiền
      default:
        return "N/A";
    }
  }



  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case "ACTIVE":
        return "Đang hoạt động";
      case "INACTIVE":
        return "Ngưng hoạt động";
      case "PENDING":
        return "Sắp diễn ra";
      default:
        return status;
    }
  }

  void _confirmDelete(Voucher v) {
    Get.defaultDialog(
      title: "Xác nhận xoá",
      middleText: "Bạn có chắc muốn xoá mã '${v.code}'?",
      textCancel: "Huỷ",
      textConfirm: "Đồng ý",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        await controller.deleteVoucher(v.code);
      },
    );
  }

  void _showFilterDialog() {
    final statusOptions = {
      'Tất cả': null,
      'Đang hoạt động': 'ACTIVE',
      'Sắp diễn ra': 'PENDING',
      'Ngưng hoạt động': 'INACTIVE',
    };

    final discountTypeOptions = {
      'Tất cả': null,
      'Phần trăm (%)': 'PERCENTAGE',
      'Số tiền (₫)': 'AMOUNT',
    };

    // Biến tạm để xử lý trong dialog
    String? tempSelectedStatus = controller.selectedStatus.value;
    String? tempSelectedType = controller.selectedDiscountType.value;
    String tempSearchKeyword = controller.searchKeyword.value;

    VoucherSortType tempSortType = controller.sortType.value;

    final sortOptions = {
      'Mặc định': VoucherSortType.none,
      'Tên A → Z': VoucherSortType.nameAsc,
      'Tên Z → A': VoucherSortType.nameDesc,
      'Giá trị tăng dần': VoucherSortType.valueAsc,
      'Giá trị giảm dần': VoucherSortType.valueDesc,
      'Ngày bắt đầu tăng': VoucherSortType.startDateAsc,
      'Ngày bắt đầu giảm': VoucherSortType.startDateDesc,
    };

    Get.defaultDialog(
      title: "Bộ lọc",
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mã giảm giá
              Text("🔍 Mã giảm giá", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              TextFormField(
                initialValue: tempSearchKeyword,
                onChanged: (val) => tempSearchKeyword = val,
                decoration: InputDecoration(
                  hintText: "Nhập mã giảm giá",
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 16),

              // Trạng thái
              Text("📌 Trạng thái", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: statusOptions.entries
                      .firstWhere((e) => e.value == tempSelectedStatus, orElse: () => MapEntry('Tất cả', null))
                      .key,
                  underline: SizedBox(),
                  onChanged: (label) {
                    setState(() => tempSelectedStatus = statusOptions[label]);
                  },
                  items: statusOptions.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),

              // Loại giảm giá
              Text("🎯 Loại giảm giá", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: discountTypeOptions.entries
                      .firstWhere((e) => e.value == tempSelectedType, orElse: () => MapEntry('Tất cả', null))
                      .key,
                  underline: SizedBox(),
                  onChanged: (label) {
                    setState(() => tempSelectedType = discountTypeOptions[label]);
                  },
                  items: discountTypeOptions.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              Text("📊 Sắp xếp theo", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: sortOptions.entries
                      .firstWhere((e) => e.value == tempSortType, orElse: () => MapEntry('Mặc định', VoucherSortType.none))
                      .key,
                  underline: SizedBox(),
                  onChanged: (label) {
                    setState(() => tempSortType = sortOptions[label]!);
                  },
                  items: sortOptions.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(height: 20),

              // Nút hành động
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
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
                      ),
                      onPressed: () {
                        controller.searchKeyword.value = tempSearchKeyword;
                        controller.selectedStatus.value = tempSelectedStatus;
                        controller.selectedDiscountType.value = tempSelectedType;
                        controller.sortType.value = tempSortType;
                        controller.applyFilter();
                        Get.back();
                      },
                      child: Text("Áp dụng"),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

}

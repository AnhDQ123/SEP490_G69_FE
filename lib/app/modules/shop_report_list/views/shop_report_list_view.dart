import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/report_view.dart';
import '../controllers/shop_report_list_controller.dart';

class ShopReportListView extends StatelessWidget {
  final ShopReportListController reportController = Get.put(ShopReportListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách báo cáo cửa hàng'),
      ),
      body: Obx(() {
        if (reportController.isLoading.value) {
          return Center(child: CircularProgressIndicator()); // Hiển thị loading khi đang tải dữ liệu
        } else if (reportController.reports.isEmpty) {
          return Center(child: Text('Chưa có báo cáo nào')); // Hiển thị thông báo nếu không có báo cáo
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Danh sách báo cáo
              Expanded(
                child: ListView.builder(
                  itemCount: reportController.reports.length,
                  itemBuilder: (context, index) {
                    ReportViewDTO report = reportController.reports[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(report.reportName ?? 'Không có tên'),
                        subtitle: Text(report.reason ?? 'Không có lý do'),
                        trailing: Text(report.createdAt != null
                            ? DateFormat('dd/MM/yyyy HH:mm').format(report.createdAt!)
                            : 'Không rõ thời gian'),

                        onTap: () {
                          // Mở chi tiết báo cáo
                        },
                      ),
                    );
                  },
                ),
              ),
              // Phân trang
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: reportController.previousPage,
                      child: Text('Trang trước'),
                    ),
                    ElevatedButton(
                      onPressed: reportController.nextPage,
                      child: Text('Trang tiếp'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),

    );
  }
}

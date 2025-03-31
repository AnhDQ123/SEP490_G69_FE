import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/send_report_controller.dart';

class SendReportView extends StatelessWidget {
  final SendReportController reportController = Get.put(SendReportController());
  final TextEditingController _reasonController = TextEditingController(); // Controller cho TextField

  @override
  Widget build(BuildContext context) {
    // Giả lập khi báo cáo là sản phẩm và tên sản phẩm là "Cơm Rang"
    reportController.updateReportTypeFromDB(6, 'Cơm Rang', 1); // Cập nhật loại báo cáo và tên sản phẩm

    return Scaffold(
      appBar: AppBar(
        title: Text('Báo cáo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị trạng thái loading nếu đang gửi báo cáo
              if (reportController.isLoading.value)
                Center(
                  child: CircularProgressIndicator(),
                ),
              // Loại hình báo cáo
              Text(
                'Loại hình báo cáo:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Obx(() => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    _showReasonSelectionSheet(context); // Hiển thị BottomSheet khi nhấn vào loại báo cáo
                  },
                  child: Text(
                    '${reportController.reportType.value}: ${reportController.reportItem.value}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              )),

              // Chọn lý do báo cáo
              SizedBox(height: 16),
              Text(
                'Chọn lý do báo cáo:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    _showReasonSelectionSheet(context); // Hiển thị BottomSheet khi nhấn vào lý do
                  },
                  child: Text(
                    reportController.selectedOption.value.isEmpty
                        ? 'Chưa chọn lý do'
                        : reportController.selectedOption.value,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
                );
              }),

              // Nhập lý do chi tiết nếu chọn "Khác"
              SizedBox(height: 16),
              Obx(() {
                if (reportController.selectedOption.value == 'Khác') {
                  return TextField(
                    controller: _reasonController,
                    onChanged: (value) {
                      reportController.detailedReason.value = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nhập lý do chi tiết...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                  );
                } else {
                  return Container(); // Không hiển thị trường nhập lý do chi tiết nếu không chọn "Khác"
                }
              }),

              // Chọn ảnh (tối đa 5 ảnh)
              SizedBox(height: 16),
              Text(
                'Chọn ảnh:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  reportController.pickImages(); // Chọn ảnh
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), backgroundColor: Colors.blue),
                child: Text('Chọn ảnh (tối đa 5 ảnh)', style: TextStyle(fontSize: 14)),
              ),

              // Hiển thị danh sách ảnh đã chọn
              SizedBox(height: 16),
              Obx(() {
                return reportController.selectedImages.isEmpty
                    ? Text('Chưa chọn ảnh', style: TextStyle(fontSize: 16))
                    : Wrap(
                  spacing: 8.0, // spacing between images
                  runSpacing: 8.0, // vertical spacing between images
                  children: reportController.selectedImages.map((image) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(image.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                );
              }),

              // Nút gửi báo cáo
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  reportController.submitReport(); // Gọi hàm gửi báo cáo
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), backgroundColor: Colors.green),
                child: Text('Gửi báo cáo', style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Hiển thị BottomSheet để chọn lý do báo cáo
  void _showReasonSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          List<String> options = [];
          if (reportController.reportType.value == 'Sản phẩm') {
            options = reportController.productOptions;
          } else if (reportController.reportType.value == 'Cửa hàng') {
            options = reportController.shopOptions;
          } else if (reportController.reportType.value == 'Blog') {
            options = reportController.blogOptions;
          }

          return ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  if (options[index] == 'Khác') {
                    reportController.selectedOption.value = options[index];
                    Navigator.pop(context); // Đóng BottomSheet khi chọn "Khác"
                    // Khi chọn "Khác", chúng ta không cần mở thêm BottomSheet nữa vì đã có TextField ở ngoài
                  } else {
                    reportController.selectedOption.value = options[index];
                    Navigator.pop(context); // Đóng BottomSheet sau khi chọn lý do
                  }
                },
              );
            },
          );
        });
      },
    );
  }
}

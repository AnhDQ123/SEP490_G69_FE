import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';  // Import ImagePicker
import '../controllers/shop_report_controller.dart';  // Import controller

class ShopReportView extends StatelessWidget {
  final ShopReportController reportController = Get.put(ShopReportController());

  // Hàm để chọn ảnh từ thư viện
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);  // Chọn ảnh từ thư viện

    if (image != null) {
      reportController.addEvidenceImage(image); // Gửi ảnh đã chọn lên controller để xử lý
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo cáo'),
      ),
      body: SingleChildScrollView(  // Bọc toàn bộ Column bằng SingleChildScrollView để cho phép cuộn
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown chọn loại hình báo cáo
            Text('Loại hình báo cáo:'),
            Obx(
                  () => DropdownButton<int>(
                value: reportController.report.value != null
                    ? reportController.report.value!.reportType == 'Blog'
                    ? 4
                    : reportController.report.value!.reportType == 'Shop'
                    ? 5
                    : 6
                    : 6,  // Mặc định là "Sản phẩm"
                items: [
                  DropdownMenuItem<int>(value: 4, child: Text('Blog')),
                  DropdownMenuItem<int>(value: 5, child: Text('Cửa hàng')),
                  DropdownMenuItem<int>(value: 6, child: Text('Sản phẩm')),
                ],
                onChanged: (value) {
                  reportController.updateReportType(value!);
                },
              ),
            ),

            // Hiển thị tên đối tượng báo cáo (Sản phẩm, Cửa hàng, Blog)
            SizedBox(height: 16),
            Text('Tên ${reportController.reportType.value}:'),
            Obx(
                  () => Text(
                reportController.report.value?.reportName ?? 'Chưa có tên',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // Hiển thị ảnh báo cáo cuộn ngang
            SizedBox(height: 16),
            Text('Ảnh báo cáo:'),
            Obx(
                  () {
                if (reportController.report.value?.image.isEmpty ?? true) {
                  return Text('Chưa có ảnh báo cáo');
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: reportController.report.value!.image.map((img) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0), // Khoảng cách giữa các ảnh
                          child: Image.network(
                            img.url,  // Lấy URL của ảnh từ ImageDTO
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,  // Đảm bảo ảnh không bị méo
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),

            // Nút cung cấp bằng chứng (chọn ảnh)
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickImage,  // Sử dụng hàm pickImage để chọn ảnh
              child: Text('Cung cấp bằng chứng (Chọn ảnh)'),
            ),

            // Hiển thị ảnh bằng chứng đã cung cấp
            SizedBox(height: 16),
            Text('Ảnh bằng chứng đã cung cấp:'),
            Obx(() {
              if (reportController.evidenceImages.isEmpty) {
                return Text('Chưa có ảnh bằng chứng');
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: reportController.evidenceImages.map((img) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.file(
                          File(img.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            }),

            // Nút gửi ảnh bằng chứng lên server
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: reportController.uploadEvidenceImages, // Gửi ảnh lên server
              child: Text('Gửi ảnh bằng chứng'),
            ),

            // Hiển thị trạng thái xử lý
            SizedBox(height: 16),
            Text('Trạng thái xử lý:'),
            Obx(() {
              return Text(
                reportController.report.value?.status ?? 'Chưa có trạng thái',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              );
            }),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/send_report_controller.dart';

class SendReportView extends StatelessWidget {
  final SendReportController reportController = Get.put(SendReportController());
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khiếu nại',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Loại hình báo cáo
                  _buildSectionHeader('Loại hình báo cáo'),
                  _buildSelectionCard(
                    '${reportController.reportType.value}: ${reportController.reportItem.value}',
                    onTap: () => _showReasonSelectionSheet(context),
                  ),

                  // Section 2: Lý do báo cáo
                  SizedBox(height: 24),
                  _buildSectionHeader('Lý do báo cáo'),
                  _buildSelectionCard(
                    reportController.selectedOption.value.isEmpty
                        ? 'Chọn lý do báo cáo'
                        : reportController.selectedOption.value,
                    onTap: () => _showReasonSelectionSheet(context),
                  ),

                  // Section 3: Lý do chi tiết (nếu chọn "Khác")
                  if (reportController.selectedOption.value == 'Khác') ...[
                    SizedBox(height: 16),
                    TextField(
                      controller: _reasonController,
                      onChanged: (value) => reportController.detailedReason.value = value,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Nhập lý do chi tiết...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ],

                  // Section 4: Ảnh đính kèm
                  SizedBox(height: 24),
                  _buildSectionHeader('Ảnh đính kèm (tối đa 5 ảnh)'),
                  SizedBox(height: 8),
                  _buildImageSelectionSection(),

                  // Section 5: Nút gửi
                  SizedBox(height: 32),
                  _buildSubmitButton(),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Loading indicator
            if (reportController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildSelectionCard(String text, {VoidCallback? onTap}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: text == 'Chọn lý do báo cáo'
                        ? Colors.grey[500]
                        : Colors.blue[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelectionSection() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.add_photo_alternate, size: 20),
          label: Text('Thêm ảnh'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: reportController.pickImages,
        ),
        SizedBox(height: 16),
        Obx(() {
          if (reportController.selectedImages.isEmpty) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.photo_library, size: 40, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text(
                    'Chưa có ảnh nào được chọn',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          } else {
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: reportController.selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(reportController.selectedImages[index].path),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => reportController.removeImage(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: reportController.submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'GỬI KHIẾU NẠI',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _showReasonSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Chọn lý do',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(height: 1),
              ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(options[index]),
                    onTap: () {
                      reportController.selectedOption.value = options[index];
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              SizedBox(height: 16),
            ],
          );
        });
      },
    );
  }
}
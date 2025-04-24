import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/send_report_controller.dart';

class SendReportView extends StatelessWidget {
  final SendReportController reportController = Get.put(SendReportController());
  final TextEditingController _reasonController = TextEditingController();
  final Color primaryColor = Color.fromRGBO(212, 163, 115, 1);
  final Color secondaryColor = Color.fromRGBO(244, 241, 234, 1);
  final Color darkColor = Color.fromRGBO(60, 56, 54, 1);

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
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [secondaryColor.withOpacity(0.3), Colors.white],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Loại hình báo cáo
                    _buildSectionHeader('Loại hình báo cáo'),
                    SizedBox(height: 8),
                    _buildSelectionCard(
                      '${reportController.reportType.value}: ${reportController.reportItem.value}',
                      onTap: () => _showReasonSelectionSheet(context),
                    ),

                    // Section 2: Lý do báo cáo
                    SizedBox(height: 24),
                    _buildSectionHeader('Lý do báo cáo'),
                    SizedBox(height: 8),
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
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        style: TextStyle(color: darkColor),
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
            ),

            // Loading indicator
            if (reportController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                        SizedBox(height: 16),
                        Text('Đang xử lý...',
                            style: TextStyle(color: darkColor, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkColor,
        ),
      ),
    );
  }

  Widget _buildSelectionCard(String text, {VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: primaryColor.withOpacity(0.1),
        highlightColor: primaryColor.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: text == 'Chọn lý do báo cáo'
                        ? Colors.grey[500]
                        : darkColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: primaryColor),
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
          icon: Icon(Icons.add_photo_alternate, size: 20, color: Colors.white),
          label: Text('Thêm ảnh', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            shadowColor: primaryColor.withOpacity(0.4),
          ),
          onPressed: reportController.pickImages,
        ),
        SizedBox(height: 16),
        Obx(() {
          if (reportController.selectedImages.isEmpty) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.photo_library, size: 40, color: primaryColor.withOpacity(0.6)),
                  SizedBox(height: 12),
                  Text(
                    'Chưa có ảnh nào được chọn',
                    style: TextStyle(color: darkColor.withOpacity(0.6)),
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
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: reportController.selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
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
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
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
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: primaryColor.withOpacity(0.5),
        ),
        child: Text(
          'GỬI KHIẾU NẠI',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  void _showReasonSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
                    color: darkColor,
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.grey[300]),
              ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(options[index],
                        style: TextStyle(color: darkColor)),
                    onTap: () {
                      reportController.selectedOption.value = options[index];
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 24),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  );
                },
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text('Đóng',
                      style: TextStyle(color: primaryColor)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 8),
            ],
          );
        });
      },
    );
  }
}

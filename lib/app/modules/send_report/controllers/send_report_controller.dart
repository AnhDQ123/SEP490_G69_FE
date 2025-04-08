import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/report_create.dart';
import '../../../service/report_service.dart'; // Dùng để chọn ảnh từ thư viện hoặc camera

class SendReportController extends GetxController {
  var reportType = ''.obs; // Loại hình báo cáo
  var reportItem = ''.obs;  // Tên sản phẩm, blog, shop
  var selectedOption = ''.obs; // Lý do báo cáo đã chọn
  var detailedReason = ''.obs; // Lý do chi tiết
  var relatedId = 0.obs; // ID đối tượng liên quan (sản phẩm, blog, cửa hàng)
  var selectedImages = <XFile>[].obs; // Danh sách ảnh đã chọn (tối đa 5 ảnh)
  var isLoading = false.obs;  // Biến theo dõi trạng thái loading


  final ReportService reportService = ReportService(); // Sử dụng service để gửi báo cáo

  // Các lý do báo cáo mặc định cho từng loại hình
  final productOptions = ['Chất lượng sản phẩm không tốt', 'Sản phẩm không giống mô tả', 'Giá không hợp lý', 'Sản phẩm hết hàng', 'Khác'].obs;
  final shopOptions = ['Chất lượng dịch vụ không tốt', 'Giao hàng không đúng hẹn', 'Giá không hợp lý', 'Giao tiếp với khách hàng kém', 'Khác'].obs;
  final blogOptions = ['Nội dung không đúng sự thật', 'Bài viết không phù hợp', 'Nội dung sai lệch', 'Quảng cáo quá mức', 'Khác'].obs;

  // Giả lập cơ sở dữ liệu (có thể là sản phẩm, cửa hàng, blog, v.v.)
  final Map<int, String> products = {1: 'Cơm Rang', 2: 'Phở', 3: 'Bánh Mì'}; // Dữ liệu sản phẩm
  final Map<int, String> shops = {1: 'Cửa hàng ABC', 2: 'Cửa hàng XYZ'}; // Dữ liệu cửa hàng
  final Map<int, String> blogs = {1: 'Blog về ẩm thực', 2: 'Blog về du lịch'}; // Dữ liệu blog


  @override
  void onInit() {
    super.onInit();

    // Nhận thông tin từ arguments
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final typeId = arguments['typeId'] ?? 0;
    final itemId = arguments['itemId'] ?? 0;
    final itemName = arguments['itemName'] ?? '';

    // Cập nhật loại báo cáo
    updateReportTypeFromDB(typeId, itemName, itemId);
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      selectedImages.refresh(); // Cập nhật UI
    }
  }
  // Cập nhật loại báo cáo từ cơ sở dữ liệu theo type_id và tên đối tượng
  void updateReportTypeFromDB(int typeId, String itemName, int itemId) {
    if (typeId == 4) {
      reportType.value = 'Blog';
      reportItem.value = itemName; // Dùng trực tiếp từ arguments
      relatedId.value = itemId;
    } else if (typeId == 5) {
      reportType.value = 'Cửa hàng';
      reportItem.value = itemName; // Dùng trực tiếp từ arguments
      relatedId.value = itemId;
    } else if (typeId == 6) {
      reportType.value = 'Sản phẩm';
      reportItem.value = itemName; // Dùng trực tiếp từ arguments
      relatedId.value = itemId;
    }
  }
  // Chọn ảnh từ thiết bị (tối đa 5 ảnh)
  Future<void> pickImages() async {
    final picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      if (pickedFiles.length > 5) {
        // Giới hạn số lượng ảnh là 5
        selectedImages.assignAll(pickedFiles.take(5));
      } else {
        selectedImages.assignAll(pickedFiles);
      }
    }
  }

  void submitReport() async {
    try {
      // Kiểm tra điều kiện trước khi gửi
      if (selectedOption.isEmpty && detailedReason.isEmpty) {
        Get.snackbar(
          'Lỗi',
          'Vui lòng chọn lý do hoặc nhập mô tả chi tiết',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      String reason = selectedOption.value.isEmpty
          ? detailedReason.value
          : selectedOption.value;

      List<File> imagesToUpload = selectedImages.map((xFile) => File(xFile.path)).toList();

      ReportCreateDTO reportCreateDTO = ReportCreateDTO(
        userId: 34, // Nên thay bằng userId thực tế
        relatedId: relatedId.value,
        typeId: getReportTypeId(reportType.value),
        reason: reason,
        options: [reason],
      );

      bool result = await reportService.createReport(reportCreateDTO, imagesToUpload);

      if (result) {
        Get.snackbar(
          'Thành công',
          'Báo cáo của bạn đã được gửi thành công!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        await Future.delayed(Duration(seconds: 1));
        Get.back(); // Tự động quay lại sau khi gửi thành công
      } else {
        Get.snackbar(
          'Lỗi',
          'Không thể gửi báo cáo. Vui lòng thử lại sau',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      Get.snackbar(
        'Lỗi hệ thống',
        'Đã xảy ra lỗi khi gửi báo cáo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy typeId từ tên loại báo cáo
  int getReportTypeId(String reportTypeName) {
    if (reportTypeName == 'Sản phẩm') {
      return 6; // ID của loại báo cáo sản phẩm
    } else if (reportTypeName == 'Cửa hàng') {
      return 5; // ID của loại báo cáo cửa hàng
    } else if (reportTypeName == 'Blog') {
      return 4; // ID của loại báo cáo blog
    } else {
      return 0; // Default hoặc lỗi
    }
  }
}

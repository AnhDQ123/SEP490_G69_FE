import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../service/report_service.dart';
import '../../../models/report_view.dart';

class ShopReportController extends GetxController {
  var reportType = 'Món ăn'.obs;
  var itemName = 'Tên món'.obs;
  var reportTime = DateTime.now().obs;
  var reason = ''.obs;

  // Khai báo biến cho thông tin báo cáo
  var reportId = 0.obs;
  var report = Rxn<ReportViewDTO>();
  var evidenceImages = <XFile>[].obs;  // Biến lưu ảnh bằng chứng

  final ReportService reportService = ReportService();

  @override
  void onInit() {
    super.onInit();
    // Nhận reportId từ arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments['reportId'] != null) {
      reportId.value = arguments['reportId'];
      fetchReport(reportId.value);
    }
  }

  // Lấy thông tin báo cáo từ API
  void fetchReport(int id) async {
    var fetchedReport = await reportService.getReportById(id);
    if (fetchedReport != null) {
      report.value = fetchedReport;
      reportTime.value = fetchedReport.createdAt;
    }
  }

  // Cập nhật loại báo cáo từ type_id
  void updateReportType(int typeId) {
    if (typeId == 4) {
      reportType.value = 'Blog';
    } else if (typeId == 5) {
      reportType.value = 'Shop';
    } else if (typeId == 6) {
      reportType.value = 'Product';
    }
    updateItemName();
  }

  // Cập nhật tên món, cửa hàng hoặc blog
  void updateItemName() {
    if (reportType.value == 'Product') {
      itemName.value = 'Tên sản phẩm';
    } else if (reportType.value == 'Shop') {
      itemName.value = 'Tên cửa hàng';
    } else if (reportType.value == 'Blog') {
      itemName.value = 'Tên blog';
    }
  }

  // Phương thức thêm ảnh bằng chứng
  void addEvidenceImage(XFile image) {
    // Giới hạn tối đa 5 ảnh
    if (evidenceImages.length < 5) {
      evidenceImages.add(image);
    } else {
      Get.snackbar('Thông báo', 'Chỉ có thể thêm tối đa 5 ảnh');
    }
  }

  // Gửi ảnh bằng chứng lên server
  Future<void> uploadEvidenceImages() async {
    try {
      // Chuyển XFile thành List<File> cho phương thức API
      List<File> images = evidenceImages.map((e) => File(e.path)).toList();

      // Gọi API để gửi ảnh bằng chứng lên server
      bool result = await reportService.addEvidence(reportId.value, images);

      if (result) {
        Get.snackbar('Thông báo', 'Bằng chứng đã được cung cấp thành công');
      } else {
        Get.snackbar('Thông báo', 'Đã xảy ra lỗi khi cung cấp bằng chứng');
      }
    } catch (e) {
      Get.snackbar('Thông báo', 'Có lỗi xảy ra khi gửi ảnh bằng chứng');
    }
  }
}


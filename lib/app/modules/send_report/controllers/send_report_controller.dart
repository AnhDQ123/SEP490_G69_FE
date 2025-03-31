import 'dart:io';
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

  // Cập nhật loại báo cáo từ cơ sở dữ liệu theo type_id và tên đối tượng
  void updateReportTypeFromDB(int typeId, String itemName, int itemId) {
    // Cập nhật loại báo cáo từ cơ sở dữ liệu
    if (typeId == 4) {
      reportType.value = 'Blog';
      reportItem.value = blogs[itemId] ?? 'Không xác định'; // Lấy tên blog từ dữ liệu
      relatedId.value = itemId; // Gán relatedId cho blog
    } else if (typeId == 5) {
      reportType.value = 'Cửa hàng';
      reportItem.value = shops[itemId] ?? 'Không xác định'; // Lấy tên cửa hàng từ dữ liệu
      relatedId.value = itemId; // Gán relatedId cho cửa hàng
    } else if (typeId == 6) {
      reportType.value = 'Sản phẩm';
      reportItem.value = products[itemId] ?? 'Không xác định'; // Lấy tên sản phẩm từ dữ liệu
      relatedId.value = itemId; // Gán relatedId cho sản phẩm
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

  // Hàm gửi báo cáo
  // Hàm gửi báo cáo
  void submitReport() async {
    try {
      isLoading.value = true;  // Đánh dấu bắt đầu gửi báo cáo

      String reason = selectedOption.value.isEmpty ? detailedReason.value : selectedOption.value;
      List<File> imagesToUpload = selectedImages.map((xFile) => File(xFile.path)).toList();

      ReportCreateDTO reportCreateDTO = ReportCreateDTO(
        userId: 34, // Giả sử đây là ID của người báo cáo (có thể lấy từ session hoặc user)
        relatedId: relatedId.value, // ID đối tượng liên quan (sản phẩm, blog, cửa hàng...)
        typeId: getReportTypeId(reportType.value), // Lấy typeId từ tên loại báo cáo
        reason: reason,
        options: [reason], // Gửi lý do dưới dạng một chuỗi duy nhất (không phải file)
      );

      bool result = await reportService.createReport(reportCreateDTO, imagesToUpload);

      if (result) {
        Get.snackbar('Thông báo', 'Báo cáo của bạn đã được gửi!', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Thông báo', 'Đã xảy ra lỗi khi gửi báo cáo.', snackPosition: SnackPosition.BOTTOM);
      }

    } catch (e) {
      print('Error occurred: $e');  // Log lỗi để debug
      Get.snackbar('Thông báo', 'Đã xảy ra lỗi khi gửi báo cáo.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;  // Đánh dấu kết thúc quá trình gửi báo cáo
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

import 'package:get/get.dart';
import '../../../models/report_view.dart';
import '../../../service/report_service.dart';


class ShopReportListController extends GetxController {
  var shopId = 1.obs; // ID cửa hàng, có thể được truyền từ trang trước
  var reports = <ReportViewDTO>[].obs; // Danh sách các báo cáo
  var isLoading = false.obs; // Trạng thái loading
  var currentPage = 1.obs; // Trạng thái trang hiện tại
  var totalPages = 1.obs; // Tổng số trang
  final ReportService reportService = ReportService();

  @override
  void onInit() {
    super.onInit();
    fetchReports(); // Lấy danh sách báo cáo khi controller khởi tạo
  }

  // Hàm lấy báo cáo của cửa hàng
  Future<void> fetchReports() async {
    try {
      isLoading(true);

      var result = await reportService.getAllByShop(shopId.value, currentPage.value - 1, 20);

      // Không ép cứng kiểu luôn
      final dynamic rawList = result['reports'];
      final dynamic rawPages = result['totalPages'];

      if (rawList != null && rawList is List) {
        final reportList = rawList.cast<ReportViewDTO>(); // ✅ Ép an toàn hơn
        final pages = rawPages is int ? rawPages : 1;

        reports.assignAll(reportList);
        totalPages.value = pages;
      } else {
        reports.clear();
        Get.snackbar('Thông báo', 'Chưa có báo cáo nào');
      }
    } catch (e) {
      print('Error: $e');
      reports.clear();
      Get.snackbar('Thông báo', 'Có lỗi xảy ra khi tải báo cáo');
    } finally {
      isLoading(false);
    }
  }





  // Hàm chuyển sang trang tiếp theo
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchReports();
    }
  }

  // Hàm quay lại trang trước
  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchReports();
    }
  }
}


import 'package:get/get.dart';
import '../../../models/discount.dart';
import '../../../models/product.dart';
import '../../../service/shop_service.dart';

class ProductDiscountController extends GetxController {
  // Danh sách sản phẩm đang có giảm giá
  var discountProducts = <Product>[].obs;

  // Danh sách sản phẩm chưa có giảm giá
  var noDiscountProducts = <Product>[].obs;

  final ShopService shopService = ShopService();  // Khởi tạo ShopService để gọi API

  @override
  void onInit() {
    super.onInit();
    // Gọi API để tải sản phẩm khi controller khởi tạo
    fetchProducts();
  }

  // Gọi API để lấy sản phẩm theo shopId
  Future<void> fetchProducts() async {
    try {
      final products = await shopService.fetchProductsByShop(1); // 1 là shopId, thay đổi theo nhu cầu
      // Phân loại sản phẩm theo có giảm giá hay không
      for (var product in products) {
        // Kiểm tra xem sản phẩm có đợt giảm giá nào có trạng thái "ACTIVE" không
        bool hasActiveDiscount = product.discount.any((discount) => discount.status == 'ACTIVE');

        if (hasActiveDiscount) {
          discountProducts.add(product);  // Thêm vào danh sách sản phẩm có giảm giá
        } else {
          noDiscountProducts.add(product);  // Thêm vào danh sách sản phẩm không có giảm giá
        }
      }
    } catch (e) {
      print('Lỗi khi tải sản phẩm: $e');
    }
  }


  // Phương thức tạo giảm giá cho sản phẩ

  // Hàm kiểm tra xem có giảm giá đang áp dụng hay không
  bool isDiscountActive(Product product) {
    return product.discount.any((discount) => discount.status == 'ACTIVE');
  }
}

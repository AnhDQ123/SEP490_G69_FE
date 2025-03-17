import 'package:get/get.dart';
import '../../../models/product.dart';

class RecommendedProductsController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedProducts();
  }

  Future<void> fetchRecommendedProducts() async {
    try {
      isLoading.value = true;
      // Giả lập gọi API
      await Future.delayed(const Duration(seconds: 2));
      var fetchedProducts = [
        Product(
          imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
          name: 'Sản phẩm 1',
          rating: 4.5,
          price: 100000,
          shopName: 'Shop A',
          discount: 10, // giảm 10%
        ),
        Product(
          imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
          name: 'Sản phẩm 2',
          rating: 4.0,
          price: 150000,
          shopName: 'Shop B',
          discount: 0, // không giảm
        ),
        Product(
          imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
          name: 'Sản phẩm 3',
          rating: 3.5,
          price: 90000,
          shopName: 'Shop C',
          discount: 5, // giảm 5%
        ),
        Product(
          imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
          name: 'Sản phẩm 4',
          rating: 4.2,
          price: 120000,
          shopName: 'Shop D',
          discount: 15, // giảm 15%
        ),
        Product(
          imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
          name: 'Sản phẩm 4',
          rating: 4.2,
          price: 120000,
          shopName: 'Shop D',
          discount: 15, // giảm 15%
        ),
        // Thêm sản phẩm khác nếu cần
      ];
      products.assignAll(fetchedProducts);
    } catch (e) {
      errorMessage.value = 'Có lỗi xảy ra: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

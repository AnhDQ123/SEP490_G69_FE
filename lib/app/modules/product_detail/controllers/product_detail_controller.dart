import 'package:get/get.dart';
import '../../../models/extra_option.dart';
import '../../../models/product_detail_model.dart';
import '../../../models/similar_product.dart';
import '../../../service/product_detail_service.dart';

class ProductDetailController extends GetxController {

  var _product = Rxn<ProductDetailModel>();
  var similarProducts = <SimilarProduct>[].obs;
  var extraOptions = <ExtraOption>[].obs;
  var menuProducts = <SimilarProduct>[].obs;
  var drinkProducts = <SimilarProduct>[].obs;
  var quantity = 1.obs;
  var selectedSizeIndex = 0.obs;
  var isDescriptionExpanded = false.obs;
  var isReviewExpanded = false.obs;

  final ProductDetailApiService apiService = ProductDetailApiService();

  // Getter để UI truy cập dữ liệu sản phẩm. Nếu _product chưa có dữ liệu, trả về đối tượng mẫu.
  ProductDetailModel get currentProduct =>
      _product.value ??
          ProductDetailModel(
            id: '',
            name: '',
            description: '',
            imageUrl: '',
            price: 0,
            quantity: 0,
            rating: 0,
            sizes: [],
            foodOptions: [],
          );

  @override
  void onInit() {
    super.onInit();
    fetchProductData();

    menuProducts.assignAll([
      SimilarProduct(
        imageUrl: 'https://via.placeholder.com/80',
        name: 'Thực đơn 1',
        shopName: 'Shop A',
        price: 50000,
        rating: 5,
        quantity: 1,
      ),
      SimilarProduct(
        imageUrl: 'https://via.placeholder.com/80',
        name: 'Thực đơn 2',
        shopName: 'Shop B',
        price: 60000,
        rating: 5,
        quantity: 1,
      ),
    ]);

    drinkProducts.assignAll([
      SimilarProduct(
        imageUrl: 'https://via.placeholder.com/80',
        name: 'Đồ uống 1',
        shopName: 'Shop C',
        price: 30000,
        rating: 5,
        quantity: 1,
      ),
      SimilarProduct(
        imageUrl: 'https://via.placeholder.com/80',
        name: 'Đồ uống 2',
        shopName: 'Shop D',
        price: 35000,
        rating: 5,
        quantity: 1,
      ),
    ]);

    // Gán dữ liệu cứng cho phần đánh giá sản phẩm với ảnh user
    reviews.assignAll([
      {
        'user': 'Nguyễn Văn A',
        'avatar': 'https://via.placeholder.com/50', // URL ảnh đại diện
        'rating': 4.5,
        'comment': 'Sản phẩm rất tốt, chất lượng vượt mong đợi!'
      },
      {
        'user': 'Trần Thị B',
        'avatar': '', // Không có ảnh, hiển thị icon mặc định
        'rating': 3.0,
        'comment': 'Chất lượng bình thường, cần cải thiện thêm.'
      },
      {
        'user': 'Lê Văn C',
        'avatar': 'https://via.placeholder.com/50',
        'rating': 5.0,
        'comment': 'Xuất sắc! Sẽ ủng hộ và mua lại.'
      },
    ]);
  }


  void fetchProductData() async {
    // Kiểm tra xem Get.arguments có null không
    final productIdArg = Get.arguments;
    if (productIdArg == null) {
      print("Error: Product ID is null. Cannot fetch product data.");
      return;
    }
    final String productId = productIdArg.toString();

    try {
      ProductDetailModel detail = await apiService.getProductDetail(productId);
      _product.value = detail;

      extraOptions.assignAll(
        detail.foodOptions
            .where((option) => option.typeId == 1)
            .map((e) => ExtraOption(
          id: e.id.toString(),
          name: e.name,
          price: e.price,
          imageUrl: e.image.isNotEmpty ? e.image : null,
          unit: "suất", // Hoặc thay đổi theo logic của bạn
          selected: false,
          quantity: 1,
        ))
            .toList(),
      );

      List<SimilarProduct> similar =
      await apiService.getSimilarProducts(detail.name);
      similarProducts.assignAll(similar);
    } catch (e) {
      print("Error fetching product data: $e");
    }
  }

  /// Phương thức tăng số lượng mua
  void incrementQuantity() {
    quantity.value++;
  }

  /// Phương thức giảm số lượng mua (không cho giảm dưới 1)
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  double get currentPrice {
    if (_product.value == null) return 0;
    double basePrice = _product.value!.price;
    // Lọc danh sách các foodOption có typeId == 2 (đại diện cho size)
    List availableSizes = _product.value!.foodOptions
        .where((option) => option.typeId == 2)
        .toList();
    if (availableSizes.isNotEmpty) {
      int index = selectedSizeIndex.value;
      if (index < availableSizes.length) {
        // Giá hiển thị: giá cơ bản cộng thêm giá của option size được chọn
        return basePrice + availableSizes[index].price;
      }
    }
    return basePrice;
  }


  void selectSize(int index) {
    selectedSizeIndex.value = index;
  }


  void addToCartWithOptions() {
    final total = currentPrice * quantity.value + totalExtraPrice;
    print(
        "Thêm vào giỏ: ${currentProduct.name}, size index: ${selectedSizeIndex.value}, quantity: ${quantity.value}, Extra: ${_selectedOptionNames()}, total: $total");
  }

  double get totalExtraPrice {
    return extraOptions
        .where((option) => option.selected)
        .fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  String _selectedOptionNames() {
    final selected =
    extraOptions.where((o) => o.selected).map((o) => o.name).toList();
    return selected.isEmpty ? 'Không có' : selected.join(', ');
  }

  void decrementSimilarQuantity(RxList<SimilarProduct> list, int index) {
    if (list[index].quantity > 1) {
      list[index].quantity--;
      list.refresh();
    }
  }

  void incrementSimilarQuantity(RxList<SimilarProduct> list, int index) {
    list[index].quantity++;
    list.refresh();
  }

  void addProductToCart(SimilarProduct product) {
    print("Thêm sản phẩm tương tự vào giỏ: ${product.name} với số lượng ${product.quantity}");
  }

  var reviews = <dynamic>[].obs;

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  void toggleReviews() {
    isReviewExpanded.value = !isReviewExpanded.value;
  }

  void addToFavorite() {
    print("Thêm vào danh sách yêu thích");
  }

  void reportProduct() {
    print("Báo cáo sản phẩm");
  }

  void goToShop() {
    print("Đi đến trang Shop");
  }
}
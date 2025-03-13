import 'package:get/get.dart';
import '../../../models/extra_option.dart';
import '../../../models/product_detail_model.dart';
import '../../../models/similar_product.dart';
import '../../../service/product_detail_service.dart';

class ProductDetailController extends GetxController {
  // Biến _product chứa chi tiết sản phẩm được fetch từ API (giá trị ban đầu có thể là null)
  var _product = Rxn<ProductDetailModel>();

  // Danh sách sản phẩm tương tự được fetch từ API
  var similarProducts = <SimilarProduct>[].obs;

  // Danh sách extra options được lấy từ foodOptions của sản phẩm (loại có typeId == 1)
  var extraOptions = <ExtraOption>[].obs;

  // Danh sách sản phẩm thực đơn (menu) và đồ uống (drink)
  // Nếu API chưa có, bạn vẫn có thể khởi tạo dữ liệu mẫu hoặc gọi API riêng
  var menuProducts = <SimilarProduct>[].obs;
  var drinkProducts = <SimilarProduct>[].obs;

  // Biến quantity dùng để quản lý số lượng mua của người dùng (không thay đổi trực tiếp trong product)
  var quantity = 1.obs;

  // Biến trạng thái cho việc chọn size (ví dụ: 0, 1, 2) khi có nhiều lựa chọn size
  var selectedSizeIndex = 0.obs;

  // Các biến trạng thái khác, ví dụ như cho mô tả, đánh giá (nếu có)
  var isDescriptionExpanded = false.obs;
  var isReviewExpanded = false.obs;

  // Sử dụng service đã viết để gọi API lấy dữ liệu chi tiết sản phẩm và danh sách sản phẩm tương tự
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
    // Fetch dữ liệu sản phẩm khi controller được khởi tạo.
    fetchProductData();

    // Khởi tạo dữ liệu mẫu cho menuProducts và drinkProducts (có thể thay bằng API riêng nếu có)
    menuProducts.assignAll([
      SimilarProduct(
        imageUrl: 'https://via.placeholder.com/80',
        name: 'Thực đơn 1',
        shopName: 'Shop A',
        price: 50000,
        quantity: 1,
      ),
      SimilarProduct(
        imageUrl: 'https://via.placeholder.com/80',
        name: 'Thực đơn 2',
        shopName: 'Shop B',
        price: 60000,
        quantity: 1,
      ),
    ]);

    drinkProducts.assignAll([
      SimilarProduct(
        imageUrl: 'https://via.placeholder.com/80',
        name: 'Đồ uống 1',
        shopName: 'Shop C',
        price: 30000,
        quantity: 1,
      ),
      SimilarProduct(
        imageUrl: 'https://via.placeholder.com/80',
        name: 'Đồ uống 2',
        shopName: 'Shop D',
        price: 35000,
        quantity: 1,
      ),
    ]);
  }

  /// Hàm fetch dữ liệu sản phẩm từ API
  /// - Lấy productId từ Get.arguments (được truyền khi điều hướng)
  /// - Gọi API lấy chi tiết sản phẩm và danh sách sản phẩm tương tự
  void fetchProductData() async {
    // Kiểm tra xem Get.arguments có null không
    final productIdArg = Get.arguments;
    if (productIdArg == null) {
      print("Error: Product ID is null. Cannot fetch product data.");
      return;
    }
    final String productId = productIdArg.toString();

    try {
      // Gọi API lấy chi tiết sản phẩm.
      ProductDetailModel detail = await apiService.getProductDetail(productId);
      _product.value = detail;

      // Sau khi fetch product detail, cập nhật extraOptions từ foodOptions có typeId == 1
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

      // Gọi API lấy danh sách sản phẩm tương tự dựa trên tên sản phẩm
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

  /// Getter tính giá hiển thị hiện tại dựa trên giá cơ bản và tùy thuộc vào size được chọn.
  /// Giả sử các FoodOption có typeId == 2 đại diện cho size.
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

  /// Phương thức cập nhật trạng thái chọn size
  /// [index]: vị trí của size được chọn trong danh sách availableSizes
  void selectSize(int index) {
    selectedSizeIndex.value = index;
  }

  /// Phương thức thêm sản phẩm vào giỏ hàng với các option đã chọn
  /// Tính tổng giá dựa trên giá hiện tại và số lượng mua
  void addToCartWithOptions() {
    final total = currentPrice * quantity.value + totalExtraPrice;
    print(
        "Thêm vào giỏ: ${currentProduct.name}, size index: ${selectedSizeIndex.value}, quantity: ${quantity.value}, Extra: ${_selectedOptionNames()}, total: $total");
    // TODO: Thực hiện các logic thêm sản phẩm vào giỏ hàng, cập nhật trạng thái giỏ hàng, v.v.
  }

  /// Hàm tính tổng giá của các extra option đã chọn
  double get totalExtraPrice {
    return extraOptions
        .where((option) => option.selected)
        .fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  /// Hàm tiện ích lấy danh sách tên option đã chọn
  String _selectedOptionNames() {
    final selected =
    extraOptions.where((o) => o.selected).map((o) => o.name).toList();
    return selected.isEmpty ? 'Không có' : selected.join(', ');
  }

  /// Các phương thức xử lý sản phẩm tương tự (menuProducts và drinkProducts)
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
    // TODO: Thực hiện logic thêm sản phẩm tương tự vào giỏ hàng
  }

  // Ví dụ về xử lý toggle cho mô tả và đánh giá (nếu UI có yêu cầu)
  var reviews = <dynamic>[].obs;

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  void toggleReviews() {
    isReviewExpanded.value = !isReviewExpanded.value;
  }

  // Các phương thức khác như addToFavorite, reportProduct, goToShop
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

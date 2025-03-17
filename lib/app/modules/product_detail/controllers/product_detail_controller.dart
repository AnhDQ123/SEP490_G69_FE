import 'package:ffb_fe_flutter/app/models/product.dart';
import 'package:get/get.dart';
import '../../../models/extra_option.dart';
import '../../../service/product_detail_service.dart';

class ProductDetailController extends GetxController {

  var _product = Rxn<Product>();
  var similarProducts = <Product>[].obs;
  var extraOptions = <ExtraOption>[].obs;
  var menuProducts = <Product>[].obs;
  var drinkProducts = <Product>[].obs;
  var quantity = 1.obs;
  var selectedSizeIndex = 0.obs;
  var isDescriptionExpanded = false.obs;
  var isReviewExpanded = false.obs;

  final ProductDetailApiService apiService = ProductDetailApiService();

  // Getter để UI truy cập dữ liệu sản phẩm. Nếu _product chưa có dữ liệu, trả về đối tượng mẫu.
  Product get currentProduct => _product.value ??
      Product(
        id: 0,
        name: '',
        manufacturer: '',  // Thêm manufacturer với giá trị mặc định (ví dụ: chuỗi rỗng)
        supplier: '',      // Thêm supplier
        quantity: 0,
        category: '',      // Thêm category
        discount: 0.0,     // Thêm discount
        image: '',
        description: '',
        rate: 0.0,
        shop: '',          // Thêm shop
        defaultPrice: 0.0,
        foodOptions: [],
      );


  @override
  void onInit() {
    super.onInit();
    fetchProductData();

    menuProducts.assignAll([
      Product(
        id: 0,
        name: 'Thực đơn 1',
        manufacturer: '',     // Giá trị mặc định
        supplier: '',         // Giá trị mặc định
        quantity: 1,
        category: '',         // Giá trị mặc định
        discount: 0.0,        // Giá trị mặc định
        image: 'https://via.placeholder.com/80',
        description: '',      // Giá trị mặc định
        rate: 5,
        shop: 'Shop A',
        defaultPrice: 50000,
        foodOptions: [],      // Giá trị mặc định
      ),
      Product(
        id: 0,
        name: 'Thực đơn 2',
        manufacturer: '',
        supplier: '',
        quantity: 1,
        category: '',
        discount: 0.0,
        image: 'https://via.placeholder.com/80',
        description: '',
        rate: 5,
        shop: 'Shop B',
        defaultPrice: 60000,
        foodOptions: [],
      ),
    ]);


    drinkProducts.assignAll([
      Product(
        id: 0,
        name: 'Đồ uống 1',
        manufacturer: '',
        supplier: '',
        quantity: 1,
        category: '',
        discount: 0.0,
        image: 'https://via.placeholder.com/80',
        description: '',
        rate: 5,
        shop: 'Shop C',
        defaultPrice: 30000,
        foodOptions: [],
      ),
      Product(
        id: 0,
        name: 'Đồ uống 2',
        manufacturer: '',
        supplier: '',
        quantity: 1,
        category: '',
        discount: 0.0,
        image: 'https://via.placeholder.com/80',
        description: '',
        rate: 5,
        shop: 'Shop D',
        defaultPrice: 35000,
        foodOptions: [],
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
      Product detail = await apiService.getProductDetail(productId);
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

      List<Product> similar =
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
    double basePrice = _product.value!.defaultPrice;
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

  void decrementSimilarQuantity(RxList<Product> list, int index) {
    if (list[index].quantity > 1) {
      list[index].quantity--;
      list.refresh();
    }
  }

  void incrementSimilarQuantity(RxList<Product> list, int index) {
    list[index].quantity++;
    list.refresh();
  }

  void addProductToCart(Product product) {
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
import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/models/product.dart';
import 'package:ffb_fe_flutter/app/models/extra_option.dart';
import 'package:ffb_fe_flutter/app/service/product_detail_service.dart';
import 'package:ffb_fe_flutter/app/service/cart_api_service.dart';


import '../../../models/cartDTO.dart';

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
  var reviews = <dynamic>[].obs;

  final ProductDetailApiService apiService = ProductDetailApiService();
  final CartApiService cartApiService = CartApiService(); // Thêm service giỏ hàng

  // Getter trả về sản phẩm hiện tại, nếu null thì trả về đối tượng mẫu
  Product get currentProduct => _product.value ??
      Product(
        id: 0,
        name: '',
        manufacturer: '',
        supplier: '',
        quantity: 0,
        category: '',
        discount: 0.0,
        image: '',
        description: '',
        rate: 0.0,
        shop: '',
        defaultPrice: 0.0,
        foodOptions: [],
      );

  @override
  void onInit() {
    super.onInit();
    fetchProductData();

    // Các dữ liệu mẫu cho menuProducts, drinkProducts, reviews...
    menuProducts.assignAll([
      Product(
        id: 1,
        name: 'Thực đơn 1',
        manufacturer: '',
        supplier: '',
        quantity: 1,
        category: '',
        discount: 0.0,
        image: 'https://via.placeholder.com/80',
        description: '',
        rate: 5,
        shop: 'Shop A',
        defaultPrice: 50000,
        foodOptions: [],
      ),
      Product(
        id: 2,
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
        id: 3,
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
        id: 4,
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

    reviews.assignAll([
      {
        'user': 'Nguyễn Văn A',
        'avatar': 'https://via.placeholder.com/50',
        'rating': 4.5,
        'comment': 'Sản phẩm rất tốt, chất lượng vượt mong đợi!'
      },
      {
        'user': 'Trần Thị B',
        'avatar': '',
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
          unit: "suất",
          selected: false,
          quantity: 1,
        ))
            .toList(),
      );

      List<Product> similar = await apiService.getSimilarProducts(detail.name);
      similarProducts.assignAll(similar);
    } catch (e) {
      print("Error fetching product data: $e");
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  double get currentPrice {
    if (_product.value == null) return 0;
    double basePrice = _product.value!.defaultPrice;
    List availableSizes = _product.value!.foodOptions
        .where((option) => option.typeId == 2)
        .toList();
    if (availableSizes.isNotEmpty) {
      int index = selectedSizeIndex.value;
      if (index < availableSizes.length) {
        return basePrice + availableSizes[index].price;
      }
    }
    return basePrice;
  }

  void selectSize(int index) {
    selectedSizeIndex.value = index;
  }

  /// Cập nhật hàm addToCartWithOptions để gọi API
  void addToCartWithOptions() async {
    // Tính tổng tiền: giá sản phẩm (bao gồm option size) * số lượng + tổng tiền của extra options
    final double totalPrice = currentPrice * quantity.value + totalExtraPrice;

    // Xây dựng danh sách CartItemOptionDTO từ extraOptions được chọn
    List<CartItemOptionDTO> cartItemOptionDTOList = extraOptions
        .where((option) => option.selected)
        .map((option) => CartItemOptionDTO(
      optionId: int.tryParse(option.id) ?? 0,
      typeId: 1, // Thay đổi theo logic: 1 hoặc 2 tùy vào loại option
      optionName: option.name,
      image: option.imageUrl ?? '',
      cartItemId: 0, // Backend sẽ gán sau
      price: option.price,
      totalPrice: option.price * option.quantity,
      quantity: option.quantity,
    ))
        .toList();

    // Xây dựng CartItemDTO cho sản phẩm hiện tại
    CartItemDTO cartItemDTO = CartItemDTO(
      cartId: 0,
      productId: currentProduct.id,
      productName: currentProduct.name,
      image: currentProduct.image,
      price: currentProduct.defaultPrice,
      totalPrice: currentPrice * quantity.value,
      quantity: quantity.value,
      cartItemOptionDTOList: cartItemOptionDTOList,
    );

    // Xây dựng đối tượng CartDTO
    CartDTO cartDTO = CartDTO(
      id: 0,
      userId: 2, // Cần thay bằng userId thực tế khi có thông tin người dùng
      shopId: 0, // Bạn có thể lấy thông tin shop từ currentProduct hoặc logic khác
      shopName: currentProduct.shop,
      price: totalPrice,
      status: "PENDING",
      cartItemDTOList: [cartItemDTO],
    );

    try {
      bool success = await cartApiService.addToCart(cartDTO);
      if (success) {
        Get.snackbar("Thành công", "Đã thêm vào giỏ hàng");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể thêm vào giỏ hàng: $e");
    }
  }

  double get totalExtraPrice {
    return extraOptions
        .where((option) => option.selected)
        .fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  String _selectedOptionNames() {
    final selected = extraOptions.where((o) => o.selected).map((o) => o.name).toList();
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
    // Bạn có thể tương tự xây dựng đối tượng CartDTO từ product này và gọi cartApiService.addToCart(...)
  }

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

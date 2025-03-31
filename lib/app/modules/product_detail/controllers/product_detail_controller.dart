import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/models/product.dart';
import 'package:ffb_fe_flutter/app/models/extra_option.dart';
import 'package:ffb_fe_flutter/app/service/product_detail_service.dart';
import 'package:ffb_fe_flutter/app/service/cart_api_service.dart';
import '../../../base/base_common.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item.dart';
import '../../../models/cart_item_option.dart';
import '../../../models/discount.dart';

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
  final int parsedUserId = int.tryParse(BaseCommon.instance.userId ?? '') ?? 0;
  final isAddingToCart = false.obs;


  // Getter trả về sản phẩm hiện tại, nếu null thì trả về đối tượng mẫu
  Product get currentProduct => _product.value ??
      Product(
        id: 0,
        name: '',
        manufacturer: '',
        supplier: '',
        quantity: 0,
        category: '',
        // discount: 0.0,
        discount: [
          Discount(
            id: 1,
            amount: 0.12,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 7)),
            status: "ACTIVE",
          ),
        ],
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
    final userId = BaseCommon.instance.userId;
    print("👤 [ProductDetail] Đang đăng nhập với userId: $userId");
    fetchProductData();

    // Các dữ liệu mẫu cho menuProducts, drinkProducts, reviews...
    menuProducts.assignAll([
      Product(
        id: 1,
        name: 'Thực đơn 1',
        manufacturer: '',
        supplier: '',
        quantity: 1,
        category: '',         // Giá trị mặc định
        // discount: 0.12,        // Giá trị mặc định
        discount: [
          Discount(
            id: 1,
            amount: 0.12,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 7)),
            status: "ACTIVE",
          ),
        ],

        image: 'https://images.squarespace-cdn.com/content/v1/53883795e4b016c956b8d243/1551438228969-H0FPV1FO3W5B0QL328AS/chup-anh-thuc-an-1.jpg',
        description: '',      // Giá trị mặc định
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
        // discount: 0.12,
        discount: [
          Discount(
            id: 1,
            amount: 0.12,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 7)),
            status: "ACTIVE",
          ),
        ],

        image: 'https://images.squarespace-cdn.com/content/v1/53883795e4b016c956b8d243/1551438228969-H0FPV1FO3W5B0QL328AS/chup-anh-thuc-an-1.jpg',
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
        // discount: 0.12,
        discount: [
          Discount(
            id: 1,
            amount: 0.12,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 7)),
            status: "ACTIVE",
          ),
        ],

        image: 'https://images.squarespace-cdn.com/content/v1/53883795e4b016c956b8d243/1551438228969-H0FPV1FO3W5B0QL328AS/chup-anh-thuc-an-1.jpg',
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
        // discount: 0.12,
        discount: [
          Discount(
            id: 1,
            amount: 0.12,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: 7)),
            status: "ACTIVE",
          ),
        ],

        image: 'https://images.squarespace-cdn.com/content/v1/53883795e4b016c956b8d243/1551438228969-H0FPV1FO3W5B0QL328AS/chup-anh-thuc-an-1.jpg',
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
      print("❌ Error: Product ID is null. Cannot fetch product data.");
      return;
    }
    final String productId = productIdArg.toString();

    try {
      Product detail = await apiService.getProductDetail(productId);
      _product.value = detail;

      // 🧩 Mapping Extra Options
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

      // ✂️ Rút gọn từ khóa để gọi similar
      final keyword = extractKeyword(detail.name);
      print("🟢 Gọi API tìm similar với keyword: $keyword");
      List<Product> similar = await apiService.getSimilarProducts(keyword);

      print("📦 Similar products loaded: ${similar.length}");
      for (var p in similar) {
        print("🔍 Product: ${p.name}, price: ${p.defaultPrice}, shop: ${p.shop}");
      }

      similarProducts.assignAll(similar);
    } catch (e) {
      print("❌ Error fetching product data: $e");
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
  Future<void> addToCartWithOptions() async {
    try {
      // 🧮 Tính giá
      final double basePrice = currentProduct.defaultPrice;
      final int qty = quantity.value;
      double total = 0.0;

      // ✅ Lấy size đã chọn (typeId = 2)
      final sizeOptions = currentProduct.foodOptions.where((opt) => opt.typeId == 2).toList();
      CartItemOptionDTO? selectedSizeOption;
      if (sizeOptions.isNotEmpty && selectedSizeIndex.value < sizeOptions.length) {
        final size = sizeOptions[selectedSizeIndex.value];
        selectedSizeOption = CartItemOptionDTO(
          optionId: size.id,
          typeId: 2,
          optionName: size.name,
          image: size.image ?? '',
          cartItemId: 0,
          price: size.price,
          totalPrice: size.price * qty,
          quantity: 1,
        );
        total += size.price * qty;
      }

      // ✅ Lấy extra topping (typeId = 1)
      final List<CartItemOptionDTO> extraOptionsList = extraOptions
          .where((opt) => opt.selected)
          .map((opt) => CartItemOptionDTO(
        optionId: int.tryParse(opt.id) ?? 0,
        typeId: 1,
        optionName: opt.name,
        image: opt.imageUrl ?? '',
        cartItemId: 0,
        price: opt.price,
        totalPrice: opt.price * opt.quantity,
        quantity: opt.quantity,
      ))
          .toList();

      total += extraOptionsList.fold(0.0, (sum, e) => sum + e.totalPrice);

      // ✅ Tổng tiền = (base + size) * số lượng + topping
      final double totalPrice = (basePrice * qty) + total;

      // ✅ Gộp tất cả option lại
      if (selectedSizeOption != null) {
        extraOptionsList.insert(0, selectedSizeOption);
      }

      // 🧱 CartItemDTO
      final cartItem = CartItemDTO(
        cartId: 0,
        productId: currentProduct.id,
        productName: currentProduct.name,
        image: currentProduct.image,
        price: basePrice,
        totalPrice: totalPrice,
        quantity: qty,
        cartItemOptionDTOList: extraOptionsList,
      );

      // 🧱 CartDTO
      final cart = CartDTO(
        id: 0,
        userId: parsedUserId,
        shopId: 0,
        shopName: currentProduct.shop,
        price: totalPrice,
        status: "PENDING",
        cartItemDTOList: [cartItem],
      );

      // 📡 Gửi lên backend
      bool success = await cartApiService.addToCart(cart);
      if (success) {
        Get.snackbar("Thành công", "Đã thêm sản phẩm vào giỏ hàng");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Thêm vào giỏ hàng thất bại: $e");
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

  String extractKeyword(String fullName) {
    final words = fullName.trim().split(RegExp(r"\s+"));
    return words.length > 1 ? "${words[0]} ${words[1]}" : words[0];
  }

}

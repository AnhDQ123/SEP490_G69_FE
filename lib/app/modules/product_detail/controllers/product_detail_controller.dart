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
import '../../../models/feedback.dart';
import '../../../routes/app_pages.dart';
import '../../../service/feedback_service.dart';
import '../views/widget/feedback_dialog.dart';

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


  var reviews = <Feedback>[].obs;
  var currentFeedbackPage = 1.obs;
  var canLoadMoreFeedbacks = true.obs;

  final ProductDetailApiService apiService = ProductDetailApiService();
  final CartApiService cartApiService = CartApiService(); // Thêm service giỏ hàng
  final FeedbackService feedbackService = FeedbackService();

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
          discount: [],  // Để trống danh sách discount
          image: '',
          description: '',
          rate: 0.0,
          shop: '',
          defaultPrice: 0.0,
          foodOptions: [],
          shopId: 0
      );

  @override
  void onInit() {
    super.onInit();
    final userId = BaseCommon.instance.userId;
    print("👤 [ProductDetail] Đang đăng nhập với userId: $userId");
    fetchProductData();
    reviews.assignAll([
    ]);
  }

  Future<void> loadNewProduct(dynamic productIdArg) async {
    try {
      _product.value = null;
      quantity.value = 1;
      selectedSizeIndex.value = 0;
      extraOptions.clear();
      similarProducts.clear();
      menuProducts.clear();
      drinkProducts.clear();
      reviews.clear();
      currentFeedbackPage.value = 1;
      canLoadMoreFeedbacks.value = true;

      final productId = productIdArg.toString();
      print("🔄 Loading new Product ID: $productId");

      Product detail = await apiService.getProductDetail(productId);
      _product.value = detail;

      // Load sản phẩm tương tự
      final keyword = extractKeyword(detail.name);
      List<Product> similar = await apiService.getSimilarProducts(keyword);
      similarProducts.assignAll(similar);

      // Load menu và đồ uống
      await fetchMenuProducts();
      await fetchDrinkProducts();

      // Load feedback
      await loadProductFeedbacks();

      print("✅ Load xong sản phẩm mới: ${detail.name}");
    } catch (e) {
      print("❌ Error loading new product: $e");
    }
  }


  void fetchProductData() async {
    _product.value = null;
    quantity.value = 1;
    selectedSizeIndex.value = 0;
    extraOptions.clear();

    final productIdArg = Get.arguments;
    print("🟡 Nhận được Product ID: $productIdArg");

    if (productIdArg == null) {
      print("❌ Error: Product ID is null. Cannot fetch product data.");
      return;
    }
    final String productId = productIdArg.toString();

    try {
      Product detail = await apiService.getProductDetail(productId);
      _product.value = detail;
      print("Fetched shopId: ${_product.value?.shopId}");
      print("📦 Dữ liệu sản phẩm từ API: ${detail.toJson()}");
      _product.value = detail;

      // 🧩 Mapping Extra Options
      extraOptions.assignAll(
        detail.foodOptions
            ?.where((option) => option.typeId == 1) // Thêm ? để xử lý null
            ?.map((e) => ExtraOption(
          id: e.id.toString(),
          name: e.name ?? 'Không có tên',
          price: e.price ?? 0,
          imageUrl: e.image,
          unit: "suất",
          selected: false,
          quantity: 1,
        ))
            ?.toList() ?? [], // Nếu null thì gán list rỗng
      );

      // ✂️ Rút gọn từ khóa để gọi similar
      final keyword = extractKeyword(detail.name);
      print("🟢 Gọi API tìm similar với keyword: $keyword");
      List<Product> similar = await apiService.getSimilarProducts(keyword);

      print("📦 Similar products loaded: ${similar.length}");
      for (var p in similar) {
        print("🔍 Product ID: ${p.id}, Name: ${p.name}, Price: ${p.defaultPrice}, Shop: ${p.shop}");      }

      similarProducts.assignAll(similar);
      await fetchMenuProducts(); // ← Thêm dòng này để gọi API lấy thực đơn từ shop
      await fetchMenuProducts();


    } catch (e) {
      print("❌ Error fetching product data: $e");
    }
    await loadProductFeedbacks();

  }

  Future<void> fetchMenuProducts() async {
    try {
      final shopId = _product.value?.shopId;
      if (shopId == null || shopId == 0) return;

      final products = await apiService.getProductsByShop(shopId.toString());
      menuProducts.assignAll(products);
    } catch (e) {
      print("❌ Lỗi khi fetch menu thực đơn: $e");
    }
  }

  Future<void> fetchDrinkProducts() async {
    try {
      final shopId = _product.value?.shopId;
      if (shopId == null || shopId == 0) return;

      final drinks = await apiService.getDrinksByShop(shopId.toString());
      drinkProducts.assignAll(drinks);
    } catch (e) {
      print("❌ Lỗi khi fetch đồ uống của shop: $e");
    }
  }

// Thêm hàm mới
  Future<void> loadProductFeedbacks() async {
    try {
      if (!canLoadMoreFeedbacks.value) return;

      final feedbacks = await feedbackService.getProductFeedbacks(
        currentProduct.id,
        page: currentFeedbackPage.value,
      );

      if (feedbacks.isEmpty) {
        canLoadMoreFeedbacks.value = false;
      } else {
        reviews.addAll(feedbacks);
        currentFeedbackPage.value++;
      }
    } catch (e) {
      print("Error loading feedbacks: $e");
    }
  }

  // Trong ProductDetailController
  Future<bool> submitFeedback({
    required double rating,
    String? comment,
    List<String>? imageUrls,
  }) async {
    try {
      final userId = int.tryParse(BaseCommon.instance.userId ?? '');
      if (userId == null) {
        Get.snackbar("Lỗi", "Vui lòng đăng nhập để đánh giá");
        return false;
      }

      final success = await feedbackService.createFeedback(
        userId: userId,
        productId: currentProduct.id,
        rate: rating,
        content: comment,
        imageUrls: imageUrls,
      );

      if (success) {
        // Làm mới danh sách feedback
        reviews.clear();
        currentFeedbackPage.value = 1;
        canLoadMoreFeedbacks.value = true;
        await loadProductFeedbacks();
        return true;
      }
      return false;
    } catch (e) {
      print('Error submitting feedback: $e');
      rethrow;
    }
  }

  void showFeedbackDialog() {
    Get.dialog(
      FeedbackDialog(productId: currentProduct.id),
      barrierDismissible: false,
    );
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

    // Lấy danh sách size options (typeId = 2)
    final sizeOptions = _product.value!.foodOptions.where((opt) => opt.typeId == 2).toList();

    // Nếu không có size nào, trả về 0
    if (sizeOptions.isEmpty) return 0;

    // Lấy giá của size được chọn (mặc định là size đầu tiên nếu chưa chọn)
    double sizePrice = sizeOptions[selectedSizeIndex.value].price;

    // Tính discount (nếu có)
    final activeDiscount = _product.value!.discount.firstWhere(
          (discount) => discount.status == 'ACTIVE',
      orElse: () => Discount(
        id: 0,
        amount: 0.0,
        startDate: '',
        endDate: '',
        status: 'INACTIVE',
      ),
    );

    // Áp dụng discount
    double discountValue = activeDiscount.amount < 1 ? activeDiscount.amount * 100 : activeDiscount.amount;
    sizePrice = sizePrice - (sizePrice * (discountValue / 100));

    // Thêm giá topping nếu có
    return sizePrice + totalExtraPrice;
  }

  double get originalPrice {
    if (_product.value == null) return 0;

    final sizeOptions = _product.value!.foodOptions.where((opt) => opt.typeId == 2).toList();
    if (sizeOptions.isEmpty) return 0;

    return sizeOptions[selectedSizeIndex.value].price;
  }



  void selectSize(int index) {
    selectedSizeIndex.value = index;
  }

  bool get hasSelectedSize {
    return currentProduct.foodOptions.any((opt) => opt.typeId == 2);
  }
  // Cập nhật hàm addToCartWithOptions để gửi discount và tính giá
  Future<void> addToCartWithOptions() async {
    try {
      // Kiểm tra nếu có size nhưng chưa chọn size
      if (currentProduct.foodOptions.any((opt) => opt.typeId == 2) &&
          selectedSizeIndex.value < 0) {
        Get.snackbar("Thông báo", "Vui lòng chọn size trước khi thêm vào giỏ hàng");
        return;
      }

      final int qty = quantity.value;

      // Lấy size được chọn (typeId = 2)
      final sizeOptions = currentProduct.foodOptions.where((opt) => opt.typeId == 2).toList();
      if (sizeOptions.isEmpty) {
        Get.snackbar("Lỗi", "Sản phẩm không có size");
        return;
      }

      final selectedSize = sizeOptions[selectedSizeIndex.value];
      double sizePrice = selectedSize.price;

      // Tính discount
      final activeDiscount = _product.value!.discount.firstWhere(
            (discount) => discount.status == 'ACTIVE',
        orElse: () => Discount(
          id: 0,
          amount: 0.0,
          startDate: '',
          endDate: '',
          status: 'INACTIVE',
        ),
      );

      // Áp dụng discount cho giá size
      double discountValue = activeDiscount.amount < 1 ? activeDiscount.amount * 100 : activeDiscount.amount;
      sizePrice = sizePrice - (sizePrice * (discountValue / 100));

      // Tạo option cho size
      CartItemOptionDTO selectedSizeOption = CartItemOptionDTO(
        id: 0,
        optionId: selectedSize.id,
        typeId: 2,
        optionName: selectedSize.name,
        image: selectedSize.image as String ?? '',
        cartItemId: 0,
        price: selectedSize.price, // Giá gốc của size (trước khi giảm giá)
        totalPrice: selectedSize.price * qty, // Tổng giá size (trước giảm giá)
        quantity: 1,
      );

      // Tính topping
      final List<CartItemOptionDTO> extraOptionsList = extraOptions
          .where((opt) => opt.selected)
          .map((opt) => CartItemOptionDTO(
        id: 0,
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

      // Tính tổng giá: (giá size sau discount + topping) * số lượng
      double totalExtraPrice = extraOptionsList.fold(0.0, (sum, e) => sum + e.totalPrice);
      double totalPrice = (sizePrice * qty) + totalExtraPrice;

      // Gộp các option
      final List<CartItemOptionDTO> allOptions = [selectedSizeOption];
      allOptions.addAll(extraOptionsList);

      print('🟢 [1.USER SELECTED OPTIONS] Product: ${currentProduct.name} (ID:${currentProduct.id})');
      print('   → Selected Size: ${selectedSize.name} (ID:${selectedSize.id})');
      extraOptions.where((opt) => opt.selected).forEach((opt) {
        print('   → Extra Option: ${opt.name} (ID:${opt.id})');
      });
      // Tạo CartItemDTO
      final cartItem = CartItemDTO(
        cartId: 0,
        productId: currentProduct.id,
        productName: currentProduct.name,
        image: currentProduct.image,
        price: sizePrice, // Giá sau discount
        totalPrice: totalPrice,
        quantity: qty,
        cartItemOptionDTOList: allOptions,
      );

      // Tạo CartDTO
      final cart = CartDTO(
        id: 0,
        userId: parsedUserId,
        shopId: currentProduct.shopId,
        shopName: currentProduct.shop,
        price: totalPrice,
        status: "PENDING",
        cartItemDTOList: [cartItem],
      );

      // Gửi lên backend
      bool success = await cartApiService.addToCart(cart);
      if (success) {
        Get.snackbar("Thành công", "Đã thêm sản phẩm vào giỏ hàng");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Thêm vào giỏ hàng thất bại: $e");
      print("Lỗi khi thêm vào giỏ hàng: $e");
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
    // Lấy thông tin sản phẩm hiện tại
    final product = currentProduct;

    Get.toNamed(
      Routes.SEND_REPORT,
      arguments: {
        'typeId': 6,
        'itemId': product.id,
        'itemName': product.name,
      },
    );
  }
  void goToShop() {
    final product = currentProduct;
    print("🛍️ Đang chuyển sang trang cửa hàng. ShopID: ${product.shopId}, Tên cửa hàng: ${product.shop}");

    if (product.shopId != null && product.shopId > 0) {
      Get.toNamed(
        Routes.USER_VIEW_SHOP_DETAIL,
        arguments: {
          'shopId': product.shopId,
          'shopName': product.shop,
        },
      );
    } else {
      print("⚠️ Không có thông tin cửa hàng hợp lệ");
      Get.snackbar("Thông báo", "Không có thông tin cửa hàng");
    }
  }

  String extractKeyword(String fullName) {
    final words = fullName.trim().split(RegExp(r"\s+"));
    return words.length > 1 ? "${words[0]} ${words[1]}" : words[0];
  }

  double get baseCurrentPrice {
    if (_product.value == null) return 0;

    final sizeOptions = _product.value!.foodOptions.where((opt) => opt.typeId == 2).toList();
    if (sizeOptions.isEmpty) return 0;

    double sizePrice = sizeOptions[selectedSizeIndex.value].price;

    final activeDiscount = _product.value!.discount.firstWhere(
          (discount) => discount.status == 'ACTIVE',
      orElse: () => Discount(
        id: 0,
        amount: 0.0,
        startDate: '',
        endDate: '',
        status: 'INACTIVE',
      ),
    );

    double discountValue = activeDiscount.amount < 1 ? activeDiscount.amount * 100 : activeDiscount.amount;
    return sizePrice - (sizePrice * (discountValue / 100));
  }
}

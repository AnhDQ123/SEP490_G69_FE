import 'package:get/get.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item.dart';
import '../../../models/cart_item_option.dart';
import '../../../models/product.dart';
import '../../../routes/app_pages.dart';
import '../../../services/cart_service.dart';

class CartController extends GetxController {
  var carts = <Cart>[].obs;
  var isLoading = true.obs;
  final CartService cartService = CartService();
  var selectedItems = <int, List<int>>{}.obs;

  /// **Lưu danh sách Size của sản phẩm từ API**
  var productOptions = <int, List<CartItemOption>>{}.obs;
  var isLoadingOptions = false.obs;

  /// **Lấy danh sách Size từ API và cập nhật giá**
  Future<void> fetchProductOptions(int productId) async {
    try {
      isLoadingOptions(true);
      Product product = await cartService.fetchProductDetails(productId);

      print("📡 API Response | Sản phẩm: ${product.name}");
      print("📡 API Food Options: ${product.foodOptions.map((e) => e.name).toList()}");

      // 🔹 Lọc Size (typeId == 2)
      List<CartItemOption> sizes = product.foodOptions
          .where((opt) => opt.typeId == 2)
          .map((opt) => CartItemOption(
        optionId: opt.id,
        typeId: opt.typeId,
        optionName: opt.name,
        price: opt.price,
        totalPrice: opt.price,
        quantity: 1,
        cartItemId: 0,
      ))
          .toList();

      // 🔹 Lọc Food Options (typeId == 3)
      List<CartItemOption> foodOptions = product.foodOptions
          .where((opt) => opt.typeId == 3)
          .map((opt) => CartItemOption(
        optionId: opt.id,
        typeId: opt.typeId,
        optionName: opt.name,
        price: opt.price,
        totalPrice: opt.price,
        quantity: 1,
        cartItemId: 0,
      ))
          .toList();

      print("✅ DEBUG | Sizes [$productId]: ${sizes.map((e) => e.optionName).toList()}");
      print("✅ DEBUG | Food Options [$productId]: ${foodOptions.map((e) => e.optionName).toList()}");

      // 🔹 Lưu vào productOptions
      productOptions[productId] = [...sizes, ...foodOptions];

      carts.refresh(); // Cập nhật UI

    } catch (e) {
      print('❌ Lỗi khi lấy option sản phẩm: $e');
    } finally {
      isLoadingOptions(false);
    }
  }


  /// **Thay đổi Size của sản phẩm trong giỏ hàng**
  void updateSize(int shopId, int productId, CartItemOption newSize) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);

    // 🔹 Xóa size cũ và cập nhật size mới
    item.cartItemOptionDTOList.removeWhere((opt) => opt.typeId == 2);
    item.cartItemOptionDTOList.add(newSize);

    // 🔹 Cập nhật lại giá sản phẩm theo size mới (tránh lỗi LateInitializationError)
    item.totalPrice = (newSize.price) * item.quantity;
    carts.refresh();
  }

  /// **Thay đổi số lượng sản phẩm**
  void updateProductQuantity(int shopId, int productId, int quantity) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);

    item.quantity = quantity;

    // 🔹 Cập nhật lại giá theo số lượng và Size
    var selectedSize = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2);
    double sizePrice = selectedSize?.price ?? 0;
    item.totalPrice = sizePrice * quantity;

    carts.refresh();
  }

  void updateOptionQuantity(int shopId, int productId, int optionId, int newQuantity) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((p) => p.productId == productId);
    var option = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.optionId == optionId);

    if (option != null && newQuantity >= 0) {
      option.quantity = newQuantity;
      item.totalPrice = _calculateTotalPrice(item);
    }

    carts.refresh();
  }

  void addFoodOption(int shopId, int productId, CartItemOption option) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((p) => p.productId == productId);

    // Kiểm tra xem option đã có trong giỏ hàng chưa
    var existingOption = item.cartItemOptionDTOList.firstWhereOrNull(
            (opt) => opt.optionId == option.optionId);

    if (existingOption == null) {
      // Nếu chưa có, thêm mới
      item.cartItemOptionDTOList.add(CartItemOption(
        optionId: option.optionId,
        typeId: option.typeId,
        optionName: option.optionName,
        price: option.price,
        totalPrice: option.price,
        quantity: 1,
        cartItemId: item.id,
      ));
    } else {
      // Nếu đã có, tăng số lượng lên 1
      existingOption.quantity += 1;
      existingOption.totalPrice = existingOption.price * existingOption.quantity;
    }

    item.totalPrice = _calculateTotalPrice(item);
    carts.refresh();
  }

  // ✅ Hàm tính lại tổng giá khi cập nhật số lượng Option
  double _calculateTotalPrice(CartItem item) {
    double sizePrice = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2)?.price ?? 0;
    double foodOptionsPrice = item.cartItemOptionDTOList
        .where((opt) => opt.typeId == 3)
        .fold(0.0, (sum, opt) => sum + (opt.price * opt.quantity));

    return (sizePrice + foodOptionsPrice) * item.quantity;
  }


  /// **Lấy tổng tiền của giỏ hàng (bao gồm Size & Food Options)**
  double getTotalAmount() {
    double total = 0;
    for (var shop in carts) {
      for (var item in shop.cartItemDTOList) {
        if (selectedItems[shop.shopId]?.contains(item.productId) ?? false) {
          // 🔹 Lấy giá từ Size đã chọn
          var selectedSize = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2);
          double sizePrice = selectedSize?.price ?? 0;

          // 🔹 Lấy tổng giá từ Food Options đã chọn
          double foodOptionsPrice = item.cartItemOptionDTOList
              .where((opt) => opt.typeId == 3) // Chỉ lấy các lựa chọn Food Option
              .fold(0.0, (sum, opt) => sum + (opt.price * opt.quantity));

          // ✅ Tính toán chính xác:
          // Giá sản phẩm = (Giá Size * Số lượng sản phẩm) + Tổng giá Food Options
          total += (sizePrice * item.quantity) + foodOptionsPrice;
        }
      }
    }
    return total;
  }

  /// **Định dạng tiền VNĐ**
  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}đ';
  }

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  /// **Lấy giỏ hàng từ API**
  void fetchCart() async {
    try {
      isLoading(true);
      var cartData = await cartService.fetchCartList(1);
      if (cartData != null) {
        carts.assignAll(cartData);

        for (var shop in carts) {
          for (var item in shop.cartItemDTOList) {
            await fetchProductOptions(item.productId); // ✅ Lấy danh sách Size trước

            // ✅ Chỉ lấy giá từ `cartItemOptionDTOList`
            CartItemOption? selectedSize = item.cartItemOptionDTOList
                .firstWhereOrNull((opt) => opt.typeId == 2);

            print("🔍 DEBUG | Sản phẩm: ${item.productName}, Size: ${selectedSize?.optionName}, Giá: ${selectedSize?.price}");

            if (selectedSize != null) {
              item.totalPrice = (selectedSize.price) * item.quantity;
            } else {
              item.totalPrice = 0; // Nếu không có size, giá mặc định = 0
            }
          }
        }
      }
    } catch (e) {
      print('❌ Lỗi trong CartController: $e');
    } finally {
      isLoading(false);
    }
  }


  /// **Chọn tất cả sản phẩm**
  void toggleSelectAll(bool isSelected) {
    for (var shop in carts) {
      selectedItems[shop.shopId] = isSelected
          ? shop.cartItemDTOList.map((item) => item.productId).toList()
          : [];
    }
    selectedItems.refresh();
  }

  /// **Kiểm tra nếu tất cả sản phẩm đều được chọn**
  bool isAllSelected() {
    for (var shop in carts) {
      if (!isShopSelected(shop.shopId)) {
        return false;
      }
    }
    return true;
  }


  /// **Chọn cửa hàng**
  bool isShopSelected(int shopId) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    return selectedItems[shopId]?.length == shop.cartItemDTOList.length;
  }

  void toggleShopSelection(int shopId, bool isSelected) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    selectedItems[shopId] = isSelected
        ? shop.cartItemDTOList.map((item) => item.productId).toList()
        : [];
    selectedItems.refresh();
  }

  /// **Chọn từng sản phẩm**
  void toggleItemSelection(int shopId, int productId, bool isSelected) {
    if (!selectedItems.containsKey(shopId)) {
      selectedItems[shopId] = [];
    }
    if (isSelected) {
      if (!selectedItems[shopId]!.contains(productId)) {
        selectedItems[shopId]!.add(productId);
      }
    } else {
      selectedItems[shopId]!.remove(productId);
    }
    selectedItems.refresh();
  }

  void removeShop(int shopId) {
    carts.removeWhere((shop) => shop.shopId == shopId);
    carts.refresh();
  }

  void removeItem(int shopId, int productId) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    shop.cartItemDTOList.removeWhere((item) => item.productId == productId);

    if (shop.cartItemDTOList.isEmpty) {
      carts.removeWhere((s) => s.shopId == shopId);
    }

    carts.refresh();
  }

  void proceedToCheckout() {
    bool hasSelectedProduct = selectedItems.values.any((products) => products.isNotEmpty);

    if (!hasSelectedProduct) {
      Get.snackbar("Thông báo", "Vui lòng chọn ít nhất một sản phẩm để thanh toán",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.toNamed(Routes.CHECKOUT, arguments: carts.where((shop) => selectedItems[shop.shopId]?.isNotEmpty ?? false).toList());
  }

}

import 'package:ffb_fe_flutter/app/service/cart_api_service.dart';
import 'package:ffb_fe_flutter/app/service/order_service.dart';
import 'package:get/get.dart';
import '../../../base/base_common.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item.dart';
import '../../../models/cart_item_option.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../../routes/app_pages.dart';
import '../../../service/notification_service.dart';
import '../../../service/product_detail_service.dart';

class CartController extends GetxController {
  var carts = <CartDTO>[].obs;
  var isLoading = true.obs;
  final CartApiService cartService = CartApiService();
  final ProductDetailApiService productDetailService =
  ProductDetailApiService();
  var selectedItems = <int, List<int>>{}.obs;
  var productOptions = <int, List<CartItemOptionDTO>>{}.obs;
  var isLoadingOptions = false.obs;
  var selectedShopId = RxnInt(); // Nullable int


  Future<void> fetchProductOptions(int productId) async {
    try {
      isLoadingOptions(true);
      Product product =
      await productDetailService.getProductDetail(productId.toString());
      print("📥 [fetchProductOptions] Đang xử lý productId: $productId");
      print("   → Có ${product.foodOptions.length} foodOptions");

      for (var opt in product.foodOptions) {
        print("   - ${opt.name} | typeId: ${opt.typeId} | price: ${opt.price}");
      }

      if (product.foodOptions == null) {
        print("⚠️ Không có foodOptions cho productId: $productId");
        return;
      }

      // Lọc các size (typeId == 2)
      List<CartItemOptionDTO> sizes = product.foodOptions
          .where((opt) => opt.typeId == 2) // Lấy các size
          .map((opt) => CartItemOptionDTO(
        id: 0,
        optionId: opt.id,
        typeId: opt.typeId ?? 0,
        optionName: opt.name,
        image: opt.image ?? '',
        price: opt.price ?? 0.0,
        totalPrice: opt.price ?? 0.0,
        quantity: 1,
        cartItemId: 0,
      ))
          .toList();

      // Lọc các topping (typeId == 1)
      List<CartItemOptionDTO> toppings = product.foodOptions
          .where((opt) => opt.typeId == 1) // Lấy các topping
          .map((opt) => CartItemOptionDTO(
        id: 0,
        optionId: opt.id,
        typeId: opt.typeId ?? 0,
        optionName: opt.name,
        image: opt.image ?? '',
        price: opt.price ?? 0.0,
        totalPrice: opt.price ?? 0.0,
        quantity: 1,
        cartItemId: 0,
      ))
          .toList();

      // Cập nhật lại các tùy chọn size và topping cho sản phẩm này
      productOptions[productId] = {...sizes, ...toppings}.toList();
      carts.refresh();
    } catch (e) {
      print('❌ Lỗi khi lấy các tùy chọn sản phẩm $productId: $e');
    } finally {
      isLoadingOptions(false);
    }
  }

  Future<void> updateSize(
      int shopId, int cartItemOptionId, int newSizeId) async {
    try {
      var shop = carts.firstWhereOrNull((s) => s.shopId == shopId);
      var item = shop?.cartItemDTOList.firstWhereOrNull((i) =>
          i.cartItemOptionDTOList.any((opt) =>
          opt.id ==
              cartItemOptionId)); // Dùng cartItemOptionId để tìm đúng tùy chọn
      if (item != null) {
        // Tìm tùy chọn size trong cartItemOptionDTOList của item
        var option = item.cartItemOptionDTOList
            .firstWhereOrNull((opt) => opt.id == cartItemOptionId);

        if (option != null) {
          await cartService.changeSize(cartItemOptionId, newSizeId);
          await fetchCart();
        }
      }
    } catch (e) {
      // Log lỗi nếu có sự cố xảy ra
      print("❌ Lỗi khi thay đổi size: $e");
    }
  }

  // Tăng số lượng
  void increaseQuantity(int shopId, int productId, int cartItemOptionId) async {
    var shop = carts.firstWhereOrNull((s) => s.shopId == shopId);
    var item =
    shop?.cartItemDTOList.firstWhereOrNull((i) => i.productId == productId);

    if (item != null) {
      // Gọi API để tăng số lượng của sản phẩm trong DB
      await cartService.increaseOptionQuantity(cartItemOptionId);

      // Sau khi cập nhật số lượng trong DB, gọi lại fetchCart để lấy giỏ hàng mới từ server
      await fetchCart(); // Fetch lại giỏ hàng
    }
  }

  void decreaseQuantity(int shopId, int productId, int cartItemOptionId) async {
    var shop = carts.firstWhereOrNull((s) => s.shopId == shopId);
    var item =
    shop?.cartItemDTOList.firstWhereOrNull((i) => i.productId == productId);

    if (item != null) {
      // Gọi API để tăng số lượng của sản phẩm trong DB
      await cartService.decreaseOptionQuantity(cartItemOptionId);

      // Sau khi cập nhật số lượng trong DB, gọi lại fetchCart để lấy giỏ hàng mới từ server
      await fetchCart(); // Fetch lại giỏ hàng
    }
  }

  Future<void> addFoodOptionToCart(
      int shopId, int productId, int foodOptionId) async {
    try {
      // Lấy sản phẩm từ giỏ hàng dựa trên shopId và productId
      var shop = carts.firstWhereOrNull((s) => s.shopId == shopId);
      var item = shop?.cartItemDTOList
          .firstWhereOrNull((i) => i.productId == productId);

      if (item != null) {
        // Gọi API để thêm tùy chọn vào sản phẩm
        await cartService.addOptionToItem(item.id ?? 0, foodOptionId);

        // Sau khi thêm tùy chọn thành công, làm mới giỏ hàng hoặc cập nhật lại số lượng option
        await fetchCart();
      }
    } catch (e) {
      print('❌ Lỗi khi thêm option vào sản phẩm: $e');
    }
  }

  double _calculateTotalPrice(CartItemDTO item) {
    double sizePrice = item.cartItemOptionDTOList
        .firstWhereOrNull((opt) => opt.typeId == 2)
        ?.price ??
        0;
    double foodOptionsPrice = item.cartItemOptionDTOList
        .where((opt) => opt.typeId == 1)
        .fold(0.0, (sum, opt) => sum + (opt.price * opt.quantity));

    double total = sizePrice * item.quantity.value;

    print("🧾 DEBUG [_calculateTotalPrice]");
    print("→ Sản phẩm: ${item.productName}");
    print(
        "→ Size price x quantity: ${sizePrice} x ${item.quantity.value} = ${sizePrice * item.quantity.value}");
    print("→ Food Options total: $foodOptionsPrice");
    print("→ Total = $total");

    return total;
  }

  double getTotalAmount() {
    double total = 0;

    for (var shop in carts) {
      for (var item in shop.cartItemDTOList) {
        if (selectedItems[shop.shopId]?.contains(item.productId) ?? false) {
          // 👉 Lấy tổng topping
          double toppingPrice = item.cartItemOptionDTOList
              .where((opt) => opt.typeId == 1)
              .fold(0.0, (sum, opt) => sum + (opt.price * opt.quantity));

          // 👉 Tổng = totalPrice từ item (size * quantity) + topping
          total += item.totalPrice + toppingPrice;
        }
      }
    }

    return total;
  }

  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}'
        'đ';
  }

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  Future<void> fetchCart() async {
    try {
      isLoading(true);
      final userId = int.tryParse(BaseCommon.instance.userId ?? '') ?? 0;
      print("📥 Đang fetch cart cho userId: $userId");

      var cartData = await cartService.getCartByOwner(userId);
      print('🔵 [5.FETCHED CART DATA]');

      // Duyệt qua từng shop
      cartData.forEach((shop) {
        print('   Shop: ${shop.shopName} (ID:${shop.shopId})');
        shop.cartItemDTOList.forEach((item) {
          print('     Product: ${item.productName} (ID:${item.productId})');
          item.cartItemOptionDTOList.forEach((opt) {
            print(
                '       → CartItemOptionID: ${opt.id} |OptionID: ${opt.optionId} | Name: ${opt.optionName} | Quantity: ${opt.quantity}');

            // Cập nhật lại số lượng của từng option nếu cần
            opt.quantity =
                opt.quantity ?? 1; // Đảm bảo quantity luôn có giá trị
          });
        });
      });
      print("✅ Nhận được ${cartData.length} cart(s)");

      carts.assignAll(cartData);
      carts.refresh();

      // Kiểm tra và thông báo nếu có sản phẩm trong giỏ
      int totalItems = 0;
      for (var shop in cartData) {
        totalItems += shop.cartItemDTOList.length;
      }
      if (totalItems > 0) {
        await NotificationService.showCartReminderNotification(totalItems);
      }

      for (var shop in carts) {
        for (var item in shop.cartItemDTOList) {
          try {
            print("🔍 Xử lý productId: ${item.productId}");
            await fetchProductOptions(item.productId);

            CartItemOptionDTO? selectedSize = item.cartItemOptionDTOList
                .firstWhereOrNull((opt) => opt.typeId == 2);

            // 🛠️ Nếu chưa có size, tự gán size đầu tiên từ productOptions
            if (selectedSize == null) {
              final options = productOptions[item.productId] ?? [];
              final defaultSize =
              options.firstWhereOrNull((opt) => opt.typeId == 2);

              if (defaultSize != null) {
                // Tạo bản sao với cartItemId hiện tại
                final newSize = CartItemOptionDTO(
                  id: 0,
                  optionId: defaultSize.optionId,
                  typeId: defaultSize.typeId,
                  optionName: defaultSize.optionName,
                  image: defaultSize.image,
                  price: defaultSize.price,
                  totalPrice: defaultSize.price,
                  quantity: 1,
                  cartItemId: item.id ?? 0,
                );
                item.cartItemOptionDTOList.add(newSize);
                print(
                    "🛠️ Gán size mặc định cho '${item.productName}': ${newSize.optionName}");
                selectedSize = newSize;
              } else {
                print(
                    "❗ [LỖI] Không tìm thấy size khả dụng cho sản phẩm: ${item.productName}");
              }
            }

            // item.totalPrice = selectedSize != null
            //     ? selectedSize.price * item.quantity.value
            //     : 0;
          } catch (e, st) {
            print("❌ [ERROR] Lỗi trong xử lý item ${item.productId}: $e");
            print("📛 $st");
          }
        }
      }
    } catch (e, st) {
      print('❌ [ERROR] Lỗi trong fetchCart(): $e');
      print('📛 $st');
    } finally {
      isLoading(false);
      print("✅ Đã kết thúc fetchCart(), đóng loading");
    }
  }

  void toggleSelectAll(bool isSelected) {
    if (selectedShopId.value == null) return;

    final shopId = selectedShopId.value!;
    var shop = carts.firstWhereOrNull((s) => s.shopId == shopId);

    if (shop != null) {
      selectedItems[shopId] = isSelected
          ? shop.cartItemDTOList.map((item) => item.productId).toList()
          : [];
    }

    selectedItems.refresh();
  }



  bool isAllSelected() {
    for (var shop in carts) {
      if (!isShopSelected(shop.shopId)) {
        return false;
      }
    }
    return true;
  }

  bool isShopSelected(int shopId) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    return selectedItems[shopId]?.length == shop.cartItemDTOList.length;
  }

  void toggleShopSelection(int shopId, bool isSelected) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);

    if (isSelected) {
      // Nếu chọn shop, gán selectedShopId = shopId
      selectedShopId.value = shopId;
      selectedItems.clear(); // Bỏ chọn tất cả sản phẩm ở các shop khác
      selectedItems[shopId] = shop.cartItemDTOList.map((item) => item.productId).toList();
    } else {
      // Nếu bỏ chọn, clear selectedShopId
      selectedShopId.value = null;
      selectedItems[shopId] = [];
    }

    selectedItems.refresh();
  }


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

    // Log sản phẩm đã chọn hoặc bỏ chọn
    print(
        "🔄 Đã thay đổi trạng thái sản phẩm $productId trong cửa hàng $shopId: ${isSelected ? 'Chọn' : 'Bỏ chọn'}");
    print(
        "📋 Sản phẩm đã chọn trong cửa hàng $shopId: ${selectedItems[shopId]}");
  }

  void removeShop(int shopId) {
    carts.removeWhere((shop) => shop.shopId == shopId);
    carts.refresh();
  }

  // void removeItem(int shopId, int productId) {
  //   var shop = carts.firstWhere((s) => s.shopId == shopId);
  //   shop.cartItemDTOList.removeWhere((item) => item.productId == productId);
  //   if (shop.cartItemDTOList.isEmpty) {
  //     carts.removeWhere((s) => s.shopId == shopId);
  //   }
  //   carts.refresh();
  // }

  void removeItem(int shopId, int productId) async {
    try {
      var shop = carts.firstWhere((s) => s.shopId == shopId);
      final cartId = shop.id ?? 0;

      // Gọi API để xóa sản phẩm
      await cartService.deleteItemFromCart(cartId, productId);

      // Xóa sản phẩm khỏi danh sách local
      shop.cartItemDTOList.removeWhere((item) => item.productId == productId);

      if (shop.cartItemDTOList.isEmpty) {
        // Xóa shop khỏi carts nếu không còn sản phẩm
        carts.removeWhere((s) => s.shopId == shopId);

        // Xóa dữ liệu chọn liên quan tới shop
        selectedItems.remove(shopId);
        if (selectedShopId.value == shopId) {
          selectedShopId.value = null;
        }
      }

      carts.refresh();
      selectedItems.refresh();
    } catch (e) {
      print("❌ Lỗi khi xóa sản phẩm: $e");
    }
  }



  // void proceedToCheckout() {
  //   bool hasSelectedProduct = selectedItems.values.any((products) => products.isNotEmpty);
  //   if (!hasSelectedProduct) {
  //     Get.snackbar("Thông báo", "Vui lòng chọn ít nhất một sản phẩm để thanh toán", snackPosition: SnackPosition.BOTTOM);
  //     return;
  //   }
  //   Get.toNamed(Routes.CHECK_OUT,
  //       arguments: carts.where((shop) => selectedItems[shop.shopId]?.isNotEmpty ?? false).toList());
  // }

  Future<void> proceedToCheckout() async {
    bool hasSelectedProduct = selectedItems.values.any((products) => products.isNotEmpty);

    print("🔥 Debugging Proceed to Checkout:");
    print("Selected Items: $selectedItems");

    if (!hasSelectedProduct) {
      Get.snackbar("Thông báo", "Vui lòng chọn ít nhất một sản phẩm để thanh toán",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Lọc danh sách giỏ hàng đã chọn và chỉ giữ lại các sản phẩm được chọn trong mỗi cửa hàng
    List<CartDTO> filteredSelectedCarts = [];

    for (var shop in carts) {
      if (selectedItems[shop.shopId]?.isNotEmpty ?? false) {
        List<CartItemDTO> selectedItemsInShop = shop.cartItemDTOList
            .where((item) => selectedItems[shop.shopId]!.contains(item.productId))
            .toList();

        if (selectedItemsInShop.isNotEmpty) {
          filteredSelectedCarts.add(CartDTO(
            id: shop.id,
            userId: shop.userId,
            shopId: shop.shopId,
            shopName: shop.shopName,
            price: shop.price,
            status: shop.status,
            discountPrice: shop.discountPrice,
            cartItemDTOList: selectedItemsInShop,
          ));
        }
      }
    }

    if (filteredSelectedCarts.isEmpty) {
      Get.snackbar("Thông báo", "Không có sản phẩm được chọn",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    filteredSelectedCarts.forEach((shop) {
      print("Cửa hàng: ${shop.shopName} (ID: ${shop.shopId})");
      shop.cartItemDTOList.forEach((item) {
        print("  - Sản phẩm đã chọn: ${item.productName} (ID: ${item.productId})");
      });
    });

    try {
      // 🧾 Tạo Order từ danh sách giỏ hàng đã lọc
      Order newOrder = filteredSelectedCarts
          .map((cart) => cart.toOrder(
        shipMethodId: 1,
        paymentMethodId: 1,
        address: '',
      ))
          .first;

      print("📦 Đang gửi Order: ${newOrder.toJson()}");
      final createdOrders = await OrderService().createOrder(newOrder);

      if (createdOrders.isNotEmpty) {
        final createdOrder = createdOrders.first;
        for (var shop in filteredSelectedCarts) {
          final cartId = shop.id ?? 0;
          for (var item in shop.cartItemDTOList) {
            await cartService.deleteItemFromCart(cartId, item.productId);
          }
        }

        await fetchCart();

        // Sau khi checkout thành công và xóa item đã mua
        // selectedItems.clear();
        // selectedShopId.value = null;

        Get.toNamed(Routes.CHECK_OUT, arguments: createdOrder);
      } else {
        Get.snackbar("Lỗi", "Không tạo được đơn hàng");
      }
    } catch (e) {
      print("❌ Lỗi trong việc tạo đơn hàng: $e");
      Get.snackbar("Lỗi", "Không thể tạo đơn hàng, vui lòng thử lại",
          snackPosition: SnackPosition.BOTTOM);
    }
  }



  void logFoodOptionIdsInSelectedCart() {
    int totalFoodOptionCount = 0;
    print("=== Thông tin Food Option IDs của các sản phẩm được chọn ===");

    // Duyệt qua từng cửa hàng trong carts
    for (var shop in carts) {
      // Kiểm tra xem cửa hàng có sản phẩm được chọn không
      if (selectedItems.containsKey(shop.shopId) &&
          selectedItems[shop.shopId]!.isNotEmpty) {
        print("Shop ID: ${shop.shopId}");
        // Duyệt qua từng sản phẩm trong cửa hàng
        for (var item in shop.cartItemDTOList) {
          if (selectedItems[shop.shopId]!.contains(item.productId)) {
            print("  Product: ${item.productName} (ID: ${item.productId})");
            // Duyệt qua từng food option của sản phẩm
            for (var option in item.cartItemOptionDTOList) {
              print(
                  "    - Food Option ID: ${option.optionId}, Name: ${option.optionName}");
              totalFoodOptionCount++;
            }
          }
        }
      }
    }
    print("Tổng số Food Option IDs truyền: $totalFoodOptionCount");
  }
}
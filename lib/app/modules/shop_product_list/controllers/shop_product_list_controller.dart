import 'package:get/get.dart';
import '../../../models/product_discount.dart';
import '../../../service/product_service.dart';
import '../../../service/shop_service.dart';
import '../../shop_menu/controllers/shop_controller.dart';

class ShopProductListController extends GetxController {
  final products = <ProductDiscount>[].obs;
  final RxString searchKeyword = ''.obs;
  final RxInt selectedTab = 0.obs;
  final RxInt sortOrder = 0.obs;
  final Rx<ProductSortType> sortType = ProductSortType.none.obs; // Sắp xếp mặc định theo tên tăng dần

  final shopService = ShopService();
  final productService = ProductService(); // thêm dòng này


  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    final shopId = Get.find<ShopController>().shopId;
    final result = await shopService.fetchProductsByShop(shopId);
    products.assignAll(result);
    print(shopId);
  }

  Future<void> deleteProductFromServer(ProductDiscount product) async {
    try {
      final success = await productService.deleteProduct(product.id);
      if (success) {
        products.remove(product);
        Get.snackbar("Thành công", "Đã xoá sản phẩm");
      } else {
        Get.snackbar("Thất bại", "Không thể xoá sản phẩm");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Đã xảy ra lỗi khi xoá sản phẩm");
      print("❌ Error deleting product: $e");
    }
  }

  List<ProductDiscount> get filteredProducts {
    List<ProductDiscount> filteredList = products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(searchKeyword.value.toLowerCase());
      final status = p.status ?? '';  // Nếu status là null, gán giá trị mặc định là ''

      switch (selectedTab.value) {
        case 0: // Còn hàng
          return matchSearch && status == 'ACTIVE' && p.quantity > 0;
        case 1: // Hết hàng
          return matchSearch && status == 'ACTIVE' && p.quantity == 0;
        case 2: // Chờ duyệt
          return matchSearch && status == 'PENDING';
        default:
          return matchSearch;
      }
    }).toList();

    applySort(filteredList);
    return filteredList;
  }

  void applySort(List<ProductDiscount> list) {
    switch (sortType.value) {
      case ProductSortType.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortType.nameDesc:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case ProductSortType.priceAsc:
        list.sort((a, b) => a.defaultPrice.compareTo(b.defaultPrice));
        break;
      case ProductSortType.priceDesc:
        list.sort((a, b) => b.defaultPrice.compareTo(a.defaultPrice));
        break;
      case ProductSortType.quantityAsc:
        list.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
      case ProductSortType.quantityDesc:
        list.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      case ProductSortType.none:
      default:
        break;
    }
  }

  // Getter để đếm số lượng sản phẩm cho từng tab
  int get inStockCount {
    return products.where((p) => (p.status ?? '') == 'ACTIVE' && p.quantity > 0).length;
  }

  int get outOfStockCount {
    return products.where((p) => (p.status ?? '') == 'ACTIVE' && p.quantity == 0).length;
  }

  int get pendingCount {
    return products.where((p) => (p.status ?? '') == 'PENDING').length;
  }

  void deleteProduct(ProductDiscount product) {
    products.remove(product);
  }
}

enum ProductSortType {
  none,
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  quantityAsc,
  quantityDesc,
}


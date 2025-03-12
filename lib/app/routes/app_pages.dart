import 'package:get/get.dart';
import '../modules/productForm/bindings/product_form_binding.dart';
import '../modules/productForm/views/product_form_view.dart';
import '../modules/productListShop/bindings/product_list_shop_binding.dart';
import '../modules/productListShop/views/product_list_shop_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.PRODUCT_LIST_SHOP;

  static final routes = [
    GetPage(
      name: _Paths.PRODUCT_LIST_SHOP,
      page: () => ProductListShopView(),
      binding: ProductListShopBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_FORM,
      page: () => ProductFormView(),
      binding: ProductFormBinding(),
    ),
  ];
}

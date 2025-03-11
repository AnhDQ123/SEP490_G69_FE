import 'package:get/get.dart';

import '../modules/addBanner/bindings/add_banner_binding.dart';
import '../modules/addBanner/views/add_banner_view.dart';
import '../modules/addDiscount/bindings/add_discount_binding.dart';
import '../modules/addDiscount/views/add_discount_view.dart';
import '../modules/productForm/bindings/product_form_binding.dart';
import '../modules/productForm/views/product_form_view.dart';
import '../modules/productListShop/bindings/product_list_shop_binding.dart';
import '../modules/productListShop/views/product_list_shop_view.dart';
import '../modules/shop/bindings/shop_binding.dart';
import '../modules/shop/views/shop_view.dart';
import '../modules/shopRegister/bindings/shop_register_binding.dart';
import '../modules/shopRegister/views/shop_register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SHOP;

  static final routes = [
    GetPage(
      name: _Paths.SHOP,
      page: () => ShopView(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST_SHOP,
      page: () => ProductListShopView(),
      binding: ProductListShopBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DISCOUNT,
      page: () => AddDiscountView(),
      binding: AddDiscountBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BANNER,
      page: () => AddBannerView(),
      binding: AddBannerBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_FORM,
      page: () => ProductFormView(),
      binding: ProductFormBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_REGISTER,
      page: () => ShopRegisterView(),
      binding: ShopRegisterBinding(),
    ),
  ];
}

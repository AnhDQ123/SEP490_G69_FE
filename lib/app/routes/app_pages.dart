import 'package:get/get.dart';

import '../modules/addBanner/bindings/add_banner_binding.dart';
import '../modules/addBanner/views/add_banner_view.dart';
import '../modules/addDiscount/bindings/add_discount_binding.dart';
import '../modules/addDiscount/views/add_discount_view.dart';
import '../modules/shop/bindings/shop_binding.dart';
import '../modules/shop/views/shop_view.dart';
import '../modules/shop_register/bindings/shop_register_binding.dart';
import '../modules/shop_register/views/shop_register_view.dart';

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
      name: _Paths.SHOP_REGISTER,
      page: () => ShopRegisterView(),
      binding: ShopRegisterBinding(),
    ),
  ];
}

import 'package:get/get.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
      binding: CartBinding(),
    ),
  ];
}

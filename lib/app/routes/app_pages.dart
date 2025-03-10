import 'package:get/get.dart';
import '../modules/shop_detail/bindings/shop_detail_binding.dart';
import '../modules/shop_detail/views/shop_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SHOP_DETAIL;

  static final routes = [
    GetPage(
      name: _Paths.SHOP_DETAIL,
      page: () => const ShopDetailView(),
      binding: ShopDetailBinding(),
    ),

  ];
}

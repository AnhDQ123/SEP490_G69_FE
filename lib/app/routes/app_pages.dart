import 'package:get/get.dart';

import '../modules/shipper_register/bindings/shipper_register_binding.dart';
import '../modules/shipper_register/views/shipper_register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SHIPPER_REGISTER;

  static final routes = [
    GetPage(
      name: _Paths.SHIPPER_REGISTER,
      page: () => ShipperRegisterView(),
      binding: ShipperRegisterBinding(),
    ),
  ];
}

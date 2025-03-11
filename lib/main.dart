import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'app/models/shopProfile.dart';
import 'app/routes/app_pages.dart';
import 'app/service/shop_service.dart';

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       debugShowCheckedModeBanner: false,
//       title: 'Shopkeeper App',
//       initialRoute: Routes.SHOP_REGISTER, // Điều hướng tới trang SHOP
//       getPages: AppPages.routes, // Định tuyến sử dụng GetX
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter đã khởi tạo trước khi chạy
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      title: 'Shopkeeper App',
      initialRoute: Routes.SHOP, // Điều hướng tới trang SHOP
      getPages: AppPages.routes, // Định tuyến sử dụng GetX
    );
  }
}

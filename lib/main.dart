import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

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
      initialRoute: Routes.PRODUCT_LIST_SHOP, // Điều hướng tới trang SHOP
      getPages: AppPages.routes, // Định tuyến sử dụng GetX
    );
  }
}

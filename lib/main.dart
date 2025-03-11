import 'package:ffb_fe_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Demo HomePage',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // Bạn có thể bỏ initialBinding nếu đã khai báo binding cho từng route
      // Nếu cần binding chung cho app, hãy khai báo tại đây
    );
  }
}

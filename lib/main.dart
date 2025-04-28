import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'app/routes/app_pages.dart';
import 'app/service/shop_service.dart';
import 'app/base/base_common.dart';
import 'app/service/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BaseCommon.instance.init(); // Khởi tạo BaseCommon để lấy thông tin lưu trữ (token, userId)

  // Kiểm tra xem token đã được lưu trong SharedPreferences hay chưa
  final token = BaseCommon.instance.accessToken;

  String initialRoute = (token != null && token.isNotEmpty) ? Routes.HOME : Routes.LOGIN;

  runApp(MyApp(initialRoute: initialRoute)); // Truyền route ban đầu cho ứng dụng
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Demo HomePage',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute, // Dùng route ban đầu (Home hoặc Login)
      getPages: AppPages.routes,   // Đảm bảo sử dụng AppPages.routes
    );
  }
}

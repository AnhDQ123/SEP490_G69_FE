import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'app/routes/app_pages.dart';
import 'app/service/shop_service.dart';
import 'app/base/base_common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BaseCommon.instance.init(); // ⬅ load accessToken và userId
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Demo HomePage',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}

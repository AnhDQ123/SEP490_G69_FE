import 'package:ffb_fe_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
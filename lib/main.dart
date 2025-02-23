import 'package:ffb_fe_flutter/app/modules/bloglist/views/bloglist_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'app/modules/bloglist/controllers/bloglist_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  Get.put(BloglistController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/bloglist",
      getPages: AppPages.routes,
    );
  }
}

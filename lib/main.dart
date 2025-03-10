import 'package:ffb_fe_flutter/app/modules/cart/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/home/bindings/home_binding.dart';
import 'app/modules/home/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Demo HomePage',
      initialBinding: HomeBinding(),
      home: const HomeView(),
    );
  }
}

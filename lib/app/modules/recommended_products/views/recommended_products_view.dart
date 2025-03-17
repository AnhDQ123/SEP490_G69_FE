import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/recommended_products_controller.dart';

class RecommendedProductsView extends GetView<RecommendedProductsController> {
  const RecommendedProductsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecommendedProductsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RecommendedProductsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

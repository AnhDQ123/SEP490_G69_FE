import 'package:ffb_fe_flutter/app/modules/home/views/widget/banner_slider.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/best_seller_food.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/category_section.dart';
import 'package:ffb_fe_flutter/app/resources/widget/custom_header.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/food_list.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/food_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/widget/bottom_nav.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  Widget _sectionCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(212, 163, 115, 1),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: const CustomHeader(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(BannerSlider(controller: controller)),
            _sectionCard(CategorySection(controller: controller)),
            _sectionCard(BestSellerFoods(controller: controller)),
            _sectionCard(FoodTabs(controller: controller)),
            _sectionCard(FoodList(controller: controller)),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomNav(
          currentIndex: controller.bottomNavIndex.value,
          onItemSelected: (index) {
            controller.switchBottomNav(index);
          },
        ),
      ),
    );
  }
}


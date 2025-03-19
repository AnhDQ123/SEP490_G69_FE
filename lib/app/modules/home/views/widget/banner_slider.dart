import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/assets_manager.dart';
import '../../../../resources/responsive_utils.dart';
import '../../controllers/home_controller.dart';

class BannerSlider extends StatelessWidget {
  final HomeController controller;
  const BannerSlider({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      ImageAssets.banner1,
      ImageAssets.banner2,
      ImageAssets.banner3,
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: UtilsReponsive.height(120, context),
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            aspectRatio: 16 / 9,
            onPageChanged: (index, reason) {
              controller.currentBannerIndex.value = index;
            },
          ),
          items: bannerImages.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(UtilsReponsive.width(12, context)), // ✅ Responsive corner
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),


        Positioned(
          bottom: UtilsReponsive.height(8, context),
          child: Obx(() {
            return Container(
              padding: UtilsReponsive.paddingOnly(context, left: 10, right: 10, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(UtilsReponsive.width(12, context)), // ✅ Responsive bo góc
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(bannerImages.length, (index) {
                  return Container(
                    width: UtilsReponsive.width(8, context),
                    height: UtilsReponsive.height(8, context),
                    margin: UtilsReponsive.paddingOnly(context, left: 3, right: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.currentBannerIndex.value == index
                          ? Colors.orange
                          : Colors.grey.shade400,
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ],
    );
  }
}

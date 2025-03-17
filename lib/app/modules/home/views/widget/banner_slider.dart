import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class BannerSlider extends StatelessWidget {
  final HomeController controller;
  const BannerSlider({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      'assets/images/banner1.avif',
      'assets/images/banner2.avif',
      'assets/images/banner3.avif',
    ];

    return Stack(
      alignment: Alignment.bottomCenter, // ✅ Căn giữa chấm bên trong ảnh
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 120.0,
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
                return ClipRRect( // ✅ Bo góc ảnh
                  borderRadius: BorderRadius.circular(12),
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

        // ✅ Chấm chuyển banner bên trong ảnh
        Positioned(
          bottom: 8, // ✅ Căn khoảng cách so với đáy ảnh
          child: Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // ✅ Tạo padding xung quanh
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // ✅ Nền trong suốt nhẹ
                borderRadius: BorderRadius.circular(12), // ✅ Bo góc chấm
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(bannerImages.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
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

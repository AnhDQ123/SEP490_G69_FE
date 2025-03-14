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
    return Column(
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
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            );
          }).toList(),
        ),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bannerImages.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.currentBannerIndex.value == index
                      ? Colors.orange
                      : Colors.grey,
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

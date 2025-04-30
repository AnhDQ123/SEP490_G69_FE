import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/assets_manager.dart';
import '../../../../resources/responsive_utils.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';

class BannerSlider extends StatelessWidget {
  final HomeController controller;
  const BannerSlider({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.bannerList.isEmpty) {
        return SizedBox(
          height: UtilsReponsive.height(120, context),
          child: Center(child: CircularProgressIndicator()),
        );
      }
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
            items: controller.bannerList.map((banner) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                      onTap: () {
                        if (banner.shopId != 0) {
                          Get.toNamed(Routes.USER_VIEW_SHOP_DETAIL, arguments: {
                            'shopId': banner.shopId,
                            'bannerId': banner.bannerId,
                          });
                          print("🛒 Chuyển sang shopId: ${banner.shopId}");
                        } else {
                          Get.snackbar("Thông báo", "Không tìm thấy thông tin cửa hàng");
                        }
                      },
                  child:  ClipRRect(
                    borderRadius: BorderRadius.circular(UtilsReponsive.width(12, context)),
                    child: Image.network(
                      banner.url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Center(child: Icon(Icons.broken_image)),
                        );
                      },
                    ),
                  ),
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
            bottom: UtilsReponsive.height(8, context),
            child: Container(
              padding: UtilsReponsive.paddingOnly(context, left: 10, right: 10, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(UtilsReponsive.width(12, context)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(controller.bannerList.length, (index) {
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
            ),
          ),
        ],
      );
    });
  }

}

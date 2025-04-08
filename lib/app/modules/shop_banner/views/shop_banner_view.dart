import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../routes/app_pages.dart';
import '../controllers/shop_banner_controller.dart';

class ShopBannerView extends GetView<ShopBannerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banner cửa hàng')),
      body: Obx(() {
        if (controller.banners.isEmpty) {
          return Center(child: Text("Không có banner nào"));
        }

        return ListView.builder(
          itemCount: controller.banners.length,
          itemBuilder: (context, index) {
            final banner = controller.banners[index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  banner.url,
                  width: 80,
                  fit: BoxFit.cover,
                ),
                title: Text("Banner #${banner.bannerId}"),
                subtitle: Text("Trạng thái: ${banner.status}"),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.toNamed(Routes.ADD_BANNER, arguments: {
            'shopId': controller.shopId,
          });

          // Sau khi thêm xong quay về, nếu result == true thì reload banner
          if (result == true) {
            controller.fetchBanners();
          }
        },
        label: Text("Thêm banner"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),

    );


  }
}

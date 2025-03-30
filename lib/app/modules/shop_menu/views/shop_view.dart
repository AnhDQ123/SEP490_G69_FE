import 'package:ffb_fe_flutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_controller.dart';

class ShopView extends GetView<ShopController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cửa hàng của tôi', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView( // Tránh lỗi overflow do layout dài
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShopHeader(),
              SizedBox(height: 10),
              _buildToggleButtons(),
              SizedBox(height: 10),
              _buildOrdersSection(),
              SizedBox(height: 10),
              _buildManagementGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopHeader() {
    return Obx(() {
      final shop = controller.shopInfo.value;

      if (shop == null) {
        return Center(child: CircularProgressIndicator());
      }

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage(shop.logo),
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    (shop.rate == 0)
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chưa có đánh giá',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${shop.viewCount} lượt xem',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        ...List.generate(
                          shop.rate.floor(),
                              (index) => Icon(Icons.star, color: Colors.amber, size: 18),
                        ),
                        if (shop.rate - shop.rate.floor() >= 0.5)
                          Icon(Icons.star_half, color: Colors.amber, size: 18),
                        SizedBox(width: 5),
                        Text(
                          '${shop.rate.toString()} (${shop.viewCount} lượt xem)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )

                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  final result = await Get.toNamed(Routes.SHOP_DETAIL, arguments: controller.shopInfo.value);

                  if (result == true) {
                    // Nếu từ SHOP_DETAIL trả về true (đã cập nhật thành công)
                    controller.fetchShopInfo(controller.shopId); // Reload lại shopInfo
                  }
                },
                child: Text('Chỉnh sửa'),
              )

            ],
          ),
        ),
      );
    });
  }

  Widget _buildToggleButtons() {
    return Column(
      children: [
        _buildSwitchTile('Miễn phí vận chuyển', controller.isFreeShipping),
        _buildSwitchTile('Tạm đóng cửa hàng', controller.isShopClosed),
      ],
    );
  }

  Widget _buildSwitchTile(String title, RxBool value) {
    return Obx(() => SwitchListTile(
      title: Text(title),
      value: value.value,
      onChanged: (val) => value.value = val,
    ));
  }

  Widget _buildOrdersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Đơn hàng trong tháng', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: TextButton(onPressed: () {}, child: Text('Xem thêm >')),
            ),
            Obx(() {
              // Kiểm tra nếu orderCounts đã được cập nhật từ API
              if (controller.orderCounts.isEmpty) {
                return CircularProgressIndicator(); // Chờ dữ liệu từ API
              }

              // Tính tổng trạng thái "Đã hủy/trả hàng"
              int cancelledAndReturned = (controller.orderCounts['cancelled'] ?? 0) +
                  (controller.orderCounts['rejected'] ?? 0) +
                  (controller.orderCounts['returned'] ?? 0) +
                  (controller.orderCounts['returnPending'] ?? 0) +
                  (controller.orderCounts['returnRejected'] ?? 0);

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Cho phép kéo ngang
                child: Row(
                  children: [
                    _buildOrderStatus(controller.orderCounts['pending']?.toString() ?? '0', 'Chờ xác nhận'),
                    _buildOrderStatus(controller.orderCounts['processing']?.toString() ?? '0', 'Đang chuẩn bị'),
                    _buildOrderStatus(controller.orderCounts['shipPending']?.toString() ?? '0', 'Chờ lấy hàng'),
                    _buildOrderStatus(controller.orderCounts['shipping']?.toString() ?? '0', 'Đang giao hàng'),
                    _buildOrderStatus(controller.orderCounts['delivered']?.toString() ?? '0', 'Đã giao'),
                    _buildOrderStatus(cancelledAndReturned.toString(), 'Đã hủy/trả hàng'), // Tổng đã hủy/trả hàng
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus(String count, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Thêm khoảng cách giữa các cột
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(status, style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }


  Widget _buildManagementGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5, // Điều chỉnh tỉ lệ để tránh overflow
      children: [
        _buildGridItem(Icons.category, 'Sản phẩm', () => Get.toNamed(Routes.PRODUCT_LIST_SHOP)),
        _buildGridItem(Icons.pie_chart, 'Thống kê', () => Get.toNamed(Routes.SHOP_DASHBOARD)),
        _buildGridItem(Icons.percent, 'Giảm giá', () => Get.toNamed(Routes.PRODUCT_DISCOUNT)),
        _buildGridItem(Icons.description, 'Báo cáo', () {}),
        _buildGridItem(Icons.local_offer, 'Voucher', () => Get.toNamed(Routes.SHOP_VOUCHER_LIST)),
        _buildGridItem(Icons.campaign, 'Banner', () => Get.toNamed(Routes.ADD_BANNER)),
      ],
    );
  }

  Widget _buildGridItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Tránh lỗi overflow trong GridView
            children: [
              Icon(icon, size: 30),
              SizedBox(height: 5),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

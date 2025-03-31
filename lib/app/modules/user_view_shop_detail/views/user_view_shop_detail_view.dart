import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_view_shop_detail_controller.dart';

class UserViewShopDetailView extends GetView<UserViewShopDetailController> {
  const UserViewShopDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cơm rang Minh Nhật', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Icon(Icons.share),
          SizedBox(width: 8),
          Icon(Icons.favorite_border),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildShopHeaderSection(),
            // _buildDeliveryInfoCard(),
            _buildBestSellerCard(),
            _buildContactCard(),
            _buildMenuCard(),
          ],
        ),
      ),

    );
  }
  Widget _buildShopHeaderSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa (background image)
          Stack(
            children: [
              // Hiển thị ảnh background từ API
              Obx(() {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: controller.shopBackgroundImage.value.isEmpty
                      ? const Center(child: Icon(Icons.image, size: 80)) // Nếu background trống, hiển thị icon
                      : Image.network(controller.shopBackgroundImage.value, fit: BoxFit.cover), // Hiển thị ảnh background
                );
              }),
              // Avatar nổi (logo shop)
              Obx(() {
                return Positioned(
                  bottom: 10,
                  left: 16,
                  child: ClipOval( // Thay CircleAvatar bằng ClipOval để bo tròn ảnh
                    child: Container(
                      height: 80, // Kích thước của hình tròn (logo)
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: controller.shopLogo.value.isEmpty
                          ? const Icon(Icons.person, size: 28, color: Colors.white)  // Nếu logo trống, hiển thị icon
                          : Image.network(controller.shopLogo.value, fit: BoxFit.cover),  // Hiển thị logo
                    ),
                  ),
                );
              }),
              // Icon phóng to
              const Positioned(
                bottom: 8,
                right: 16,
                child: Icon(Icons.zoom_in),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị tên shop từ controller
                Obx(() {
                  return Text(
                    controller.shopName.value,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  );
                }),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Hiển thị rating shop từ controller
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    SizedBox(width: 4),
                    Obx(() {
                      return Text('${controller.shopRate.value}', style: const TextStyle(fontSize: 13));
                    }),
                    const SizedBox(width: 4),
                    SizedBox(width: 4),
                    Icon(Icons.share, size: 16),
                    SizedBox(width: 8),
                    Icon(Icons.favorite_border, size: 16),
                    SizedBox(width: 8),
                    Icon(Icons.notifications_none, size: 16),
                  ],
                ),
                const SizedBox(height: 6),
                // Hiển thị mô tả shop từ controller
                Obx(() {
                  return Text(
                    controller.shopDescription.value,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  );
                }),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDeliveryInfoCard() {
  //   return Card(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     child: ListTile(
  //       leading: const Icon(Icons.delivery_dining),
  //       title: const Text('Giao hàng ngay bây giờ', style: TextStyle(fontSize: 14)),
  //       subtitle: const Text('Dự kiến giao hàng lúc 17:15', style: TextStyle(fontSize: 13)),
  //       trailing: TextButton(
  //         onPressed: () {},
  //         child: const Text('Thay đổi', style: TextStyle(fontSize: 13)),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBestSellerCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sản phẩm bán chạy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            // Dùng Obx để theo dõi sự thay đổi của topSellingProducts
            Obx(() {
              if (controller.topSellingProducts.isEmpty) {
                return const Center(child: CircularProgressIndicator());  // Hiển thị loading nếu không có dữ liệu
              }
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.topSellingProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.topSellingProducts[index];
                    return _bestSellerItem(
                      imageUrl: 'https://via.placeholder.com/150',  // Có thể thay bằng hình ảnh thực tế nếu có
                      title: product['name'],
                      price: 'Giá: ${product['totalQuantity']} sản phẩm',  // Thay đổi cách hiển thị giá nếu cần
                      sold: 'Đã bán: ${product['totalQuantity']} hôm nay',
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget _bestSellerItem({
    required String imageUrl,
    required String title,
    required String price,
    required String sold,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 100,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(price, style: const TextStyle(fontSize: 13)),
          Text(
            sold,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.shopping_cart_outlined, size: 16),
          )
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: const ListTile(
        leading: Icon(Icons.phone),
        title: Text('Hotline: 0964937641', style: TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildMenuCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Menu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const Divider(),
            // Sử dụng Obx để tự động cập nhật khi menuImage thay đổi
            Obx(() {
              if (controller.menuImage.value.isEmpty) {
                return const Center(child: CircularProgressIndicator());  // Nếu chưa có dữ liệu, hiển thị loading
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    controller.menuImage.value,
                    width: double.infinity,  // Chiều rộng toàn bộ
                    height: 250,             // Chiều cao ảnh lớn hơn
                    fit: BoxFit.cover,       // Đảm bảo ảnh bao phủ toàn bộ diện tích
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget _menuItem(String imageUrl) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          height: 150,  // Tăng chiều cao của ảnh
          width: 150,   // Tăng chiều rộng của ảnh
          fit: BoxFit.cover,
        ),
      ),
      title: const Text('Món ăn', style: TextStyle(fontSize: 14)),  // Tên món có thể lấy từ backend nếu có
      subtitle: const Text('Đã bán 60 hôm nay', style: TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.shopping_cart_outlined, size: 16),
    );
  }


}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_view_shop_detail_controller.dart';

class UserViewShopDetailView extends GetView<UserViewShopDetailController> {
  UserViewShopDetailView({super.key});
  final RxInt selectedRating = 0.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cơm rang Minh Nhật', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
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
            _buildShopInfoSection(),
            _buildRatingSection(),
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
                  child: controller.shopBackgroundImage.value==null
                      ? const Center(child: Icon(Icons.image, size: 80)) // Nếu background trống, hiển thị icon
                      : Image.network(controller.shopBackgroundImage.value!, fit: BoxFit.cover), // Hiển thị ảnh background
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
                      child: controller.shopLogo.value==null
                          ? const Icon(Icons.person, size: 28, color: Colors.white)  // Nếu logo trống, hiển thị icon
                          : Image.network(controller.shopLogo.value!, fit: BoxFit.cover),  // Hiển thị logo
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
                // Row(
                //   children: [
                //     // Hiển thị rating shop từ controller
                //     const Icon(Icons.star, size: 14, color: Colors.orange),
                //     SizedBox(width: 4),
                //     Obx(() {
                //       return Text('${controller.shopRate.value}', style: const TextStyle(fontSize: 13));
                //     }),
                //     const SizedBox(width: 4),
                //     SizedBox(width: 4),
                //     Icon(Icons.share, size: 16),
                //     SizedBox(width: 8),
                //     Icon(Icons.favorite_border, size: 16),
                //     SizedBox(width: 8),
                //     Icon(Icons.notifications_none, size: 16),
                //   ],
                // ),
                const SizedBox(height: 6),
                // Hiển thị mô tả shop từ controller
                Obx(() {
                  return Text(
                    controller.shopDescription.value ?? '',
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

  // Thêm section thông tin cửa hàng mới
  Widget _buildShopInfoSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin cửa hàng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Obx(() => _buildInfoRow(
              Icons.location_on,
              'Địa chỉ',
              controller.shopAddress.value ?? 'Chưa cập nhật',
            )),

            Obx(() => _buildInfoRow(
              Icons.access_time,
              'Giờ mở cửa',
              '${controller.shopOpenTime.value.isNotEmpty ? controller.shopOpenTime.value : '??'} - ${controller.shopCloseTime.value.isNotEmpty ? controller.shopCloseTime.value : '??'}',
            )),

            _buildInfoRow(Icons.delivery_dining, 'Giao hàng', 'Có giao hàng tận nơi'), // Có thể thêm logic kiểm tra
            _buildInfoRow(Icons.credit_card, 'Thanh toán', 'Tiền mặt, Chuyển khoản, Ví điện tử'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Thêm section đánh giá
  Widget _buildRatingSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Đánh giá cửa hàng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange),
                        SizedBox(width: 4),
                        Obx(() {
                          return Text(
                            '${controller.shopRate.value.toStringAsFixed(1)}/5',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        }),
                      ],
                    ),
                    Text('Dựa trên 120 đánh giá', style: TextStyle(fontSize: 12)),
                  ],
                ),
                ElevatedButton(
                  onPressed: _rateShop,
                  child: Text('Đánh giá'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _rateShop() {
    final TextEditingController commentController = TextEditingController();
    selectedRating.value = 0;

    Get.bottomSheet(
      Obx(() => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Đánh giá cửa hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < selectedRating.value ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 40,
                  ),
                  onPressed: () {
                    selectedRating.value = index + 1;
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Nhận xét của bạn...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                controller.submitShopRating(selectedRating.value.toDouble());
              },
              child: Text('Gửi đánh giá'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      )),
    );
  }



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
                      imageUrl: 'https://via.placeholder.com/150',  // hoặc sửa sau
                      title: product.name,
                      price: 'Giá trị: ${product.totalValue.toStringAsFixed(0)}đ',
                      sold: 'Đã bán: ${product.totalQuantity} hôm nay',
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
      child: Obx(() {
        return ListTile(
          leading: const Icon(Icons.phone),
          title: Text(
            'Hotline: ${controller.shopPhone.value ?? 'Không có số điện thoại'}',
            style: const TextStyle(fontSize: 14),
          ),
        );
      }),
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
              if (controller.menuImage.value == null) {
                return const Center(child: CircularProgressIndicator());  // Nếu chưa có dữ liệu, hiển thị loading
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    controller.menuImage.value!,
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

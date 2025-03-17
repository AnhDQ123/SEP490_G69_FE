import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/widget/bottom_nav.dart';
import '../../../resources/widget/custom_header.dart'; // ✅ Thêm import
import '../controllers/filter_controller.dart';

class FilterView extends GetView<FilterController> {
  const FilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Sử dụng CustomHeader thay thế AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const CustomHeader(),
      ),
      // ✅ Nội dung chính của trang
      body: Column(
        children: [
          // 🔹 Thanh filter
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                // Nút "Bộ lọc"
                OutlinedButton.icon(
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Bộ lọc"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                // Hiển thị tag filter nếu có danh mục được chọn
                Obx(() {
                  return controller.filterCategory.value.isNotEmpty
                      ? Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(controller.filterCategory.value),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            controller.removeCategoryFilter();
                          },
                          child: const Icon(Icons.close, size: 16),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.grey.shade300,
                  )
                      : const SizedBox();
                }),
              ],
            ),
          ),
          // 🔹 Hàng tab (Các sản phẩm, Bán chạy, Đánh giá, Giá)
          Container(
            color: Colors.white,
            height: 45,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                final currentTab = controller.selectedTabIndex.value;
                return Row(
                  children: [
                    _buildTopTab("Các sản phẩm", 0, currentTab),
                    _buildTopTab("Bán chạy", 1, currentTab),
                    _buildTopTab("Đánh giá", 2, currentTab),
                    _buildTopTab("Giá", 3, currentTab),
                  ],
                );
              }),
            ),
          ),
          // 🔹 Danh sách sản phẩm
          Expanded(
            child: Obx(() {
              final products = controller.products;
              if (products.isEmpty) {
                return const Center(child: Text('Không có sản phẩm'));
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return _buildProductItem(item);
                },
              );
            }),
          ),
        ],
      ),
      // ✅ Bottom Navigation
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

  // 🔹 Widget tab menu
  Widget _buildTopTab(String title, int tabIndex, int currentTab) {
    final isSelected = (tabIndex == currentTab);
    return InkWell(
      onTap: () => controller.switchTopTab(tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(bottom: BorderSide(color: Colors.black, width: 2))
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> item) {
    // Giá cố định: 100000
    const double originalPrice = 100000;
    // Lấy discount từ item, nếu không có gán mặc định bằng 0
    final discount = (item['discount'] ?? 0);
    final hasDiscount = discount > 0;
    // Tính giá mới nếu có discount
    final finalPrice = hasDiscount ? originalPrice * (1 - discount / 100) : originalPrice;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ảnh sản phẩm với nhãn discount bên trong, kích thước ảnh được tăng lên (75x75)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  color: Colors.grey.shade200,
                  child: item['image'] != null && item['image'].toString().isNotEmpty
                      ? Image.network(item['image'], fit: BoxFit.cover)
                      : const Icon(Icons.image, color: Colors.grey),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${discount.toString()}%',
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Thông tin sản phẩm (text giữ nguyên kích thước ban đầu)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm (font nhỏ)
                Text(
                  item['name'] ?? '',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Tên shop và icon verified
                Row(
                  children: [
                    Text(
                      'Shop: ${item['shop'] ?? 'Không xác định'}',
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color.fromRGBO(212, 163, 115, 1),
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.verified,
                      size: 10,
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Đánh giá sản phẩm
                if (item['rate'] != null)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 10, color: Colors.orange),
                      const SizedBox(width: 2),
                      Text(
                        item['rate'].toString(),
                        style: const TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                const SizedBox(height: 2),
                // Hiển thị giá: nếu có discount thì hiển thị giá cũ gạch ngang và giá mới
                Row(
                  children: [
                    if (hasDiscount)
                      Text(
                        "${originalPrice.toStringAsFixed(0)}đ",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    if (hasDiscount) const SizedBox(width: 4),
                    Text(
                      "${finalPrice.toStringAsFixed(0)}đ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}

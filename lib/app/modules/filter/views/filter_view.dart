import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/widget/bottom_nav.dart';
import '../controllers/filter_controller.dart';

class FilterView extends GetView<FilterController> {
  const FilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar chỉ chứa back, search, message và thông báo
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SafeArea(
            child: Row(
              children: [
                // Nút back
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
                // Ô tìm kiếm hiển thị filter hiện hành
                Expanded(
                  child: Obx(
                        () => Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey, size: 20),
                          const SizedBox(width: 4),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: controller.filterCategory.value,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: "Tìm sản phẩm",
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Icon tin nhắn
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                  onPressed: () {
                    // TODO: Xử lý tin nhắn
                  },
                ),
                // Icon thông báo
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.grey),
                  onPressed: () {
                    // TODO: Xử lý thông báo
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // Body: hiển thị tag filter, hàng tab và danh sách sản phẩm
      body: Column(
        children: [
          // Container hiển thị nút "Bộ lọc" và tag filter
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
                  ),
                  onPressed: () {
                    // TODO: Mở bộ lọc
                  },
                ),
                const SizedBox(width: 8),
                // Tag hiển thị tên danh mục (filter) kèm dấu X
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    // Nếu cần xử lý khi bấm vào tag, có thể để trống hoặc bổ sung logic
                  },
                  child: Row(
                    children: [
                      Obx(() => Text(controller.filterCategory.value)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          controller.removeCategoryFilter();
                        },
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Hàng tab: Các sản phẩm, Bán chạy, Đánh giá, Giá
          Container(
            color: Colors.grey.shade100,
            height: 40,
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
          // Danh sách sản phẩm
          Expanded(
            child: Obx(() {
              final products = controller.products;
              if (products.isEmpty) {
                return const Center(child: Text('Không có sản phẩm'));
              }
              return ListView.builder(
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
      // BottomNav
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

  // Widget tab
  Widget _buildTopTab(String title, int tabIndex, int currentTab) {
    final isSelected = (tabIndex == currentTab);
    return InkWell(
      onTap: () => controller.switchTopTab(tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
            bottom: BorderSide(color: Colors.black, width: 2),
          )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Widget mỗi item sản phẩm
  Widget _buildProductItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Ảnh sản phẩm
          Container(
            width: 50,
            height: 50,
            color: Colors.grey.shade200,
            child: item['image'] != null
                ? Image.network(item['image'], fit: BoxFit.cover)
                : const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    Text(' ${item['rating'] ?? 0.0}'),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    Text(' ${item['distance'] ?? 0.0} km'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['price'] ?? 0}đ',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


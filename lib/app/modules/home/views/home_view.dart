import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/product.dart';
import '../../../resources/widget/bottom_nav.dart';
import '../../../service/home_api_service.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(212, 163, 115, 1),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: _buildCustomHeader(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(_buildBannerSection()),
            _sectionCard(_buildCategorySection()),
            _sectionCard(_buildBestSellerFoods()),
            // _sectionCard(_buildRecommendedFoods()),
            _sectionCard(_buildFoodTabs()),
            _sectionCard(_buildFoodList()),
            const SizedBox(height: 16),
          ],
        ),
      ),
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

  Widget _sectionCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Header: logo, thanh tìm kiếm, icon chat & thông báo
  Widget _buildCustomHeader() {
    return Container(
      color: const Color.fromRGBO(212, 163, 115, 1),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Thanh tìm kiếm
          Expanded(
            child: Container(
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
                      decoration: InputDecoration(
                        hintText: "Tìm sản phẩm",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Icon chat
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 20),
          ),
          // Icon thông báo
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }

  /// Banner slider
  Widget _buildBannerSection() {
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
        // Indicator
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

  Widget _buildCategorySection() {
    return Obx(() {
      final categories = controller.categoryList;

      if (categories.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      int rowCount = categories.length <= 5 ? 1 : 2;
      double cellHeight = 70;
      double sectionHeight = (cellHeight * rowCount) + 16 + 40;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Danh mục',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: sectionHeight,
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: rowCount,
              childAspectRatio: 0.9,
              mainAxisSpacing: 4,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((category) {
                // return Center(
                //   child: Text(
                //     category.name,
                //     style: const TextStyle(fontSize: 12),
                //     textAlign: TextAlign.center,
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // );
                return InkWell(
                  onTap: () {
                    // Điều hướng sang trang Filter, truyền tên danh mục được bấm
                    Get.toNamed('/filter', arguments: {'categoryName': category.name});
                  },
                  child: Center(
                    child: Text(
                      category.name,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }


  /// Best Seller Foods section
  Widget _buildBestSellerFoods() {
    final bestSellerItems = controller.bestSellerFoods;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + xem thêm
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Món ăn bán chạy theo ngày',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'xem thêm',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bestSellerItems.length,
            itemBuilder: (context, index) {
              final item = bestSellerItems[index];
              return _buildFoodCardItem(item, index, bestSellerItems.length);
            },
          ),
        ),
      ],
    );
  }

  /// Recommended Foods section
  // Widget _buildRecommendedFoods() {
  //   final recommendedItems = controller.recommendedFoods;
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Title + xem thêm
  //       // Padding(
  //       //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       //   child: Row(
  //       //     children: [
  //       //       const Text(
  //       //         'Món ăn đề xuất',
  //       //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       //       ),
  //       //       const Spacer(),
  //       //       GestureDetector(
  //       //         onTap: () {
  //       //           // xem thêm
  //       //         },
  //       //         child: const Text(
  //       //           'xem thêm',
  //       //           style: TextStyle(
  //       //             fontSize: 14,
  //       //             color: Colors.blue,
  //       //             decoration: TextDecoration.underline,
  //       //           ),
  //       //         ),
  //       //       ),
  //       //     ],
  //       //   ),
  //       // ),
  //       const SizedBox(height: 8),
  //       SizedBox(
  //         height: 120,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: recommendedItems.length,
  //           itemBuilder: (context, index) {
  //             final item = recommendedItems[index];
  //             return _buildFoodCardItem(item, index, recommendedItems.length);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  /// Hiển thị card món ăn cho Best Seller & Recommended
  Widget _buildFoodCardItem(Map<String, String> item, int index, int total) {
    return Container(
      width: 140,
      height: 105,
      margin: EdgeInsets.only(
        left: (index == 0) ? 16 : 8,
        right: (index == total - 1) ? 16 : 0,
      ),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tên món
                Text(
                  item['name'] ?? '',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      item['rating'] ?? '0.0',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Giá mới
                Text(
                  item['price'] ?? '',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 1),
                // Giá cũ
                Text(
                  item['oldPrice'] ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
          // Hình ảnh
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 1),
              image: item['image'] != null
                  ? DecorationImage(
                image: AssetImage(item['image']!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: item['image'] == null
                ? const Icon(Icons.image, size: 20)
                : null,
          ),
        ],
      ),
    );
  }

  /// Widget hiển thị thông tin sản phẩm cho tab "Đồ ăn" và "Chợ tươi sống"
  /// Hiển thị card sản phẩm từ API
  /// Sửa widget _buildProductCard để nhận đối tượng Product thay vì Map<String, String>
  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Hình ảnh sản phẩm
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.shade300,
              image: (product.image != null && product.image!.isNotEmpty)
                  ? DecorationImage(
                image: NetworkImage(product.image!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: (product.image == null || product.image!.isEmpty)
                ? const Icon(Icons.image, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          // Thông tin sản phẩm
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm
                Text(
                  product.name ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Ví dụ hiển thị số lượng và discount (nếu có)
                Text(
                  "Số lượng: ${product.quantity ?? 0}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                if ((product.discount ?? 0) > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${product.discount?.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // (Có thể thêm nút "Thêm vào giỏ hàng" nếu cần)
        ],
      ),
    );
  }

  /// Tabs "Đồ ăn" / "Chợ tươi sống"
  Widget _buildFoodTabs() {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => controller.switchFoodTab(0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: (controller.selectedFoodTab.value == 0)
                    ? Colors.orange.shade200
                    : Colors.grey.shade200,
                child: const Center(
                  child: Text("Đồ ăn"),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => controller.switchFoodTab(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: (controller.selectedFoodTab.value == 1)
                    ? Colors.orange.shade200
                    : Colors.grey.shade200,
                child: const Center(
                  child: Text("Chợ tươi sống"),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  /// Danh sách sản phẩm theo tab
  Widget _buildFoodList() {
    return Obx(() {
      final list = controller.currentList;
      if (list.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        key: ValueKey<int>(controller.selectedFoodTab.value),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            final product = list[index] as Product;
            return _buildProductCard(product);
          },
        ),
      );
    });
  }
}

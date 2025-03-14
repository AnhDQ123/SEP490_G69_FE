import 'package:ffb_fe_flutter/app/modules/product_detail/views/widget/extra_options_sheet.dart';
import 'package:ffb_fe_flutter/app/modules/product_detail/views/widget/product_header.dart';
import 'package:ffb_fe_flutter/app/modules/product_detail/views/widget/product_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';


class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy controller đã được khởi tạo bởi GetX
    final controller = Get.find<ProductDetailController>();

    return DefaultTabController(
      length: 3, // Giả sử có 3 tab: Món ăn tương tự, Thực đơn, Đồ uống
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // Thanh tìm kiếm
          title: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.message, color: Colors.black87),
              onPressed: () => print('Icon message được nhấn'),
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black87),
              onPressed: () => print('Icon thông báo được nhấn'),
            ),
          ],
        ),
        // Sử dụng NestedScrollView để hiển thị header (ProductHeader) và tab content (ProductListWidget)
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Widget hiển thị thông tin chi tiết sản phẩm (header)
              SliverToBoxAdapter(
                child: ProductHeader(controller: controller),
              ),
              // Tab bar hiển thị các danh mục sản phẩm liên quan
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                bottom: const TabBar(
                  indicatorColor: Colors.redAccent,
                  labelColor: Colors.redAccent,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(text: 'Món ăn tương tự'),
                    Tab(text: 'Thực đơn'),
                    Tab(text: 'Đồ uống'),
                  ],
                ),
              ),
            ];
          },
          // Nội dung hiển thị theo từng tab
          body: TabBarView(
            children: [
              // Tab "Món ăn tương tự": dữ liệu fetch từ API
              ProductListWidget(products: controller.similarProducts),
              // Các tab khác có thể dùng dữ liệu mẫu hoặc tĩnh
              ProductListWidget(products: controller.menuProducts),
              ProductListWidget(products: controller.drinkProducts),
            ],
          ),
        ),
        // Phần bottom navigation với nút giỏ hàng và "Thêm vào giỏ hàng"
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () => print('Xem giỏ hàng'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(56, 56),
                ),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Hiển thị bottom sheet khi nhấn nút "Thêm vào giỏ hàng"
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.66,
                          child: ExtraOptionsSheet(),
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Thêm vào giỏ hàng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
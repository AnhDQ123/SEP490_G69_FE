import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/modules/product_detail/views/widget/extra_options_sheet.dart';
import 'package:ffb_fe_flutter/app/modules/product_detail/views/widget/product_header.dart';
import 'package:ffb_fe_flutter/app/modules/product_detail/views/widget/product_list.dart';
import '../../../resources/widget/custom_header.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: const CustomHeader(),
        ),

        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: ProductHeader(controller: controller),
              ),
              SliverAppBar(
                pinned: true, // Giữ TabBar cố định khi cuộn
                floating: true, // Cho phép TabBar hiển thị ngay khi cuộn đến
                snap: true, // Giúp TabBar bật lên ngay khi cuộn đến
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                expandedHeight: kToolbarHeight, // Tránh lỗi overflow do chiều cao quá nhỏ
                flexibleSpace: const FlexibleSpaceBar(), // Cho phép SliverAppBar co giãn mượt mà
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: SizedBox(
                    height: 48, // 🔥 Đảm bảo TabBar có kích thước chính xác
                    child: const TabBar(
                      isScrollable: true,
                      indicatorColor: Color.fromRGBO(212, 163, 115, 1),
                      labelColor: Color.fromRGBO(212, 163, 115, 1),
                      unselectedLabelColor: Colors.black54,
                      labelPadding: EdgeInsets.symmetric(horizontal: 12),
                      tabs: [
                        Tab(text: 'Món ăn tương tự'),
                        Tab(text: 'Thực đơn'),
                        Tab(text: 'Đồ uống'),
                      ],
                    ),
                  ),
                ),

              ),
            ];
          },
          body: TabBarView(
            children: [
              ProductListWidget(products: controller.similarProducts),
              ProductListWidget(products: controller.menuProducts),
              ProductListWidget(products: controller.drinkProducts),

            ],
          ),
        ),



        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Nút xem giỏ hàng
              ElevatedButton(
                onPressed: () => print('Xem giỏ hàng'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(212, 163, 115, 1), backgroundColor: Colors.white, shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16), // Màu icon phù hợp
                  shadowColor: Colors.grey.withOpacity(0.5),
                  elevation: 4,
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Color.fromRGBO(212, 163, 115, 1),
                ),
              ),
              const SizedBox(width: 16),
              // Nút thêm vào giỏ hàng
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
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
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color.fromRGBO(212, 163, 115, 1), // Màu chữ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}



import 'package:ffb_fe_flutter/app/modules/cart/views/cart_view.dart';
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
      child: Stack(
        children: [
          Scaffold(
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
                    pinned: true,
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    expandedHeight: kToolbarHeight,
                    flexibleSpace: const FlexibleSpaceBar(),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(48),
                      child: SizedBox(
                        height: 48,
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
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: Get.context!,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) => CartView(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(212, 163, 115, 1),
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      shadowColor: Colors.grey.withOpacity(0.5),
                      elevation: 4,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color.fromRGBO(212, 163, 115, 1),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(212, 163, 115, 1),
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

          // 🔥 Overlay loading indicator
          Obx(() {
            return controller.isAddingToCart.value
                ? Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

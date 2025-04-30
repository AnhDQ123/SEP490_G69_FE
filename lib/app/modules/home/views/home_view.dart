import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/banner_slider.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/best_seller_food.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/category_section.dart';
import 'package:ffb_fe_flutter/app/resources/widget/custom_header.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/food_list.dart';
import 'package:ffb_fe_flutter/app/modules/home/views/widget/food_tabs.dart';
import 'package:ffb_fe_flutter/app/resources/widget/bottom_nav.dart';
import '../../../resources/responsive_utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  Widget _sectionCard(BuildContext context, Widget child) {
    return Container(
      margin: UtilsReponsive.paddingOnly(context, left: 12, right: 12, top: 8, bottom: 8),
      padding: UtilsReponsive.paddingAll(context, padding: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UtilsReponsive.width(12, context)), // Responsive radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: UtilsReponsive.width(1, context),
            blurRadius: UtilsReponsive.width(4, context),
            offset: Offset(0, UtilsReponsive.height(2, context)),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(212, 163, 115, 1),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: const CustomHeader(),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator()); // ✅ Hiển thị loading
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshAllData(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _sectionCard(context, BannerSlider(controller: controller))),
              SliverToBoxAdapter(child: _sectionCard(context, CategorySection(controller: controller))),
              SliverToBoxAdapter(child: _sectionCard(context, BestSellerFoods(controller: controller))),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _SliverAppBarDelegate(
                  minHeight: UtilsReponsive.height(55, context),
                  maxHeight: UtilsReponsive.height(60, context),
                  child: Container(
                    height: UtilsReponsive.height(60, context),
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: FoodTabs(controller: controller),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _sectionCard(context, FoodList(controller: controller))),
              SliverToBoxAdapter(child: SizedBox(height: UtilsReponsive.height(16, context))),
            ],
          ),
        );
      }),

      // Ở trang Home, set sẵn initialIndex là 2 (theo ánh xạ Routes.HOME)
      bottomNavigationBar: const BottomNav(initialIndex: 2),
    );
  }
}

// 🔹 Delegate giúp giữ `FoodTabs` cố định khi cuộn
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      color: Colors.white,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

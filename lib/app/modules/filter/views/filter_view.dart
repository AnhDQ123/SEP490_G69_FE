import 'package:ffb_fe_flutter/app/modules/filter/views/widget/filter_header.dart';
import 'package:ffb_fe_flutter/app/modules/filter/views/widget/product_list.dart';
import 'package:ffb_fe_flutter/app/modules/filter/views/widget/top_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/widget/bottom_nav.dart';
import '../../../resources/widget/custom_header.dart';
import '../../../routes/app_pages.dart';
import '../controllers/filter_controller.dart';

class FilterView extends GetView<FilterController> {
  const FilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const CustomHeader(),
      ),
      body: Column(
        children: const [
          FilterHeader(),
          TopTabBar(),
          Expanded(child: ProductList()),
        ],
      ),
      // Gọi BottomNav với initialIndex cố định (ví dụ: 1)
      bottomNavigationBar: const BottomNav(initialIndex: 1),
    );
  }
}

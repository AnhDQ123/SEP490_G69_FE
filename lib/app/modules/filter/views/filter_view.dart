// import 'package:ffb_fe_flutter/app/modules/filter/views/widget/filter_header.dart';
// import 'package:ffb_fe_flutter/app/modules/filter/views/widget/product_list.dart';
// import 'package:ffb_fe_flutter/app/modules/filter/views/widget/top_tab_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../resources/widget/bottom_nav.dart';
// import '../../../resources/widget/custom_header.dart';
// import '../../../routes/app_pages.dart';
// import '../controllers/filter_controller.dart';
//
// class FilterView extends GetView<FilterController> {
//   const FilterView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: const CustomHeader(),
//       ),
//       body: Column(
//         children: [
//           const FilterHeader(),  // Hiển thị header
//           const TopTabBar(),  // Hiển thị tab bar
//           Expanded(child: ProductList()),  // Hiển thị danh sách sản phẩm
//         ],
//       ),
//       bottomNavigationBar: const BottomNav(initialIndex: 1),  // Navigation bar
//     );
//   }
// }
//

import 'package:ffb_fe_flutter/app/modules/filter/views/widget/filter_header.dart';
import 'package:ffb_fe_flutter/app/modules/filter/views/widget/product_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/filter_controller.dart';

class FilterView extends StatelessWidget {
  final FilterController controller = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isSearch.value
              ? 'Tìm kiếm: ${controller.searchKeyword.value}'
              : controller.filterCategory.value.isNotEmpty
              ? 'Danh mục: ${controller.filterCategory.value}'
              : 'Tất cả sản phẩm',
        )),
      ),
      body: Column(
        children: [
          const FilterHeader(),
          Expanded(child: ProductList()),
        ],
      ),
    );
  }
}

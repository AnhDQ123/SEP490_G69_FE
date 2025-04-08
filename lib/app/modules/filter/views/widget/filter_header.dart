// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/filter_controller.dart';
//
// class FilterHeader extends GetView<FilterController> {
//   const FilterHeader({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       color: Colors.white,
//       child: Row(
//         children: [
//           OutlinedButton.icon(
//             icon: const Icon(Icons.filter_list, size: 20),
//             label: const Text(
//               "Bộ lọc",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.black,
//               side: const BorderSide(
//                   color: Color.fromRGBO(212, 163, 115, 1), width: 1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding:
//               const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             ),
//             onPressed: () {
//               // Xử lý sự kiện bộ lọc nếu cần
//             },
//           ),
//           const SizedBox(width: 12),
//           Obx(() {
//             if (controller.isSearch.value) {
//               final keyword = Get.arguments?['searchKeyword'] ?? '';
//               return Expanded( // 👈 Thêm dòng này để tránh tràn ngang
//                 child: Row(
//                   children: [
//                     const Icon(Icons.search, size: 18, color: Colors.grey),
//                     const SizedBox(width: 6),
//                     Expanded( // 👈 Và dòng này giúp Text tự co lại nếu quá dài
//                       child: Text(
//                         'Kết quả cho: "$keyword"',
//                         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//                         overflow: TextOverflow.ellipsis, // 👈 Không bị lỗi tràn
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             // Trường hợp có filter category
//             return controller.filterCategory.value.isNotEmpty
//                 ? Chip(
//               key: ValueKey(controller.filterCategory.value),
//               label: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     controller.filterCategory.value,
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                   const SizedBox(width: 4),
//                   GestureDetector(
//                     onTap: () => controller.removeCategoryFilter(),
//                     child: const Icon(Icons.close, size: 16),
//                   ),
//                 ],
//               ),
//               backgroundColor: const Color.fromRGBO(212, 163, 115, 1),
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             )
//                 : const SizedBox.shrink();
//           }),
//
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../controllers/filter_controller.dart';

class FilterHeader extends GetView<FilterController> {
  const FilterHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          // Nút bộ lọc
          OutlinedButton.icon(
            icon: const Icon(Icons.filter_list, size: 20),
            label: const Text("Bộ lọc"),
            onPressed: () => _showFilterDialog(),
          ),
          SizedBox(width: 12),

          // Hiển thị trạng thái hiện tại
          if (controller.isSearch.value)
            Expanded(
              child: Text(
                'Kết quả tìm kiếm: "${controller.searchKeyword.value}"',
                overflow: TextOverflow.ellipsis,
              ),
            )
          else if (controller.filterCategory.value.isNotEmpty)
            Chip(
              label: Row(
                children: [
                  Text(controller.filterCategory.value),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => controller.removeCategoryFilter(),
                    child: Icon(Icons.close, size: 16),
                  ),
                ],
              ),
              onDeleted: () => controller.removeCategoryFilter(),
            ),
        ],
      ),
    ));
  }

  void _showFilterDialog() {
    // Hiển thị dialog lọc
  }
}
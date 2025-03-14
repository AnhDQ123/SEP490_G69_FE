import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class CategorySection extends StatelessWidget {
  final HomeController controller;
  const CategorySection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                return InkWell(
                  onTap: () {
                    Get.toNamed('/filter', arguments: {'categoryName': category.name ?? 'No Name'});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: (category.image != null && category.image!.isNotEmpty)
                                ? NetworkImage(category.image!)
                                : const AssetImage('assets/images/default_category.png') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.name ?? 'No Name',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}

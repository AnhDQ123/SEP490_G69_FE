import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class CategorySection extends StatefulWidget {
  final HomeController controller;
  const CategorySection({Key? key, required this.controller}) : super(key: key);

  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      setState(() {
        _scrollPosition = (maxScroll == 0) ? 0 : (currentScroll / maxScroll);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = widget.controller.categoryList;
      if (categories.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      int rowCount = categories.length <= 5 ? 1 : 2;
      double cellHeight = 60;
      double sectionHeight = (cellHeight * rowCount) + 12 + 30;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Tiêu đề danh mục
          // ✅ Cập nhật phần tiêu đề danh mục
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.category, size: 20, color: Color.fromRGBO(212, 163, 115, 1)), // ✅ Thêm icon danh mục
                SizedBox(width: 6), // ✅ Tạo khoảng cách giữa icon và chữ
                Text(
                  'Danh mục',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),


          SizedBox(
            height: sectionHeight,
            child: GridView.count(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              crossAxisCount: rowCount,
              childAspectRatio: 1,
              mainAxisSpacing: 3,
              crossAxisSpacing: 6,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: categories.map((category) {
                return InkWell(
                  onTap: () {
                    Get.toNamed('/filter', arguments: {'categoryName': category.name ?? 'No Name'});
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              spreadRadius: 0.5,
                            ),
                          ],
                          image: DecorationImage(
                            image: (category.image != null && category.image!.isNotEmpty)
                                ? NetworkImage(category.image!)
                                : const AssetImage('assets/images/default_category.png') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category.name ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
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

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 4,
                  width: MediaQuery.of(context).size.width * 0.1,
                  color: Colors.grey.shade300,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: _scrollPosition,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(212, 163, 115, 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
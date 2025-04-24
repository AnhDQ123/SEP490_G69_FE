import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../resources/util_common.dart';
import '../../../routes/app_pages.dart';
import '../controllers/shop_product_list_controller.dart';

class ShopProductListView extends GetView<ShopProductListController> {
  final tabTitles = ["Còn hàng", "Hết hàng", "Chờ duyệt"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sản phẩm của tôi"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showSortDialog();  // Gọi hàm hiển thị dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(child: Obx(() => _buildProductList())),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.SHOP_ADD_PRODUCT);
              },
              child: Text("Thêm sản phẩm mới"),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (val) => controller.searchKeyword.value = val,
      ),
    );
  }

  Widget _buildTabBar() {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,  // Cho phép cuộn ngang
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(tabTitles.length, (index) {
          final isSelected = controller.selectedTab.value == index;
          String titleWithCount;

          // Cập nhật số lượng sản phẩm trong ngoặc
          switch (index) {
            case 0:
              titleWithCount = "${tabTitles[index]} (${controller.inStockCount})";
              break;
            case 1:
              titleWithCount = "${tabTitles[index]} (${controller.outOfStockCount})";
              break;
            case 2:
              titleWithCount = "${tabTitles[index]} (${controller.pendingCount})";
              break;
            default:
              titleWithCount = tabTitles[index];
          }

          return GestureDetector(
            onTap: () => controller.selectedTab.value = index,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6), // Giảm giãn cách
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!, // Border cho nút chưa chọn
                  width: 1.5,
                ),
              ),
              child: Text(
                titleWithCount,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600, // Cân đối về font weight
                  fontSize: 14, // Đảm bảo dễ đọc
                ),
              ),
            ),
          );
        }),
      ),
    ));
  }


  Widget _buildProductList() {
    final products = controller.filteredProducts;
    if (products.isEmpty) {
      return Center(child: Text("Không có sản phẩm nào"));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(UtilCommon.formatMoney(product.defaultPrice)),
                Text("Số lượng: ${product.quantity}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Truyền productId tới màn hình Add Product
                    Get.toNamed(Routes.SHOP_ADD_PRODUCT, arguments: product.id);
                  },
                ),

                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () async {
                    final confirmed = await Get.dialog<bool>(
                      AlertDialog(
                        title: Text("Xác nhận xoá"),
                        content: Text("Bạn có chắc chắn muốn xoá sản phẩm này không?"),
                        actions: [
                          TextButton(
                            child: Text("Huỷ"),
                            onPressed: () => Get.back(result: false),
                          ),
                          ElevatedButton(
                            child: Text("Xoá"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => Get.back(result: true),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      controller.deleteProductFromServer(product);
                    }
                  },

                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showSortDialog() {
    // Các tùy chọn sắp xếp
    final sortOptions = {
      'Mặc định': ProductSortType.none,
      'Tên A → Z': ProductSortType.nameAsc,
      'Tên Z → A': ProductSortType.nameDesc,
      'Giá trị tăng dần': ProductSortType.priceAsc,
      'Giá trị giảm dần': ProductSortType.priceDesc,
      'Số lượng tăng dần': ProductSortType.quantityAsc,
      'Số lượng giảm dần': ProductSortType.quantityDesc,
    };

    // Biến tạm để xử lý trong dialog
    ProductSortType tempSortType = controller.sortType.value;

    Get.defaultDialog(
      title: "Sắp xếp theo",
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text("📊 Chọn cách sắp xếp", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              // Dropdown cho sắp xếp
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: sortOptions.entries
                      .firstWhere((e) => e.value == tempSortType, orElse: () => MapEntry('Mặc định', ProductSortType.none))
                      .key,
                  underline: SizedBox(),
                  onChanged: (label) {
                    setState(() => tempSortType = sortOptions[label]!);
                  },
                  items: sortOptions.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              // Nút hành động
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text("Huỷ"),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Áp dụng kiểu sắp xếp đã chọn
                        controller.sortType.value = tempSortType;
                        controller.applySort(controller.filteredProducts); // Áp dụng sắp xếp
                        Get.back();
                      },
                      child: Text("Áp dụng"),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }


}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/product.dart';
import '../../../routes/app_pages.dart';
import '../controllers/product_list_shop_controller.dart';

class ProductListShopView extends GetView<ProductListShopController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm của tôi', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildSearchBar(),
            // _buildCategoryTabs(),
            Expanded(child: _buildProductList()),
            _buildAddProductButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm sản phẩm',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // Widget _buildCategoryTabs() {
  //   return Container(
  //     height: 50, // Đặt chiều cao cố định
  //     child: Obx(() {
  //       var statusCounts = controller.getStatusCounts();
  //       return SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: Row(
  //           children: [
  //             _buildCategoryTab('Còn hàng', statusCounts['available'] ?? 0, 'available'),
  //             _buildCategoryTab('Hết hàng', statusCounts['out_of_stock'] ?? 0, 'out_of_stock'),
  //             _buildCategoryTab('Chờ duyệt', statusCounts['pending'] ?? 0, 'pending'),
  //             _buildCategoryTab('Ngừng hoạt động', statusCounts['deactivated'] ?? 0, 'deactivated'),
  //           ],
  //         ),
  //       );
  //     }),
  //   );
  // }

  // Widget _buildCategoryTab(String title, int count, String status) {
  //   return GestureDetector(
  //     onTap: () {
  //       controller.selectedStatus.value = status; // Cập nhật trạng thái khi chọn
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 5),
  //       child: Chip(
  //         label: Text('$title ($count)'),
  //         backgroundColor: Colors.grey[200],
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildProductList() {
  //   return Obx(() {
  //     var filteredProducts = controller.products.where((product) {
  //       if (controller.selectedStatus.value == 'available' && product.status == 'active' && product.stockQuantity > 0) {
  //         return true;
  //       }
  //       if (controller.selectedStatus.value == 'out_of_stock' && product.status == 'active' && product.stockQuantity == 0) {
  //         return true;
  //       }
  //       if (controller.selectedStatus.value == 'pending' && product.status == 'pending') {
  //         return true;
  //       }
  //       if (controller.selectedStatus.value == 'deactivated' && product.status == 'deactivated') {
  //         return true;
  //       }
  //       return false;
  //     }).toList();
  //
  //     return ListView.builder(
  //       itemCount: filteredProducts.length,
  //       itemBuilder: (context, index) {
  //         final product = filteredProducts[index];
  //         return _buildProductItem(context, product, index);
  //       },
  //     );
  //   });
  // }

  Widget _buildProductList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (controller.products.isEmpty) {
        return Center(child: Text("Không có sản phẩm nào!"));
      }

      return ListView.builder(
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          return _buildProductItem(context, product, index);
        },
      );
    });
  }



  Widget _buildProductItem(BuildContext context, Product product, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm (Nếu có ảnh, hiển thị, nếu không hiển thị placeholder)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
                image: product.avatar != null
                    ? DecorationImage(
                  image: NetworkImage(product.avatar!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: product.avatar == null
                  ? Icon(Icons.image, size: 30, color: Colors.grey[600])
                  : null,
            ),
            SizedBox(width: 10),

            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name, // Sửa lại casing
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Số lượng: ${product.quantity}', // Sửa lại casing
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  if (product.discount != null) // Nếu có giảm giá, hiển thị
                    Text(
                      'Giảm giá: ${product.discount}%',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                ],
              ),
            ),

            // Nút chỉnh sửa & xoá
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 18),
                  onPressed: () {
                    Get.toNamed(Routes.PRODUCT_FORM, arguments: product.id);
                  },
                ),

                IconButton(
                  icon: Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: (){},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProductButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () => Get.toNamed(Routes.PRODUCT_FORM, arguments: null),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        child: Text('Thêm sản phẩm mới'),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
              SizedBox(height: 5), // Khoảng cách nhỏ hơn
              Text(
                "Lưu ý: Hành động này không thể hoàn tác!",
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng hộp thoại nếu chọn "Hủy"
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                // controller.deleteProduct(productId); // Xóa sản phẩm
                // Navigator.pop(context); // Đóng hộp thoại
              },
              child: Text("Xóa", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

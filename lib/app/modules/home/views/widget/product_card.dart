import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/product.dart';
import '../../../../resources/responsive_utils.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final int total;
  final bool isCompact;

  const ProductCard({
    Key? key,
    required this.product,
    required this.index,
    required this.total,
    this.isCompact = false,
  }) : super(key: key);

  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg";
    }
    if (imagePath.startsWith("http")) {
      return imagePath;
    } else {
      return "https://your-server-domain.com" + imagePath;
    }
  }


  @override
  Widget build(BuildContext context) {
    // Tăng kích thước của card để chứa ảnh lớn và text bên cạnh
    double cardWidth = isCompact ? UtilsReponsive.width(220, context) : UtilsReponsive.width(260, context);
    double cardHeight = isCompact ? UtilsReponsive.height(100, context) : UtilsReponsive.height(130, context);
    // Tăng kích thước ảnh
    double imageSize = isCompact ? UtilsReponsive.width(100, context) : UtilsReponsive.width(120, context);
    double fontSize = isCompact ? UtilsReponsive.formatFontSize(10, context) : UtilsReponsive.formatFontSize(12, context);

    return InkWell(
      onTap: () {
        Get.toNamed('/product-detail', arguments: product.id);
      },
      borderRadius: BorderRadius.circular(UtilsReponsive.width(6, context)),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: UtilsReponsive.paddingOnly(
          context,
          left: (index == 0) ? 12 : 6,
          right: (index == total - 1) ? 12 : 6,
        ),
        padding: UtilsReponsive.paddingAll(context, padding: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(UtilsReponsive.width(8, context)),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child:
        Row(
          children: [
            // Ảnh sản phẩm bên trái với kích thước lớn hơn
            ClipRRect(
              borderRadius: BorderRadius.circular(UtilsReponsive.width(6, context)),
              child: Image.network(
                getFullImageUrl(product.image),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/default_food.avif', fit: BoxFit.cover);
                },
              ),
            ),

            SizedBox(width: UtilsReponsive.width(20, context)),
            // Thông tin sản phẩm bên phải
            Expanded( // Thêm Expanded để phần thông tin chiếm phần còn lại
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tên sản phẩm
                  Text(
                    product.name ?? 'Tên sản phẩm',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: UtilsReponsive.height(4, context)),
                  // Row hiển thị rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: fontSize),
                      SizedBox(width: UtilsReponsive.width(2, context)),
                      Text(
                        product.rate != null ? product.rate!.toStringAsFixed(1) : '0.0',
                        style: TextStyle(
                          fontSize: fontSize - 1,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: UtilsReponsive.height(4, context)),
                  // Hiển thị số lượng đã bán
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Đã bán: ${product.quantity}",
                      style: TextStyle(
                        fontSize: fontSize - 1,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )

      ),
    );
  }
}
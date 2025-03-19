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
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith("http")) {
      return imagePath;
    } else {
      return "https://your-server-domain.com" + imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = isCompact ? UtilsReponsive.width(180, context) : UtilsReponsive.width(210, context);
    double cardHeight = isCompact ? UtilsReponsive.height(85, context) : UtilsReponsive.height(110, context);
    double imageSize = isCompact ? UtilsReponsive.width(70, context) : UtilsReponsive.width(80, context);
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
        ), // ✅ Responsive margin
        padding: UtilsReponsive.paddingAll(context, padding: 8), // ✅ Responsive padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(UtilsReponsive.width(8, context)), // ✅ Responsive border radius
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Row(
          children: [
            // Ảnh sản phẩm (Bên trái)
            ClipRRect(
              borderRadius: BorderRadius.circular(UtilsReponsive.width(6, context)),
              child: Image.network(
                getFullImageUrl(product.image),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            SizedBoxConst.sizeWith(context: context, size: 10), // ✅ Responsive spacing

            // Thông tin sản phẩm (Bên phải)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Tên sản phẩm
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

                  SizedBoxConst.size(context: context, size: 4), // 🔹 Responsive spacing

                  // ✅ Row hiển thị rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: fontSize),
                      SizedBoxConst.sizeWith(context: context, size: 2),
                      Text(
                        product.rate != null ? product.rate!.toStringAsFixed(1) : '0.0',
                        style: TextStyle(
                          fontSize: fontSize - 1,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  SizedBoxConst.size(context: context, size: 4), // 🔹 Responsive spacing

                  // ✅ `Đã bán` luôn nằm dưới `Rate`
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
        ),
      ),
    );
  }
}

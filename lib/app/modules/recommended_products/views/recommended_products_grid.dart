import 'package:ffb_fe_flutter/app/modules/recommended_products/views/recommended_product_item.dart';
import 'package:flutter/material.dart';
import '../../../models/product.dart';

class RecommendedProductsGrid extends StatelessWidget {
  final List<Product> products;

  const RecommendedProductsGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return RecommendedProductItem(product: product);
      },
    );
  }
}

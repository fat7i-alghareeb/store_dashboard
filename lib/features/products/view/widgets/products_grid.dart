import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/features/products/data/models/product_summary_item.dart';
import 'package:store_dashboard/features/products/view/widgets/product_card.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key, required this.items});

  final List<ProductSummaryItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 340,
        mainAxisExtent: 240,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final p = items[index];
        return ProductCard(
          title: p.title,
          imageUrl: p.derivedMainImageUrl,
        )
            .animate()
            .fadeIn(duration: 180.ms, delay: (index * 20).ms)
            .slideY(begin: 0.06, end: 0);
      },
    );
  }
}

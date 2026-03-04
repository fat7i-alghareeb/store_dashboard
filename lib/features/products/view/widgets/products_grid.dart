import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/features/products/data/models/product_summary_item.dart';
import 'package:store_dashboard/features/products/view/widgets/product_card.dart';
import 'package:store_dashboard/features/products/view/widgets/products_body.dart';
import 'package:store_dashboard/features/products/viewmodel/products_cubit.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';
import 'package:store_dashboard/core/widgets/app_notifier.dart';

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
              onEdit: () => ProductsBody.openEditDialog(context, product: p),
              onDelete: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(AppStrings.confirmDelete),
                    content: Text(AppStrings.areYouSureDeleteProduct),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(AppStrings.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(AppStrings.delete),
                      ),
                    ],
                  ),
                );
                if (confirmed != true || !context.mounted) return;
                await context.read<ProductsCubit>().deleteProductFull(
                  productId: p.id,
                );
                if (context.mounted) {
                  AppNotifier.success(
                    context,
                    AppStrings.productDeletedSuccessfully,
                  );
                }
              },
            )
            .animate()
            .fadeIn(duration: 180.ms, delay: (index * 20).ms)
            .slideY(begin: 0.06, end: 0);
      },
    );
  }
}

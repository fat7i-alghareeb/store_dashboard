import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/features/products/view/widgets/upsert_product_dialog.dart';
import 'package:store_dashboard/features/products/view/widgets/products_error_state.dart';
import 'package:store_dashboard/features/products/view/widgets/products_grid.dart';
import 'package:store_dashboard/features/products/viewmodel/products_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/status_builder.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class ProductsBody extends StatelessWidget {
  const ProductsBody({super.key});

  static Future<void> openCreateDialog(BuildContext context) async {
    final cubit = context.read<ProductsCubit>();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const UpsertProductDialog()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        return StatusBuilder(
          state: state.productsStatus,
          loading: () => const Center(child: CircularProgressIndicator()),
          failure: (message) => ProductsErrorState(
            message: message,
            onRetry: () => context.read<ProductsCubit>().loadProducts(),
          ),
          onError: () => context.read<ProductsCubit>().loadProducts(),
          success: (items) {
            if (items.isEmpty) {
              return Center(child: Text(AppStrings.noProductsFound));
            }

            return ProductsGrid(items: items);
          },
        );
      },
    );
  }
}

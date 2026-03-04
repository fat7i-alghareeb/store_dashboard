import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/features/products/view/widgets/products_body.dart';
import 'package:store_dashboard/features/products/view/widgets/products_header.dart';
import 'package:store_dashboard/features/products/viewmodel/products_cubit.dart';
import 'package:store_dashboard/utils/services/injection/injectable.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final ProductsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProductsCubit>();
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductsHeader(
                onAdd: () => ProductsBody.openCreateDialog(context),
              ),
              Expanded(child: ProductsBody(state: state)),
            ],
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.01, end: 0);
        },
      ),
    );
  }
}

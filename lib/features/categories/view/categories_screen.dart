import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/features/categories/data/models/category_item.dart';
import 'package:store_dashboard/features/categories/viewmodel/categories_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';
import 'package:store_dashboard/utils/services/injection/injectable.dart';

import 'widgets/categories_body.dart';
import 'widgets/upsert_category_dialog.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late final CategoriesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CategoriesCubit>();
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesCubit>.value(
      value: _cubit,
      child: BlocListener<CategoriesCubit, CategoriesState>(
        listenWhen: (prev, next) => prev.actionStatus != next.actionStatus,
        listener: (context, state) {
          state.actionStatus.maybeWhen(
            success: (_) {
              context.read<CategoriesCubit>().clearActionStatus();
            },
            orElse: () {},
          );
        },
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            return state.categoriesStatus.when(
              initial: () => const _LoadingBody(),
              loading: () => const _LoadingBody(),
              failure: (message) => _ErrorBody(
                message: message,
                onRetry: () => context.read<CategoriesCubit>().load(),
              ),
              success: (items) {
                return CategoriesBody(
                  items: items,
                  actionStatus: state.actionStatus,
                  onRefresh: () => context.read<CategoriesCubit>().refresh(),
                  onAdd: () => _openUpsertDialog(context),
                  onEdit: (item) => _openUpsertDialog(context, editing: item),
                  onDelete: (item) => _confirmDelete(context, item),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, CategoryItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.confirmDelete),
        content: Text(AppStrings.areYouSureDeleteCategory),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<CategoriesCubit>().delete(id: item.id);
    }
  }

  Future<void> _openUpsertDialog(
    BuildContext context, {
    CategoryItem? editing,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<CategoriesCubit>.value(
        value: context.read<CategoriesCubit>(),
        child: UpsertCategoryDialog(editing: editing),
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: Text(AppStrings.retry)),
            ],
          ),
        ),
      ),
    );
  }
}

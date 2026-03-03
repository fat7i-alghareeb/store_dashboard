import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/core/theme/app_text_styles.dart';
import 'package:store_dashboard/features/categories/data/models/category_item.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

import 'category_card.dart';

class CategoriesBody extends StatelessWidget {
  const CategoriesBody({
    super.key,
    required this.items,
    required this.actionStatus,
    required this.onRefresh,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CategoryItem> items;
  final BlocStatus<void> actionStatus;
  final Future<void> Function() onRefresh;
  final VoidCallback onAdd;
  final ValueChanged<CategoryItem> onEdit;
  final ValueChanged<CategoryItem> onDelete;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final crossAxisCount = switch (width) {
      >= 1600 => 6,
      >= 1300 => 5,
      >= 1050 => 4,
      >= 800 => 3,
      _ => 2,
    };

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.categoryManager,
                          style: AppTextStyles.s18w600,
                        ),
                      ),
                      FilledButton(
                        onPressed: actionStatus.isLoading ? null : onAdd,
                        child: Text(AppStrings.addCategory),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 180.ms).slideY(begin: -0.2, end: 0),
              ),
              if (items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(AppStrings.noCategoriesFound)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CategoryCard(
                        item: item,
                        onEdit: () => onEdit(item),
                        onDelete: () => onDelete(item),
                      )
                          .animate()
                          .fadeIn(delay: (30 * index).ms, duration: 160.ms)
                          .slideY(
                            begin: 0.08,
                            end: 0,
                            delay: (30 * index).ms,
                            duration: 420.ms,
                            curve: Curves.easeOutCubic,
                          );
                    },
                  ),
                ),
            ],
          ),
        ),
        if (actionStatus.isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}

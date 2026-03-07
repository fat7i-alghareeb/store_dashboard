import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:store_dashboard/features/categories/data/models/category_item.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class ProductInfoPane extends StatelessWidget {
  const ProductInfoPane({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descController,
    required this.priceController,
    required this.sizeController,
    required this.sizes,
    required this.enabled,
    required this.categoriesStatus,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.isTrending,
    required this.onTrendingChanged,
    required this.onAddSize,
    required this.onRemoveSize,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController priceController;
  final TextEditingController sizeController;
  final List<String> sizes;
  final bool enabled;
  final BlocStatus<List<CategoryItem>> categoriesStatus;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategoryChanged;
  final bool isTrending;
  final ValueChanged<bool> onTrendingChanged;
  final VoidCallback onAddSize;
  final ValueChanged<int> onRemoveSize;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.productInfo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: titleController,
              enabled: enabled,
              decoration: InputDecoration(labelText: AppStrings.productName),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? AppStrings.pleaseEnterProductName
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: priceController,
              enabled: enabled,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d*\.?\d*')),
              ],
              decoration: InputDecoration(labelText: AppStrings.price),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return AppStrings.pleaseEnterPrice;
                }
                final price = double.tryParse(v.trim());
                if (price == null) {
                  return AppStrings.pleaseEnterValidPrice;
                }
                if (price < 0) {
                  return AppStrings.priceCannotBeNegative;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descController,
              enabled: enabled,
              maxLines: 4,
              decoration: InputDecoration(labelText: AppStrings.description),
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              value: isTrending,
              onChanged: enabled ? onTrendingChanged : null,
              title: Text(AppStrings.isTrending),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
            categoriesStatus.maybeWhen(
              loading: () => const LinearProgressIndicator(minHeight: 2),
              success: (items) {
                return DropdownButtonFormField<int>(
                  initialValue: selectedCategoryId,
                  items: items
                      .map(
                        (c) => DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(
                            c.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: enabled ? onCategoryChanged : null,
                  decoration: InputDecoration(
                    labelText: AppStrings.selectCategory,
                  ),
                  validator: (v) =>
                      v == null ? AppStrings.pleaseSelectACategory : null,
                );
              },
              orElse: () => DropdownButtonFormField<int>(
                initialValue: selectedCategoryId,
                items: const [],
                onChanged: enabled ? onCategoryChanged : null,
                decoration: InputDecoration(
                  labelText: AppStrings.selectCategory,
                ),
                validator: (v) =>
                    v == null ? AppStrings.pleaseSelectACategory : null,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              AppStrings.sizes,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: sizeController,
                    enabled: enabled,
                    decoration: InputDecoration(
                      labelText: AppStrings.sizeLabel,
                      hintText: AppStrings.sizeExample,
                    ),
                    onFieldSubmitted: (_) => onAddSize(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: enabled ? onAddSize : null,
                  child: Text(AppStrings.add),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (sizes.isEmpty)
              Text(
                AppStrings.noSizesAdded,
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(sizes.length, (i) {
                  return InputChip(
                    label: Text(sizes[i]),
                    onDeleted: enabled ? () => onRemoveSize(i) : null,
                  );
                }),
              ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

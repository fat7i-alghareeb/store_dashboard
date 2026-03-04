import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/products/data/models/product_color.dart';
import 'package:store_dashboard/features/products/viewmodel/products_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

import 'upsert_product/add_color_dialog.dart';
import 'upsert_product/pick_images_dialog.dart';
import 'upsert_product/product_info_pane.dart';
import 'upsert_product/variant_draft.dart';
import 'upsert_product/variants_pane.dart';

class UpsertProductDialog extends StatefulWidget {
  const UpsertProductDialog({super.key});

  @override
  State<UpsertProductDialog> createState() => _UpsertProductDialogState();
}

class _UpsertProductDialogState extends State<UpsertProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();

  bool _submitting = false;

  int? _categoryId;

  ProductColor? _selectedColor;
  final List<File> _images = <File>[];
  final List<VariantDraft> _variants = <VariantDraft>[];
  int? _editingVariantIndex;

  final List<String> _sizes = <String>[];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedColor == null) {
      AppNotifier.error(context, AppStrings.addImagesAfterColor);
      return;
    }

    final picked = await openPickImagesDialog(context);
    if (picked.isNotEmpty) {
      setState(() => _images.addAll(picked));
    }
  }

  Future<void> _openAddColorDialog() async {
    final cubit = context.read<ProductsCubit>();
    await openAddColorDialog(context: context, cubit: cubit);
  }

  void _selectVariantForEdit(int index) {
    final v = _variants[index];
    setState(() {
      _editingVariantIndex = index;
      _selectedColor = v.color;
      _images
        ..clear()
        ..addAll(v.images);
    });
  }

  void _saveVariantDraft() {
    final c = _selectedColor;
    if (c == null) {
      AppNotifier.error(context, AppStrings.pleaseSelectAColor);
      return;
    }

    final existingIndex = _variants.indexWhere((v) => v.color.id == c.id);

    if (_editingVariantIndex == null && existingIndex != -1) {
      AppNotifier.error(context, AppStrings.colorVariantAlreadyAdded);
      return;
    }

    if (_images.isEmpty) {
      AppNotifier.error(context, AppStrings.pleaseSelectAtLeastOneImage);
      return;
    }

    setState(() {
      final updated = VariantDraft(color: c, images: List<File>.from(_images));

      final targetIndex = _editingVariantIndex ?? existingIndex;
      if (targetIndex >= 0) {
        _variants[targetIndex] = updated;
      } else {
        _variants.add(updated);
      }

      _editingVariantIndex = null;
      _selectedColor = null;
      _images.clear();
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    if (_variants.isEmpty) {
      AppNotifier.error(context, AppStrings.pleaseSelectAColor);
      return;
    }

    final price = num.tryParse(_priceController.text.trim());
    if (price == null) {
      AppNotifier.error(context, AppStrings.pleaseEnterPrice);
      return;
    }

    final categoryId = _categoryId;
    if (categoryId == null) {
      AppNotifier.error(context, AppStrings.pleaseSelectACategory);
      return;
    }

    setState(() => _submitting = true);
    try {
      await context.read<ProductsCubit>().createProduct(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: price,
        categoryId: categoryId,
        isSpecial: false,
        isTrending: false,
        sizes: List<String>.from(_sizes),
        variants: _variants
            .map(
              (v) => CreateProductVariant(
                colorId: v.color.id,
                images: List<File>.from(v.images),
              ),
            )
            .toList(growable: false),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listenWhen: (p, n) => p.actionStatus != n.actionStatus,
      listener: (context, state) {
        state.actionStatus.maybeWhen(
          success: (_) async {
            // Wait for loadProducts to complete before closing dialog
            await context.read<ProductsCubit>().loadProducts();
            if (context.mounted) {
              context.read<ProductsCubit>().clearActionStatus();
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          failure: (message) {
            AppNotifier.error(context, message);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final saving = state.actionStatus.isLoading || _submitting;

        return PopScope(
          canPop: !saving,
          child: AlertDialog(
            title: Text(AppStrings.addNewProduct),
            content: SizedBox(
              width: 980,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ProductInfoPane(
                      formKey: _formKey,
                      titleController: _titleController,
                      descController: _descController,
                      priceController: _priceController,
                      sizeController: _sizeController,
                      sizes: _sizes,
                      enabled: !saving,
                      categoriesStatus: state.categoriesStatus,
                      onCategoryChanged: (v) => setState(() => _categoryId = v),
                      onAddSize: () {
                        final v = _sizeController.text.trim();
                        if (v.isEmpty) return;
                        if (_sizes.any(
                          (s) => s.toLowerCase() == v.toLowerCase(),
                        )) {
                          return;
                        }
                        setState(() {
                          _sizes.add(v);
                          _sizeController.clear();
                        });
                      },
                      onRemoveSize: (index) {
                        setState(() => _sizes.removeAt(index));
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: VariantsPane(
                      enabled: !saving,
                      selectedColor: _selectedColor,
                      images: _images,
                      variants: _variants,
                      colorsStatus: state.colorsStatus,
                      onSelectColor: (c) => setState(() {
                        _editingVariantIndex = null;
                        _selectedColor = c;
                        _images.clear();
                      }),
                      onSelectVariant: _selectVariantForEdit,
                      onAddColor: _openAddColorDialog,
                      onPickImages: _pickImages,
                      onAddVariant: _saveVariantDraft,
                      onRemoveVariant: (index) {
                        setState(() => _variants.removeAt(index));
                      },
                      onRemoveImage: (index) =>
                          setState(() => _images.removeAt(index)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.of(context).pop(),
                child: Text(AppStrings.cancel),
              ),
              FilledButton(
                onPressed: saving ? null : _submit,
                child: Text(AppStrings.submitProduct),
              ),
            ],
          ).animate().fadeIn(duration: 180.ms).slideY(begin: 0.03, end: 0),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/core/widgets/app_image_picker.dart';
import 'package:store_dashboard/features/categories/data/models/category_item.dart';
import 'package:store_dashboard/features/categories/viewmodel/categories_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class UpsertCategoryDialog extends StatefulWidget {
  const UpsertCategoryDialog({super.key, this.editing});

  final CategoryItem? editing;

  @override
  State<UpsertCategoryDialog> createState() => _UpsertCategoryDialogState();
}

class _UpsertCategoryDialogState extends State<UpsertCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  File? _pickedImage;

  bool get _isEdit => widget.editing != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.editing?.title ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();

    if (!_isEdit && _pickedImage == null) {
      AppNotifier.error(context, AppStrings.pleaseSelectAnImage);
      return;
    }

    if (_isEdit) {
      await context.read<CategoriesCubit>().update(
        id: widget.editing!.id,
        title: title,
        image: _pickedImage,
      );
    } else {
      await context.read<CategoriesCubit>().create(
        title: title,
        image: _pickedImage!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listenWhen: (p, n) => p.actionStatus != n.actionStatus,
      listener: (context, state) {
        state.actionStatus.maybeWhen(
          success: (_) {
            context.read<CategoriesCubit>().clearActionStatus();
            Navigator.of(context).pop();
          },
          failure: (message) {
            AppNotifier.error(context, message);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final saving = state.actionStatus.isLoading;

        return PopScope(
          canPop: !saving,
          child: AlertDialog(
            title: Text(
              _isEdit ? AppStrings.editCategory : AppStrings.addCategory,
            ),
            content: SizedBox(
              width: 520,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (saving)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                    TextFormField(
                      controller: _titleController,
                      enabled: !saving,
                      decoration: InputDecoration(
                        labelText: AppStrings.categoryName,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? AppStrings.pleaseEnterCategoryName
                          : null,
                    ),
                    const SizedBox(height: 14),
                    AppImagePicker(
                      pickLabel: AppStrings.pickImage,
                      emptyLabel: AppStrings.noImageSelected,
                      enabled: !saving,
                      initialImageUrl: widget.editing?.imageUrl,
                      showClear: true,
                      onChanged: (file) => setState(() => _pickedImage = file),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.of(context).pop(),
                child: Text(AppStrings.cancel),
              ),
              FilledButton(
                onPressed: saving ? null : () => _submit(context),
                child: Text(
                  _isEdit ? AppStrings.save : AppStrings.submitCategory,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 160.ms).slideY(begin: 0.03, end: 0),
        );
      },
    );
  }
}

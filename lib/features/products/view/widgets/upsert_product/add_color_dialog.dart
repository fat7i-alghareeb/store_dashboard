import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/products/viewmodel/products_cubit.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

import 'color_utils.dart';

Future<void> openAddColorDialog({
  required BuildContext context,
  required ProductsCubit cubit,
}) async {
  final nameController = TextEditingController();
  Color picked = Colors.blue;

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(AppStrings.addNewColor),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: AppStrings.colorName),
              ),
              const SizedBox(height: 14),
              ColorPicker(
                color: picked,
                onColorChanged: (c) => picked = c,
                pickersEnabled: const {
                  ColorPickerType.primary: true,
                  ColorPickerType.accent: true,
                  ColorPickerType.bw: true,
                  ColorPickerType.wheel: true,
                },
                enableOpacity: false,
                showColorCode: true,
                colorCodeHasColor: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final title = nameController.text.trim();
              if (title.isEmpty) {
                AppNotifier.error(ctx, AppStrings.pleaseEnterProductName);
                return;
              }

              final hex = toHexRgb(picked);
              await cubit.createColor(title: title, hexCode: hex);

              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: Text(AppStrings.save),
          ),
        ],
      ).animate().fadeIn(duration: 180.ms).slideY(begin: 0.04, end: 0);
    },
  );
}

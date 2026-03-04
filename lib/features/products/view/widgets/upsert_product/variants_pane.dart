import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/features/products/data/models/product_color.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

import 'color_utils.dart';
import 'variant_draft.dart';

class VariantsPane extends StatelessWidget {
  const VariantsPane({
    super.key,
    required this.enabled,
    required this.selectedColor,
    required this.images,
    required this.variants,
    required this.colorsStatus,
    required this.onSelectColor,
    required this.onSelectVariant,
    required this.onAddColor,
    required this.onPickImages,
    required this.onAddVariant,
    required this.onRemoveVariant,
    required this.onRemoveImage,
    required this.onMoveImageLeft,
    required this.onMoveImageRight,
  });

  final bool enabled;
  final ProductColor? selectedColor;
  final List<VariantImageDraft> images;
  final List<VariantDraft> variants;
  final BlocStatus<List<ProductColor>> colorsStatus;
  final ValueChanged<ProductColor?> onSelectColor;
  final ValueChanged<int> onSelectVariant;
  final VoidCallback onAddColor;
  final VoidCallback onPickImages;
  final VoidCallback onAddVariant;
  final ValueChanged<int> onRemoveVariant;
  final ValueChanged<int> onRemoveImage;
  final ValueChanged<int> onMoveImageLeft;
  final ValueChanged<int> onMoveImageRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasSelectedColor = selectedColor != null;
    final hasImages = images.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header - fixed at top
        Text(
          AppStrings.variantsAndImages,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ========== ADDED VARIANTS LIST (at top) ==========
                if (variants.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 20, color: scheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppStrings.addedVariants.replaceAll(
                            '{count}',
                            '${variants.length}',
                          ),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(variants.length, (i) {
                      final v = variants[i];
                      return _VariantChip(
                        variant: v,
                        onSelect: () => onSelectVariant(i),
                        onRemove: () => onRemoveVariant(i),
                        enabled: enabled,
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                ],

                // ========== STEP 1: SELECT COLOR ==========
                _StepCard(
                  stepNumber: 1,
                  title: AppStrings.step1SelectColor,
                  isActive: true,
                  isComplete: hasSelectedColor,
                  scheme: scheme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.step1SelectColorHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      colorsStatus.maybeWhen(
                        loading: () =>
                            const LinearProgressIndicator(minHeight: 2),
                        success: (colors) {
                          ProductColor? resolvedSelected;
                          final sel = selectedColor;
                          if (sel != null) {
                            for (final c in colors) {
                              if (c.id == sel.id) {
                                resolvedSelected = c;
                                break;
                              }
                            }
                          }
                          return DropdownButtonFormField<ProductColor>(
                            initialValue: resolvedSelected,
                            isExpanded: true,
                            items: colors
                                .map(
                                  (c) => DropdownMenuItem<ProductColor>(
                                    value: c,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color:
                                                hexToColor(c.hexCode) ??
                                                scheme.primary,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: scheme.outline,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            c.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: enabled ? onSelectColor : null,
                            decoration: InputDecoration(
                              labelText: AppStrings.selectColor,
                              hintText: AppStrings.selectColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: enabled ? onAddColor : null,
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                          label: Text(AppStrings.addNewColor),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ========== STEP 2: ADD IMAGES ==========
                _StepCard(
                  stepNumber: 2,
                  title: AppStrings.step2AddImages,
                  isActive: hasSelectedColor,
                  isComplete: hasImages,
                  scheme: scheme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.step2AddImagesHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Images Grid
                      if (hasImages) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: scheme.outlineVariant),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.photo_library_outlined,
                                    size: 18,
                                    color: scheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppStrings.imagesCount.replaceAll(
                                      '{count}',
                                      '${images.length}',
                                    ),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(images.length, (i) {
                                  final f = images[i];
                                  return _ImageThumbnail(
                                    image: f,
                                    onRemove: () => onRemoveImage(i),
                                    canMoveLeft: i > 0,
                                    canMoveRight: i < images.length - 1,
                                    onMoveLeft: () => onMoveImageLeft(i),
                                    onMoveRight: () => onMoveImageRight(i),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Add Another Image Button (prominent)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: enabled ? onPickImages : null,
                            icon: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 20,
                            ),
                            label: Text(AppStrings.addImage),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ] else
                        // Empty State
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: scheme.outlineVariant),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: scheme.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                hasSelectedColor
                                    ? AppStrings.noImagesSelected
                                    : AppStrings.addImagesAfterColor,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: hasSelectedColor && enabled
                                    ? onPickImages
                                    : null,
                                icon: const Icon(Icons.add, size: 18),
                                label: Text(AppStrings.addImage),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ========== STEP 3: SAVE VARIANT ==========
                _StepCard(
                  stepNumber: 3,
                  title: AppStrings.step3ConfirmVariant,
                  isActive: hasSelectedColor && hasImages,
                  isComplete: false,
                  scheme: scheme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.step3ConfirmVariantHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: (hasSelectedColor && hasImages && enabled)
                              ? onAddVariant
                              : null,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 20,
                          ),
                          label: Text(AppStrings.saveThisVariant),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReorderButton extends StatelessWidget {
  const _ReorderButton({
    required this.enabled,
    required this.tooltip,
    required this.icon,
    required this.onTap,
    required this.scheme,
  });

  final bool enabled;
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: enabled ? 0.55 : 0.25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: enabled
                  ? scheme.outlineVariant.withValues(alpha: 0.35)
                  : scheme.outlineVariant.withValues(alpha: 0.15),
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: Colors.white.withValues(alpha: enabled ? 1 : 0.6),
          ),
        ),
      ),
    );
  }
}

// ==================== HELPER WIDGETS ====================

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.isActive,
    required this.isComplete,
    required this.scheme,
    required this.child,
  });

  final int stepNumber;
  final String title;
  final bool isActive;
  final bool isComplete;
  final ColorScheme scheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive
        ? scheme.surface
        : scheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final borderColor = isComplete
        ? scheme.primary.withValues(alpha: 0.5)
        : isActive
        ? scheme.outline
        : scheme.outlineVariant;

    return Opacity(
      opacity: isActive ? 1.0 : 0.6,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: isActive ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isComplete
                        ? scheme.primary
                        : isActive
                        ? scheme.primaryContainer
                        : scheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isComplete
                        ? Icon(Icons.check, size: 16, color: scheme.onPrimary)
                        : Text(
                            '$stepNumber',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? scheme.onPrimaryContainer
                                  : scheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    ).animate(target: isActive ? 1 : 0).fadeIn(duration: 200.ms);
  }
}

class _ImageThumbnail extends StatelessWidget {
  const _ImageThumbnail({
    required this.image,
    required this.onRemove,
    required this.canMoveLeft,
    required this.canMoveRight,
    required this.onMoveLeft,
    required this.onMoveRight,
  });

  final VariantImageDraft image;
  final VoidCallback onRemove;
  final bool canMoveLeft;
  final bool canMoveRight;
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(context),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Row(
                children: [
                  _ReorderButton(
                    enabled: canMoveLeft,
                    tooltip: AppStrings.moveImageLeft,
                    icon: Icons.chevron_left,
                    onTap: onMoveLeft,
                    scheme: scheme,
                  ),
                  const SizedBox(width: 4),
                  _ReorderButton(
                    enabled: canMoveRight,
                    tooltip: AppStrings.moveImageRight,
                    icon: Icons.chevron_right,
                    onTap: onMoveRight,
                    scheme: scheme,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: onRemove,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 150.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildImage(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final f = image.file;
    final url = image.url;

    if (f != null) {
      return Image.file(f, width: 80, height: 80, fit: BoxFit.cover);
    }

    if (url == null || url.trim().isEmpty) {
      return Container(
        width: 80,
        height: 80,
        color: scheme.surface,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: scheme.onSurface.withValues(alpha: 0.55),
        ),
      );
    }

    return Image.network(
      url,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 80,
        height: 80,
        color: scheme.surface,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          color: scheme.onSurface.withValues(alpha: 0.55),
        ),
      ),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: 80,
          height: 80,
          color: scheme.surface,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({
    required this.variant,
    required this.onSelect,
    required this.onRemove,
    required this.enabled,
  });

  final VariantDraft variant;
  final VoidCallback onSelect;
  final VoidCallback onRemove;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: enabled ? onSelect : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: hexToColor(variant.color.hexCode) ?? scheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.outline, width: 1),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '${variant.color.title} (${variant.images.length})',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: enabled ? onRemove : null,
              child: Icon(
                Icons.close,
                size: 16,
                color: enabled
                    ? scheme.onSurfaceVariant
                    : scheme.onSurfaceVariant.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 150.ms).slideX(begin: -0.1, end: 0);
  }
}

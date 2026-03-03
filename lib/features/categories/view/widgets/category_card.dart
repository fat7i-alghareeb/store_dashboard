import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:store_dashboard/core/theme/app_text_styles.dart';
import 'package:store_dashboard/features/categories/data/models/category_item.dart';
import 'package:store_dashboard/features/shared/widgets/app_image_viewer.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final CategoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hovered = _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.01 : 1,
        duration: 140.ms,
        curve: Curves.easeOut,
        child: AnimatedPhysicalModel(
          duration: 160.ms,
          curve: Curves.easeOut,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          elevation: hovered ? 10 : 0,
          shadowColor: Colors.black,
          color: scheme.surfaceContainerHighest,
          child: Material(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onEdit,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _CategoryImage(
                          imageUrl: widget.item.imageUrl,
                          hovered: hovered,
                        ),
                        AnimatedOpacity(
                          opacity: hovered ? 1 : 0,
                          duration: 140.ms,
                          child: IgnorePointer(
                            ignoring: !hovered,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _CardIconButton(
                                      tooltip: AppStrings.edit,
                                      icon: FontAwesomeIcons.penToSquare,
                                      onPressed: widget.onEdit,
                                    ),
                                    const SizedBox(width: 8),
                                    _CardIconButton(
                                      tooltip: AppStrings.delete,
                                      icon: FontAwesomeIcons.trashCan,
                                      onPressed: widget.onDelete,
                                      danger: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: AnimatedOpacity(
                            opacity: hovered ? 1 : 0,
                            duration: 160.ms,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.55),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.s14w600.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryImage extends StatelessWidget {
  const _CategoryImage({required this.imageUrl, required this.hovered});

  final String imageUrl;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final hasUrl = imageUrl.trim().isNotEmpty;

    final child = hasUrl
        ? AppImageViewer.network(
            imageUrl,
            enableFullScreen: false,
            borderRadius: 0,
            noShadow: true,
            loading: AppImageViewerLoading.shimmer,
          )
        : const _ImageFallback();

    return AnimatedScale(
      scale: hovered ? 1.05 : 1,
      duration: 260.ms,
      curve: Curves.easeOutCubic,
      child: child,
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surface,
      alignment: Alignment.center,
      child: FaIcon(
        FontAwesomeIcons.image,
        color: scheme.onSurface.withValues(alpha: 0.6),
        size: 18,
      ),
    );
  }
}

class _CardIconButton extends StatelessWidget {
  const _CardIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.danger = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.surface.withValues(alpha: 0.75);
    final fg = danger ? const Color(0xFFB3261E) : scheme.onSurface;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Center(child: FaIcon(icon, size: 16, color: fg)),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: widget.imageUrl.trim().isEmpty
                                ? Container(
                                    color: scheme.surface,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.image_outlined,
                                      color: scheme.onSurface.withValues(
                                        alpha: 0.55,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    widget.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: scheme.surface,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                                color: scheme.onSurface
                                                    .withValues(alpha: 0.55),
                                              ),
                                            ),
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Container(
                                        color: scheme.surface,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            value:
                                                progress.expectedTotalBytes ==
                                                    null
                                                ? null
                                                : progress.cumulativeBytesLoaded /
                                                      progress
                                                          .expectedTotalBytes!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                                        icon: Icons.edit_outlined,
                                        onPressed: widget.onEdit,
                                      ),
                                      const SizedBox(width: 8),
                                      _CardIconButton(
                                        tooltip: AppStrings.delete,
                                        icon: Icons.delete_outline,
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
                    const SizedBox(height: 10),
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
            child: Center(child: Icon(icon, size: 18, color: fg)),
          ),
        ),
      ),
    );
  }
}

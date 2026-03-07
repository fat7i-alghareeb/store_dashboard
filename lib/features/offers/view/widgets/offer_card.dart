import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';

class OfferCard extends StatefulWidget {
  const OfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.active,
    required this.onEdit,
    required this.onDelete,
    required this.onAssignProducts,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final bool active;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAssignProducts;

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hovered = _hovered;

    final hasImage = widget.imageUrl.trim().isNotEmpty;

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
                            child: !hasImage
                                ? Container(
                                    color: scheme.surface,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.local_offer_outlined,
                                      color: scheme.onSurface.withValues(
                                        alpha: 0.55,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    widget.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      color: scheme.surface,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: scheme.onSurface.withValues(
                                          alpha: 0.55,
                                        ),
                                      ),
                                    ),
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Container(
                                        color: scheme.surface,
                                        alignment: Alignment.center,
                                        child: const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
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
                                  child: Wrap(
                                    spacing: 8,
                                    children: [
                                      _CardIconButton(
                                        tooltip: AppStrings.assignProducts,
                                        icon: Icons.playlist_add_check_rounded,
                                        onPressed: widget.onAssignProducts,
                                      ),
                                      _CardIconButton(
                                        tooltip: AppStrings.edit,
                                        icon: Icons.edit_outlined,
                                        onPressed: widget.onEdit,
                                      ),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _StatusPill(active: widget.active),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = active
        ? scheme.primary.withValues(alpha: 0.14)
        : scheme.error.withValues(alpha: 0.14);
    final fg = active ? scheme.primary : scheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Text(
        active ? AppStrings.active : AppStrings.inactive,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 11,
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
  final VoidCallback? onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bg = danger
        ? scheme.error.withValues(alpha: 0.16)
        : scheme.surface.withValues(alpha: 0.75);
    final fg = danger ? scheme.error : scheme.onSurface;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Icon(icon, size: 18, color: fg),
        ),
      ),
    );
  }
}

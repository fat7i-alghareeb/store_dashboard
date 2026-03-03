import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum AppNoticeType { info, success, warning, error }

class AppNotifier {
  static OverlayEntry? _entry;

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }

  static void show(
    BuildContext context, {
    required String message,
    AppNoticeType type = AppNoticeType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    dismiss();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        final isRtl = Directionality.of(ctx) == TextDirection.rtl;

        final Color bgColor;
        final Color accent;
        final IconData icon;
        switch (type) {
          case AppNoticeType.success:
            bgColor = const Color(0xFF1B5E20);
            accent = const Color(0xFF4CAF50);
            icon = Icons.check_circle_rounded;
            break;
          case AppNoticeType.warning:
            bgColor = const Color(0xFFE65100);
            accent = const Color(0xFFFF9800);
            icon = Icons.warning_rounded;
            break;
          case AppNoticeType.error:
            bgColor = const Color(0xFFB71C1C);
            accent = const Color(0xFFEF5350);
            icon = Icons.error_rounded;
            break;
          case AppNoticeType.info:
            bgColor = scheme.primaryContainer;
            accent = scheme.primary;
            icon = Icons.info_rounded;
            break;
        }

        final viewPadding = MediaQuery.viewPaddingOf(ctx);

        return Positioned(
          top: viewPadding.top + 16,
          right: isRtl ? null : 16,
          left: isRtl ? 16 : null,
          child: Material(
            color: Colors.transparent,
            child:
                Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                        minWidth: 280,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: accent, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.4),
                            blurRadius: 16,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(icon, color: accent, size: 24),
                            const SizedBox(width: 12),
                            Flexible(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 180,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _titleForType(type),
                                      style: TextStyle(
                                        color: accent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      message,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        height: 1.4,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: dismiss,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 180.ms)
                    .slideX(
                      begin: isRtl ? -0.15 : 0.15,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    ),
          ),
        );
      },
    );

    overlay.insert(_entry!);

    Future<void>.delayed(duration, () {
      if (_entry != null) dismiss();
    });
  }

  static String _titleForType(AppNoticeType type) {
    switch (type) {
      case AppNoticeType.success:
        return 'Success';
      case AppNoticeType.warning:
        return 'Warning';
      case AppNoticeType.error:
        return 'Error';
      case AppNoticeType.info:
        return 'Info';
    }
  }

  static void error(BuildContext context, String message) {
    show(context, message: message, type: AppNoticeType.error);
  }

  static void success(BuildContext context, String message) {
    show(context, message: message, type: AppNoticeType.success);
  }

  static void warning(BuildContext context, String message) {
    show(context, message: message, type: AppNoticeType.warning);
  }

  static void info(BuildContext context, String message) {
    show(context, message: message, type: AppNoticeType.info);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/extensions/context_extensions.dart';

/// FullScreenImageScreen
/// --------------------
///
/// Displays an image in full screen with a minimal back button.
///
/// This is primarily used by [AppImageViewer] when `enableFullScreen` is true.
///
/// Usage:
/// ```dart
/// Navigator.of(context).push(
///   MaterialPageRoute(
///     builder: (_) => FullScreenImageScreen.network(url),
///   ),
/// );
/// ```
enum FullScreenImageSourceType { network, asset }

/// Simple full screen preview for network/asset images.
class FullScreenImageScreen extends StatelessWidget {
  const FullScreenImageScreen._({
    super.key,
    required this.sources,
    required this.sourceType,
    required this.initialIndex,
    this.headers,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.high,
  });

  factory FullScreenImageScreen.gallery(
    List<String> sources, {
    Key? key,
    int initialIndex = 0,
    Map<String, String>? headers,
    Color? backgroundColor,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return FullScreenImageScreen._(
      key: key,
      sources: sources,
      sourceType: FullScreenImageSourceType.network,
      initialIndex: initialIndex,
      headers: headers,
      backgroundColor: backgroundColor,
      fit: fit,
      alignment: alignment,
      filterQuality: filterQuality,
    );
  }

  factory FullScreenImageScreen.network(
    String url, {
    Key? key,
    Map<String, String>? headers,
    Color? backgroundColor,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return FullScreenImageScreen._(
      key: key,
      sources: <String>[url],
      sourceType: FullScreenImageSourceType.network,
      initialIndex: 0,
      headers: headers,
      backgroundColor: backgroundColor,
      fit: fit,
      alignment: alignment,
      filterQuality: filterQuality,
    );
  }

  factory FullScreenImageScreen.asset(
    String assetPath, {
    Key? key,
    Color? backgroundColor,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return FullScreenImageScreen._(
      key: key,
      sources: <String>[assetPath],
      sourceType: FullScreenImageSourceType.asset,
      initialIndex: 0,
      backgroundColor: backgroundColor,
      fit: fit,
      alignment: alignment,
      filterQuality: filterQuality,
    );
  }

  final List<String> sources;
  final FullScreenImageSourceType sourceType;
  final int initialIndex;
  final Map<String, String>? headers;
  final Color? backgroundColor;

  final BoxFit fit;
  final Alignment alignment;
  final FilterQuality filterQuality;

  void _pop(BuildContext context) {
    // Use root navigator to ensure we pop the fullscreen route even if the
    // caller is inside nested navigators (e.g. shell routes, dialogs).
    try {
      Navigator.of(context, rootNavigator: true).maybePop();
    } catch (_) {}
  }

  Widget _buildError(BuildContext context) {
    final iconColor = Colors.white.withValues(alpha: 0.7);

    return Center(
      child: Icon(Icons.broken_image_outlined, size: 40.sp, color: iconColor),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildImage(BuildContext context, String source) {
    if (source.trim().isEmpty) return _buildError(context);

    try {
      return switch (sourceType) {
        FullScreenImageSourceType.network => Image.network(
          source,
          headers: headers,
          fit: fit,
          alignment: alignment,
          filterQuality: filterQuality,
          errorBuilder: (context, error, stackTrace) => _buildError(context),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _buildLoading(context);
          },
        ),
        FullScreenImageSourceType.asset => Image.asset(
          source,
          fit: fit,
          alignment: alignment,
          filterQuality: filterQuality,
          errorBuilder: (context, error, stackTrace) => _buildError(context),
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            if (frame == null) return _buildLoading(context);
            return child;
          },
        ),
      };
    } catch (_) {
      return _buildError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final bg = backgroundColor ?? Colors.black;
      final safeInitial = initialIndex.clamp(
        0,
        sources.isEmpty ? 0 : sources.length - 1,
      );
      final controller = PageController(initialPage: safeInitial);
      final indexNotifier = ValueNotifier<int>(safeInitial);

      return Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: controller,
                itemCount: sources.length,
                onPageChanged: (i) => indexNotifier.value = i,
                itemBuilder: (context, index) {
                  return Center(child: _buildImage(context, sources[index]));
                },
              ),
              PositionedDirectional(
                start: 12.w,
                top: 12.h,
                child: IconButton(
                  onPressed: () => _pop(context),
                  icon: Icon(context.startIcon, color: Colors.white, size: 40),
                ),
              ),
              if (sources.length > 1)
                Positioned(
                  left: context.isRtl ? null : 8.w,
                  right: context.isRtl ? 8.w : null,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: SizedBox(
                      width: 56.w,
                      height: 56.w,
                      child: ValueListenableBuilder<int>(
                        valueListenable: indexNotifier,
                        builder: (context, index, _) {
                          final canGoBack = index > 0;
                          return IconButton(
                            onPressed: canGoBack
                                ? () => controller.previousPage(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeOut,
                                  )
                                : null,
                            icon: Icon(
                              context.startIcon,
                              color: canGoBack ? Colors.white : Colors.white38,
                              size: 34.sp,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (sources.length > 1)
                Positioned(
                  right: context.isRtl ? null : 8.w,
                  left: context.isRtl ? 8.w : null,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: SizedBox(
                      width: 56.w,
                      height: 56.w,
                      child: ValueListenableBuilder<int>(
                        valueListenable: indexNotifier,
                        builder: (context, index, _) {
                          final canGoNext = index < sources.length - 1;
                          return IconButton(
                            onPressed: canGoNext
                                ? () => controller.nextPage(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeOut,
                                  )
                                : null,
                            icon: Icon(
                              context.endIcon,
                              color: canGoNext ? Colors.white : Colors.white38,
                              size: 34.sp,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}

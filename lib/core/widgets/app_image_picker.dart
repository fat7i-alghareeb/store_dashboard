import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../features/shared/widgets/full_screen_image_screen.dart';
import '../theme/app_text_styles.dart';

class AppImagePicker extends StatefulWidget {
  const AppImagePicker({
    super.key,
    required this.pickLabel,
    required this.emptyLabel,
    required this.onChanged,
    this.initialImageUrl,
    this.initialFile,
    this.height = 180,
    this.enabled = true,
    this.showClear = true,
    this.enableFullScreenPreview = true,
    this.clearLabel,
  });

  final String pickLabel;
  final String emptyLabel;
  final String? clearLabel;

  final String? initialImageUrl;
  final File? initialFile;

  final double height;
  final bool enabled;
  final bool showClear;
  final bool enableFullScreenPreview;

  final ValueChanged<File?> onChanged;

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _LocalFullScreenImage extends StatelessWidget {
  const _LocalFullScreenImage({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.9,
                maxScale: 5,
                child: Center(child: Image.file(file, fit: BoxFit.contain)),
              ),
            ),
            PositionedDirectional(
              start: 12,
              top: 12,
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).maybePop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppImagePickerState extends State<AppImagePicker> {
  File? _file;
  bool _picking = false;
  bool _hoverPick = false;
  bool _hoverClear = false;

  @override
  void initState() {
    super.initState();
    _file = widget.initialFile;
  }

  Future<void> _pick() async {
    setState(() => _picking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: false,
      );
      final path = result?.files.single.path;
      if (path == null || path.trim().isEmpty) return;

      final file = File(path);
      setState(() => _file = file);
      widget.onChanged(file);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _clear() {
    setState(() => _file = null);
    widget.onChanged(null);
  }

  void _openNetworkFullScreen(BuildContext context, String url) {
    try {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          builder: (_) => FullScreenImageScreen.network(url),
        ),
      );
    } catch (_) {}
  }

  void _openLocalFullScreen(BuildContext context, File file) {
    try {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          builder: (_) => _LocalFullScreenImage(file: file),
        ),
      );
    } catch (_) {}
  }

  Widget _wrapPreviewTap({
    required BuildContext context,
    required bool enabled,
    required Widget child,
    required VoidCallback onTap,
  }) {
    if (!enabled) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: child,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AppImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFile != widget.initialFile &&
        widget.initialFile != null) {
      _file = widget.initialFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canInteract = widget.enabled && !_picking;

    final hasLocal = _file != null;
    final hasUrl = (widget.initialImageUrl ?? '').trim().isNotEmpty;

    final canFullScreen = widget.enableFullScreenPreview;

    return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: MouseRegion(
                    cursor: canInteract
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.forbidden,
                    onEnter: (_) => setState(() => _hoverPick = true),
                    onExit: (_) => setState(() => _hoverPick = false),
                    child: AnimatedScale(
                      scale: _hoverPick && canInteract ? 1.01 : 1,
                      duration: 120.ms,
                      child: OutlinedButton(
                        onPressed: canInteract ? _pick : null,
                        child: Text(widget.pickLabel),
                      ),
                    ),
                  ),
                ),
                if (widget.showClear) const SizedBox(width: 10),
                if (widget.showClear)
                  MouseRegion(
                    cursor: (canInteract && (hasLocal || hasUrl))
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.forbidden,
                    onEnter: (_) => setState(() => _hoverClear = true),
                    onExit: (_) => setState(() => _hoverClear = false),
                    child: AnimatedScale(
                      scale: _hoverClear && canInteract && (hasLocal || hasUrl)
                          ? 1.01
                          : 1,
                      duration: 120.ms,
                      child: OutlinedButton(
                        onPressed: (canInteract && (hasLocal || hasUrl))
                            ? _clear
                            : null,
                        child: Text(widget.clearLabel ?? '×'),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (hasLocal)
              _wrapPreviewTap(
                context: context,
                enabled: canFullScreen,
                onTap: () => _openLocalFullScreen(context, _file!),
                child: _PreviewContainer(
                  height: widget.height,
                  child: Image.file(_file!, fit: BoxFit.cover),
                ),
              )
            else if (hasUrl)
              _wrapPreviewTap(
                context: context,
                enabled: canFullScreen,
                onTap: () =>
                    _openNetworkFullScreen(context, widget.initialImageUrl!),
                child: _PreviewContainer(
                  height: widget.height,
                  child: Image.network(
                    widget.initialImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Center(
                      child: Text(
                        widget.emptyLabel,
                        style: AppTextStyles.s12w500.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.emptyLabel,
                  style: AppTextStyles.s12w500.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        )
        .animate()
        .fadeIn(duration: 140.ms)
        .slideY(begin: 0.02, end: 0, duration: 220.ms, curve: Curves.easeOut);
  }
}

class _PreviewContainer extends StatelessWidget {
  const _PreviewContainer({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

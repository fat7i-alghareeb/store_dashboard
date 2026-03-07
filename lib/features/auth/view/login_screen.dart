import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'package:store_dashboard/features/auth/view/widgets/login_card.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body:
          Column(
                children: [
                  Container(
                    height: 44,
                    color: scheme.surface,
                    child: Row(
                      children: [
                        if (isRtl)
                          _WindowControls(
                            background: scheme.surface,
                            foreground: scheme.onSurface.withValues(
                              alpha: 0.85,
                            ),
                            hoverBackground: scheme.surfaceContainerHighest,
                            hoverForeground: scheme.onSurface,
                            closeHoverBackground: const Color(0xFFB3261E),
                            closeHoverForeground: Colors.white,
                          ),
                        Expanded(
                          child: DragToMoveArea(child: const SizedBox.expand()),
                        ),
                        if (!isRtl)
                          _WindowControls(
                            background: scheme.surface,
                            foreground: scheme.onSurface.withValues(
                              alpha: 0.85,
                            ),
                            hoverBackground: scheme.surfaceContainerHighest,
                            hoverForeground: scheme.onSurface,
                            closeHoverBackground: const Color(0xFFB3261E),
                            closeHoverForeground: Colors.white,
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            scheme.surface,
                            scheme.surfaceContainerHighest,
                          ],
                        ),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: LoginCard(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 180.ms)
              .scale(begin: const Offset(0.98, 0.98)),
    );
  }
}

class _WindowControls extends StatefulWidget {
  const _WindowControls({
    required this.background,
    required this.foreground,
    required this.hoverBackground,
    required this.hoverForeground,
    required this.closeHoverBackground,
    required this.closeHoverForeground,
  });

  final Color background;
  final Color foreground;
  final Color hoverBackground;
  final Color hoverForeground;
  final Color closeHoverBackground;
  final Color closeHoverForeground;

  @override
  State<_WindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<_WindowControls> {
  bool _maximized = false;

  @override
  void initState() {
    super.initState();
    _syncMaximized();
  }

  Future<void> _syncMaximized() async {
    try {
      final v = await windowManager.isMaximized();
      if (!mounted) return;
      setState(() => _maximized = v);
    } catch (_) {}
  }

  Future<void> _toggleMaximize() async {
    if (_maximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
    await _syncMaximized();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.background,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WindowButton(
            tooltip: AppStrings.close,
            icon: FontAwesomeIcons.xmark,
            fg: widget.foreground,
            hoverBg: widget.closeHoverBackground,
            hoverFg: widget.closeHoverForeground,
            onPressed: () => windowManager.close(),
          ),
          _WindowButton(
            tooltip: _maximized ? AppStrings.restore : AppStrings.maximize,
            icon: _maximized
                ? FontAwesomeIcons.windowRestore
                : FontAwesomeIcons.windowMaximize,
            fg: widget.foreground,
            hoverBg: widget.hoverBackground,
            hoverFg: widget.hoverForeground,
            onPressed: _toggleMaximize,
          ),
          _WindowButton(
            tooltip: AppStrings.minimize,
            icon: FontAwesomeIcons.windowMinimize,
            fg: widget.foreground,
            hoverBg: widget.hoverBackground,
            hoverFg: widget.hoverForeground,
            onPressed: () => windowManager.minimize(),
          ),
        ],
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  const _WindowButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    required this.fg,
    required this.hoverBg,
    required this.hoverFg,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final Color fg;
  final Color hoverBg;
  final Color hoverFg;

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = _hovered ? widget.hoverBg : Colors.transparent;
    final fg = _hovered ? widget.hoverFg : widget.fg;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: Material(
          color: bg,
          child: InkWell(
            onTap: widget.onPressed,
            child: SizedBox(
              width: 46,
              height: 44,
              child: Center(child: FaIcon(widget.icon, size: 12, color: fg)),
            ),
          ),
        ),
      ),
    );
  }
}

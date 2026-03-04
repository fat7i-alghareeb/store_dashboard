import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'package:store_dashboard/features/categories/view/categories_screen.dart';
import 'package:store_dashboard/features/products/view/products_screen.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> with WindowListener {
  int _selectedIndex = 0;

  void _mitigateStuckModifiers() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowBlur() {
    _mitigateStuckModifiers();
  }

  @override
  void onWindowFocus() {
    _mitigateStuckModifiers();
  }

  late final List<Widget Function()> _screenBuilders = [
    () => const ProductsScreen(),
    () => const CategoriesScreen(),
  ];

  late final List<Widget?> _screenCache = List<Widget?>.filled(
    _screenBuilders.length,
    null,
  );

  Widget _screenAt(int index) {
    final i = index.clamp(0, _screenBuilders.length - 1);
    return _screenCache[i] ??= _screenBuilders[i]();
  }

  List<_DashboardDestination> get _destinations => [
    _DashboardDestination(
      label: AppStrings.editProducts,
      icon: FontAwesomeIcons.penToSquare,
    ),
    _DashboardDestination(
      label: AppStrings.categories,
      icon: FontAwesomeIcons.layerGroup,
    ),
  ];

  void _setIndex(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index.clamp(0, _screenBuilders.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 44,
            color: scheme.surface,
            child: Row(
              children: [
                if (isRtl)
                  _WindowControls(
                    background: scheme.surface,
                    foreground: scheme.onSurface.withValues(alpha: 0.85),
                    hoverBackground: scheme.surfaceContainerHighest,
                    hoverForeground: scheme.onSurface,
                    closeHoverBackground: const Color(0xFFB3261E),
                    closeHoverForeground: Colors.white,
                  ),
                Expanded(
                  child: DragToMoveArea(
                    child: SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: isRtl
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: const SizedBox(height: 1, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isRtl)
                  _WindowControls(
                    background: scheme.surface,
                    foreground: scheme.onSurface.withValues(alpha: 0.85),
                    hoverBackground: scheme.surfaceContainerHighest,
                    hoverForeground: scheme.onSurface,
                    closeHoverBackground: const Color(0xFFB3261E),
                    closeHoverForeground: Colors.white,
                  ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _Sidebar(
                  selectedIndex: _selectedIndex,
                  destinations: _destinations,
                  onSelectIndex: _setIndex,
                ),
                Expanded(
                  child: Container(
                    color: theme.colorScheme.surface,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _AnimatedTabStack(
                              child: _screenAt(_selectedIndex),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedTabStack extends StatelessWidget {
  const _AnimatedTabStack({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(key: ValueKey(child.key ?? child.runtimeType))
        .fadeIn(duration: 220.ms, curve: Curves.easeOut)
        .slideY(begin: 0.02, end: 0, duration: 260.ms, curve: Curves.easeOut);
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.selectedIndex,
    required this.destinations,
    required this.onSelectIndex,
  });

  final int selectedIndex;
  final List<_DashboardDestination> destinations;
  final ValueChanged<int> onSelectIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const width = 260.0;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border(
          right: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.store,
                        color: scheme.primary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppStrings.dashboardAppName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ...List.generate(destinations.length, (i) {
                final d = destinations[i];
                final selected = i == selectedIndex;
                return _SidebarItem(
                  label: d.label,
                  icon: d.icon,
                  selected: selected,
                  onTap: () => onSelectIndex(i),
                );
              }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final bg = selected
        ? scheme.primary.withValues(alpha: 0.16)
        : Colors.transparent;
    final fg = selected
        ? scheme.primary
        : scheme.onSurface.withValues(alpha: 0.80);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                FaIcon(icon, size: 16, color: fg),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: fg,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideX(begin: -0.03, end: 0);
  }
}

class _DashboardDestination {
  const _DashboardDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
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
            tooltip: 'Close',
            icon: FontAwesomeIcons.xmark,
            fg: widget.foreground,
            hoverBg: widget.closeHoverBackground,
            hoverFg: widget.closeHoverForeground,
            onPressed: () => windowManager.close(),
          ),

          _WindowButton(
            tooltip: _maximized ? 'Restore' : 'Maximize',
            icon: _maximized
                ? FontAwesomeIcons.windowRestore
                : FontAwesomeIcons.windowMaximize,
            fg: widget.foreground,
            hoverBg: widget.hoverBackground,
            hoverFg: widget.hoverForeground,
            onPressed: _toggleMaximize,
          ),
          _WindowButton(
            tooltip: 'Minimize',
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

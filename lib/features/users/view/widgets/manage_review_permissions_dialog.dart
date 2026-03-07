import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';
import 'package:store_dashboard/features/users/viewmodel/users_cubit.dart';

Future<void> openManageReviewPermissionsDialog(
  BuildContext context, {
  required String userId,
  required String username,
  required UsersCubit cubit,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ManageReviewPermissionsDialog(
      userId: userId,
      username: username,
      cubit: cubit,
    ),
  );
}

class _ManageReviewPermissionsDialog extends StatefulWidget {
  const _ManageReviewPermissionsDialog({
    required this.userId,
    required this.username,
    required this.cubit,
  });

  final String userId;
  final String username;
  final UsersCubit cubit;

  @override
  State<_ManageReviewPermissionsDialog> createState() =>
      _ManageReviewPermissionsDialogState();
}

class _ManageReviewPermissionsDialogState
    extends State<_ManageReviewPermissionsDialog> {
  final _search = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String? _error;

  List<Map<String, dynamic>> _products = const <Map<String, dynamic>>[];
  Set<int> _allowed = <int>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await Future.wait([
        widget.cubit.fetchProductsForPermissions(),
        widget.cubit.fetchUserAllowedReviewProductIds(userId: widget.userId),
      ]);

      if (!mounted) return;
      setState(() {
        _products = List<Map<String, dynamic>>.from(result[0] as List);
        _allowed = result[1] as Set<int>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _products;

    return _products
        .where((e) => (e['title'] ?? '').toString().toLowerCase().contains(q))
        .toList(growable: false);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);

    await widget.cubit.replaceUserReviewPermissions(
      userId: widget.userId,
      allowedProductIds: _allowed,
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.username.trim().isEmpty
        ? AppStrings.reviewPermissions
        : '${AppStrings.reviewPermissions}: ${widget.username}';

    Widget content;
    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: Text(AppStrings.retry)),
          ],
        ),
      );
    } else {
      final items = _filtered;
      content = Column(
        children: [
          TextField(
            controller: _search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: AppStrings.selectProducts,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final row = items[index];
                final id = (row['id'] as num).toInt();
                final title = (row['title'] ?? '').toString();
                final selected = _allowed.contains(id);

                return InkWell(
                      onTap: () {
                        setState(() {
                          if (selected) {
                            _allowed.remove(id);
                          } else {
                            _allowed.add(id);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Checkbox(value: selected, onChanged: (_) {}),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 140.ms)
                    .slideY(begin: 0.03, end: 0);
              },
            ),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(title),
      content: SizedBox(width: 720, height: 560, child: content),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppStrings.save),
        ),
      ],
    ).animate().fadeIn(duration: 160.ms).slideY(begin: 0.03, end: 0);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/utils/gen/app_strings.dart';
import 'package:store_dashboard/features/products/viewmodel/products_cubit.dart';

Future<void> openManageProductReviewPermissionsDialog(
  BuildContext context, {
  required int productId,
  required String productTitle,
  required ProductsCubit cubit,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ManageProductReviewPermissionsDialog(
      productId: productId,
      productTitle: productTitle,
      cubit: cubit,
    ),
  );
}

class _ManageProductReviewPermissionsDialog extends StatefulWidget {
  const _ManageProductReviewPermissionsDialog({
    required this.productId,
    required this.productTitle,
    required this.cubit,
  });

  final int productId;
  final String productTitle;
  final ProductsCubit cubit;

  @override
  State<_ManageProductReviewPermissionsDialog> createState() =>
      _ManageProductReviewPermissionsDialogState();
}

class _ManageProductReviewPermissionsDialogState
    extends State<_ManageProductReviewPermissionsDialog> {
  final _search = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  String? _error;

  List<Map<String, dynamic>> _users = const <Map<String, dynamic>>[];
  Set<String> _allowed = <String>{};

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
        widget.cubit.fetchUsersForReviewPermissions(),
        widget.cubit.fetchProductAllowedReviewUserIds(
          productId: widget.productId,
        ),
      ]);

      if (!mounted) return;
      setState(() {
        _users = List<Map<String, dynamic>>.from(result[0] as List);
        _allowed = result[1] as Set<String>;
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
    if (q.isEmpty) return _users;

    return _users
        .where((row) {
          final email = (row['email'] ?? '').toString().toLowerCase();
          final username = (row['username'] ?? '').toString().toLowerCase();
          return email.contains(q) || username.contains(q);
        })
        .toList(growable: false);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      await widget.cubit.replaceProductReviewPermissions(
        productId: widget.productId,
        allowedUserIds: _allowed,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.productTitle.trim().isEmpty
        ? AppStrings.manageProductReviewPermissions
        : '${AppStrings.manageProductReviewPermissions}: ${widget.productTitle}';

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
              hintText: AppStrings.search,
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
                final userId = (row['id'] ?? '').toString();
                final email = (row['email'] ?? '').toString();
                final username = (row['username'] ?? '').toString();
                final role = (row['role'] ?? '').toString();

                final isAdmin = role == 'admin';
                final selected = _allowed.contains(userId);

                final displayName = username.trim().isEmpty ? email : username;
                final hasUsername = username.trim().isNotEmpty;

                return InkWell(
                      onTap: (isAdmin || _saving)
                          ? null
                          : () {
                              setState(() {
                                if (selected) {
                                  _allowed.remove(userId);
                                } else {
                                  _allowed.add(userId);
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (hasUsername)
                                    Text(
                                      displayName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  else
                                    SelectableText(
                                      email,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  const SizedBox(height: 2),
                                  SelectableText(email),
                                  if (isAdmin) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      AppStrings.admin,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Checkbox(
                              value: selected,
                              onChanged: (isAdmin || _saving)
                                  ? null
                                  : (_) {
                                      setState(() {
                                        if (selected) {
                                          _allowed.remove(userId);
                                        } else {
                                          _allowed.add(userId);
                                        }
                                      });
                                    },
                            ),
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
          onPressed: _saving || _loading ? null : _save,
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

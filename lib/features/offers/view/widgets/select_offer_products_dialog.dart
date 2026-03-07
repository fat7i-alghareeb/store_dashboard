import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:store_dashboard/features/offers/data/models/product_picker_item.dart';
import 'package:store_dashboard/features/offers/viewmodel/offers_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

Future<bool?> openSelectOfferProductsDialog(
  BuildContext context, {
  required int offerId,
  required String title,
  required OffersCubit cubit,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _SelectOfferProductsDialog(
      offerId: offerId,
      title: title,
      cubit: cubit,
    ),
  );
}

class _SelectOfferProductsDialog extends StatefulWidget {
  const _SelectOfferProductsDialog({
    required this.offerId,
    required this.title,
    required this.cubit,
  });

  final int offerId;
  final String title;
  final OffersCubit cubit;

  @override
  State<_SelectOfferProductsDialog> createState() =>
      _SelectOfferProductsDialogState();
}

class _SelectOfferProductsDialogState
    extends State<_SelectOfferProductsDialog> {
  final _search = TextEditingController();

  bool _loading = true;
  String? _error;

  List<ProductPickerItem> _items = const <ProductPickerItem>[];
  Set<int> _selected = <int>{};

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
        widget.cubit.fetchProductsForPicker(),
        widget.cubit.fetchOfferProductIds(offerId: widget.offerId),
      ]);

      if (!mounted) return;
      setState(() {
        _items = result[0] as List<ProductPickerItem>;
        _selected = result[1] as Set<int>;
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

  List<ProductPickerItem> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items
        .where((e) => e.title.toLowerCase().contains(q))
        .toList(growable: false);
  }

  Future<void> _save() async {
    await widget.cubit.replaceOfferProducts(
      offerId: widget.offerId,
      productIds: _selected,
    );

    if (!mounted) return;
    widget.cubit.state.actionStatus.maybeWhen(
      success: (_) => Navigator.of(context).pop(true),
      orElse: () {},
    );
  }

  void _selectAllFiltered() {
    final ids = _filtered.map((e) => e.id);
    setState(() => _selected.addAll(ids));
  }

  void _clearAllFiltered() {
    final ids = _filtered.map((e) => e.id).toSet();
    setState(() => _selected.removeWhere(ids.contains));
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title.trim().isEmpty
        ? AppStrings.assignProducts
        : '${AppStrings.assignProducts}: ${widget.title}';

    final saving = widget.cubit.state.actionStatus.isLoading;
    final busy = saving || _loading;

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
            FilledButton(onPressed: _load, child: Text(AppStrings.reset)),
          ],
        ),
      );
    } else if (_items.isEmpty) {
      content = Center(child: Text(AppStrings.noProductsFound));
    } else {
      final items = _filtered;
      content = Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: AppStrings.searchHint,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: busy ? null : _selectAllFiltered,
                child: Text(AppStrings.selectAll),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: busy ? null : _clearAllFiltered,
                child: Text(AppStrings.clearAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final p = items[index];
                final selected = _selected.contains(p.id);

                return InkWell(
                      onTap: () {
                        setState(() {
                          if (selected) {
                            _selected.remove(p.id);
                          } else {
                            _selected.add(p.id);
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: p.imageUrl.trim().isEmpty
                                  ? Container(
                                      width: 44,
                                      height: 44,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.image_outlined,
                                        size: 18,
                                      ),
                                    )
                                  : Image.network(
                                      p.imageUrl,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                p.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Checkbox(
                              value: selected,
                              onChanged: (_) {
                                setState(() {
                                  if (selected) {
                                    _selected.remove(p.id);
                                  } else {
                                    _selected.add(p.id);
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
          onPressed: busy ? null : () => Navigator.of(context).pop(false),
          child: Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: busy ? null : _save,
          child: Text(AppStrings.save),
        ),
      ],
    ).animate().fadeIn(duration: 160.ms).slideY(begin: 0.03, end: 0);
  }
}

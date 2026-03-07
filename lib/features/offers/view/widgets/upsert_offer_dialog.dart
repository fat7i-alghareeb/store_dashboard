import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/offers/data/models/offer_item.dart';
import 'package:store_dashboard/features/offers/viewmodel/offers_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class UpsertOfferDialog extends StatefulWidget {
  const UpsertOfferDialog({super.key, this.editing});

  final OfferItem? editing;

  @override
  State<UpsertOfferDialog> createState() => _UpsertOfferDialogState();
}

class _UpsertOfferDialogState extends State<UpsertOfferDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  late final TextEditingController _description;
  late final TextEditingController _validUntil;

  bool _active = true;

  DateTime? _validUntilDate;
  String _imageUrl = '';
  File? _pickedImage;
  bool _uploadingImage = false;

  bool get _isEdit => widget.editing != null;

  @override
  void initState() {
    super.initState();
    final o = widget.editing;
    _title = TextEditingController(text: o?.title ?? '');
    _subtitle = TextEditingController(text: o?.subtitle ?? '');
    _description = TextEditingController(text: o?.description ?? '');
    _imageUrl = o?.imageUrl ?? '';
    _validUntilDate = o?.validUntil;
    _validUntil = TextEditingController(text: _formatDate(_validUntilDate));
    _active = o?.isActive ?? true;
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _description.dispose();
    _validUntil.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: false,
    );
    if (!mounted) return;
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null || path.trim().isEmpty) return;

    setState(() {
      _pickedImage = File(path);
    });
  }

  Future<void> _pickValidUntilDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _validUntilDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );

    if (!mounted) return;
    if (picked == null) return;

    setState(() {
      _validUntilDate = picked;
      _validUntil.text = _formatDate(picked);
    });
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final title = _title.text.trim();
    final subtitle = _subtitle.text.trim();
    final description = _description.text.trim();
    final validUntil = _validUntilDate;

    final cubit = context.read<OffersCubit>();

    var imageUrl = _imageUrl.trim();
    final picked = _pickedImage;
    if (picked != null) {
      setState(() => _uploadingImage = true);
      try {
        imageUrl = await cubit.uploadOfferImage(picked);
        if (!mounted) return;
        setState(() {
          _imageUrl = imageUrl;
          _uploadingImage = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _uploadingImage = false);
        if (context.mounted) {
          AppNotifier.error(context, e.toString());
        }
        return;
      }
    }

    if (_isEdit) {
      await cubit.updateOffer(
        offerId: widget.editing!.id,
        title: title,
        subtitle: subtitle,
        description: description,
        imageUrl: imageUrl,
        validUntil: validUntil,
        isActive: _active,
      );
    } else {
      await cubit.createOffer(
        title: title,
        subtitle: subtitle,
        description: description,
        imageUrl: imageUrl,
        validUntil: validUntil,
        isActive: _active,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OffersCubit, OffersState>(
      listenWhen: (p, n) => p.actionStatus != n.actionStatus,
      listener: (context, state) {
        state.actionStatus.maybeWhen(
          success: (_) {
            context.read<OffersCubit>().clearActionStatus();
            if (context.mounted) {
              Navigator.of(context).pop();
              AppNotifier.success(
                context,
                _isEdit
                    ? AppStrings.offerUpdatedSuccessfully
                    : AppStrings.offerAddedSuccessfully,
              );
            }
          },
          failure: (message) => AppNotifier.error(context, message),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final saving = state.actionStatus.isLoading || _uploadingImage;

        return PopScope(
          canPop: !saving,
          child: AlertDialog(
            title: Text(_isEdit ? AppStrings.editOffer : AppStrings.addOffer),
            content: SizedBox(
              width: 560,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (saving)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: LinearProgressIndicator(minHeight: 2),
                        ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 56,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: 56,
                              height: 56,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _pickedImage != null
                                    ? Image.file(
                                        _pickedImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : (_imageUrl.trim().isNotEmpty
                                          ? Image.network(
                                              _imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainerHighest,
                                                    alignment: Alignment.center,
                                                    child: const Icon(
                                                      Icons
                                                          .broken_image_outlined,
                                                      size: 20,
                                                    ),
                                                  ),
                                            )
                                          : Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.image_outlined,
                                                size: 20,
                                              ),
                                            )),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: saving ? null : _pickImage,
                                icon: const Icon(Icons.upload_file_rounded),
                                label: Text(AppStrings.pickImage),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _title,
                        enabled: !saving,
                        decoration: InputDecoration(
                          labelText: AppStrings.offerTitle,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? AppStrings.pleaseEnterOfferTitle
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _subtitle,
                        enabled: !saving,
                        decoration: InputDecoration(
                          labelText: AppStrings.offerSubtitle,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _description,
                        enabled: !saving,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: AppStrings.offerDescription,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _validUntil,
                        enabled: !saving,
                        readOnly: true,
                        onTap: saving ? null : _pickValidUntilDate,
                        decoration: InputDecoration(
                          labelText: AppStrings.validUntilIso,
                          suffixIcon: const Icon(Icons.date_range_rounded),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile.adaptive(
                        value: _active,
                        onChanged: saving
                            ? null
                            : (v) => setState(() => _active = v),
                        title: Text(AppStrings.isActive),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.of(context).pop(),
                child: Text(AppStrings.cancel),
              ),
              FilledButton(
                onPressed: saving ? null : () => _submit(context),
                child: Text(_isEdit ? AppStrings.save : AppStrings.create),
              ),
            ],
          ).animate().fadeIn(duration: 160.ms).slideY(begin: 0.03, end: 0),
        );
      },
    );
  }
}

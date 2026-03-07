import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/offers/data/models/offer_item.dart';
import 'package:store_dashboard/features/offers/view/widgets/offer_card.dart';
import 'package:store_dashboard/features/offers/view/widgets/offers_body.dart';
import 'package:store_dashboard/features/offers/view/widgets/select_offer_products_dialog.dart';
import 'package:store_dashboard/features/offers/viewmodel/offers_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class OffersGrid extends StatelessWidget {
  const OffersGrid({
    super.key,
    required this.items,
    required this.actionStatus,
  });

  final List<OfferItem> items;
  final BlocStatus<void> actionStatus;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        mainAxisExtent: 260,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final o = items[index];
        return OfferCard(
              title: o.title,
              subtitle: o.subtitle,
              imageUrl: o.imageUrl,
              active: o.isActive,
              onEdit: actionStatus.isLoading
                  ? null
                  : () => OffersBody.openEditDialog(context, offer: o),
              onDelete: actionStatus.isLoading
                  ? null
                  : () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(AppStrings.confirmDelete),
                          content: Text(AppStrings.areYouSureDeleteOffer),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: Text(AppStrings.cancel),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: Text(AppStrings.delete),
                            ),
                          ],
                        ),
                      );
                      if (confirmed != true || !context.mounted) return;
                      await context.read<OffersCubit>().deleteOffer(offerId: o.id);
                      if (context.mounted) {
                        AppNotifier.success(
                          context,
                          AppStrings.offerDeletedSuccessfully,
                        );
                      }
                    },
              onAssignProducts: actionStatus.isLoading
                  ? null
                  : () async {
                      final cubit = context.read<OffersCubit>();
                      final saved = await openSelectOfferProductsDialog(
                        context,
                        offerId: o.id,
                        title: o.title,
                        cubit: cubit,
                      );
                      if (saved == true && context.mounted) {
                        AppNotifier.success(
                          context,
                          AppStrings.offerProductsUpdatedSuccessfully,
                        );
                      }
                    },
            )
            .animate()
            .fadeIn(duration: 180.ms, delay: (index * 20).ms)
            .slideY(begin: 0.06, end: 0);
      },
    );
  }
}

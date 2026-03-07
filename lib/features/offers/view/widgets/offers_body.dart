import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/core/widgets/app_notifier.dart';
import 'package:store_dashboard/features/offers/data/models/offer_item.dart';
import 'package:store_dashboard/features/offers/view/widgets/offers_error_state.dart';
import 'package:store_dashboard/features/offers/view/widgets/offers_grid.dart';
import 'package:store_dashboard/features/offers/view/widgets/upsert_offer_dialog.dart';
import 'package:store_dashboard/features/offers/viewmodel/offers_cubit.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';
import 'package:store_dashboard/utils/bloc_status/status_builder.dart';
import 'package:store_dashboard/utils/gen/app_strings.dart';

class OffersBody extends StatelessWidget {
  const OffersBody({super.key, required this.state});

  final OffersState state;

  static Future<void> openCreateDialog(BuildContext context) async {
    final cubit = context.read<OffersCubit>();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const UpsertOfferDialog()),
    );
  }

  static Future<void> openEditDialog(
    BuildContext context, {
    required OfferItem offer,
  }) async {
    final cubit = context.read<OffersCubit>();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: UpsertOfferDialog(editing: offer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OffersCubit, OffersState>(
      listenWhen: (p, n) => p.actionStatus != n.actionStatus,
      listener: (context, state) {
        state.actionStatus.maybeWhen(
          success: (_) => context.read<OffersCubit>().clearActionStatus(),
          failure: (message) => AppNotifier.error(context, message),
          orElse: () {},
        );
      },
      child: StatusBuilder(
        state: state.offersStatus,
        loading: () => const Center(child: CircularProgressIndicator()),
        failure: (message) => OffersErrorState(
          message: message,
          onRetry: () => context.read<OffersCubit>().load(),
        ),
        onError: () => context.read<OffersCubit>().load(),
        success: (items) {
          if (items.isEmpty) {
            return Center(child: Text(AppStrings.noOffersFound));
          }
          return OffersGrid(items: items, actionStatus: state.actionStatus);
        },
      ),
    );
  }
}

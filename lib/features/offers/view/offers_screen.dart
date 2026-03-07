import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:store_dashboard/features/offers/view/widgets/offers_body.dart';
import 'package:store_dashboard/features/offers/view/widgets/offers_header.dart';
import 'package:store_dashboard/features/offers/viewmodel/offers_cubit.dart';
import 'package:store_dashboard/utils/services/injection/injectable.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  late final OffersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OffersCubit>();
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<OffersCubit, OffersState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OffersHeader(onAdd: () => OffersBody.openCreateDialog(context)),
              Expanded(child: OffersBody(state: state)),
            ],
          ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.01, end: 0);
        },
      ),
    );
  }
}

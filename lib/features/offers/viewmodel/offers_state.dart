part of 'offers_cubit.dart';

@freezed
sealed class OffersState with _$OffersState {
  const OffersState._();

  const factory OffersState({
    required BlocStatus<List<OfferItem>> offersStatus,
    required BlocStatus<void> actionStatus,
  }) = _OffersState;

  factory OffersState.initial() => const OffersState(
    offersStatus: BlocStatus.initial(),
    actionStatus: BlocStatus.initial(),
  );
}

import 'package:bloc/bloc.dart';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:store_dashboard/features/offers/data/models/offer_item.dart';
import 'package:store_dashboard/features/offers/data/models/product_picker_item.dart';
import 'package:store_dashboard/features/offers/data/offers_supabase_data_source.dart';
import 'package:store_dashboard/utils/bloc_status/bloc_status.dart';

part 'offers_state.dart';
part 'offers_cubit.freezed.dart';

@injectable
class OffersCubit extends Cubit<OffersState> {
  OffersCubit(this._dataSource) : super(OffersState.initial());

  final OffersSupabaseDataSource _dataSource;

  void _safeEmit(OffersState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> load() async {
    _safeEmit(state.copyWith(offersStatus: const BlocStatus.loading()));
    try {
      final rows = await _dataSource.fetchOffers();
      final items = rows.map(OfferItem.fromJson).toList(growable: false);
      _safeEmit(state.copyWith(offersStatus: BlocStatus.success(items)));
    } catch (e) {
      _safeEmit(state.copyWith(offersStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> refresh() => load();

  Future<void> createOffer({
    required String title,
    required String subtitle,
    required String description,
    required String imageUrl,
    required DateTime? validUntil,
    required bool isActive,
  }) async {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.createOffer(
        title: title,
        subtitle: subtitle,
        description: description,
        imageUrl: imageUrl,
        validUntil: validUntil,
        isActive: isActive,
      );
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await load();
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> updateOffer({
    required int offerId,
    required String title,
    required String subtitle,
    required String description,
    required String imageUrl,
    required DateTime? validUntil,
    required bool isActive,
  }) async {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.updateOffer(
        offerId: offerId,
        title: title,
        subtitle: subtitle,
        description: description,
        imageUrl: imageUrl,
        validUntil: validUntil,
        isActive: isActive,
      );
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await load();
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> deleteOffer({required int offerId}) async {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.replaceOfferProducts(
        offerId: offerId,
        productIds: const <int>[],
      );
      await _dataSource.deleteOffer(offerId: offerId);
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await load();
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<List<ProductPickerItem>> fetchProductsForPicker() async {
    final rows = await _dataSource.fetchProductsForPicker();
    return rows.map(ProductPickerItem.fromJson).toList(growable: false);
  }

  Future<Set<int>> fetchOfferProductIds({required int offerId}) async {
    return _dataSource.fetchOfferProductIds(offerId: offerId);
  }

  Future<void> replaceOfferProducts({
    required int offerId,
    required Iterable<int> productIds,
  }) async {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.replaceOfferProducts(
        offerId: offerId,
        productIds: productIds,
      );
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  void clearActionStatus() {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.initial()));
  }

  Future<String> uploadOfferImage(File file) async {
    return _dataSource.uploadOfferImage(file);
  }
}

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../utils/bloc_status/bloc_status.dart';
import '../data/categories_supabase_data_source.dart';
import '../data/models/category_item.dart';

part 'categories_state.dart';
part 'categories_cubit.freezed.dart';

@lazySingleton
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._dataSource) : super(CategoriesState.initial());

  final CategoriesSupabaseDataSource _dataSource;

  Future<void> load() async {
    emit(state.copyWith(categoriesStatus: const BlocStatus.loading()));
    try {
      final items = await _dataSource.fetchCategories();
      emit(state.copyWith(categoriesStatus: BlocStatus.success(items)));
    } catch (e) {
      emit(state.copyWith(categoriesStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> refresh() => load();

  Future<void> create({required String title, required File image}) async {
    emit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.createCategory(title: title, imageFile: image);
      emit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await load();
    } catch (e) {
      emit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> update({
    required int id,
    required String title,
    File? image,
  }) async {
    emit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.updateCategory(id: id, title: title, imageFile: image);
      emit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await load();
    } catch (e) {
      emit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> delete({required int id}) async {
    emit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.deleteCategory(id: id);
      emit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await load();
    } catch (e) {
      emit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  void clearActionStatus() {
    emit(state.copyWith(actionStatus: const BlocStatus.initial()));
  }
}

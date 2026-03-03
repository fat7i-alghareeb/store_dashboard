part of 'categories_cubit.dart';

@freezed
sealed class CategoriesState with _$CategoriesState {
  const CategoriesState._();

  const factory CategoriesState({
    required BlocStatus<List<CategoryItem>> categoriesStatus,
    required BlocStatus<void> actionStatus,
  }) = _CategoriesState;

  factory CategoriesState.initial() => const CategoriesState(
    categoriesStatus: BlocStatus.initial(),
    actionStatus: BlocStatus.initial(),
  );
}

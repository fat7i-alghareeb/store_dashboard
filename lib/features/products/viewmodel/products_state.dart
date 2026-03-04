part of 'products_cubit.dart';

@freezed
sealed class ProductsState with _$ProductsState {
  const ProductsState._();

  const factory ProductsState({
    required BlocStatus<List<ProductSummaryItem>> productsStatus,
    required BlocStatus<List<ProductColor>> colorsStatus,
    required BlocStatus<List<CategoryItem>> categoriesStatus,
    required BlocStatus<void> actionStatus,
  }) = _ProductsState;

  factory ProductsState.initial() => const ProductsState(
    productsStatus: BlocStatus.initial(),
    colorsStatus: BlocStatus.initial(),
    categoriesStatus: BlocStatus.initial(),
    actionStatus: BlocStatus.initial(),
  );
}

part of 'admin_bloc.dart';

@immutable
sealed class AdminState {}

final class AdminInitial extends AdminState {}

class AddProductSucces extends AdminState {}

class AddProductError extends AdminState {}

class AddCategorySuccess extends AdminState {}

class AddCategoryError extends AdminState {}

/// ✅ حالات حذف المنتج
class DeleteProductLoading extends AdminState {}

class DeleteProductSuccess extends AdminState {}

class DeleteProductError extends AdminState {}

class DeleteCategorySuccess extends AdminState {}

class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}

class ToggleFavoriteSuccess extends AdminState {
  final int productId;
  final bool isFavorite;

  ToggleFavoriteSuccess({required this.productId, required this.isFavorite});
}

class ToggleFavoriteError extends AdminState {
  final String message;
  ToggleFavoriteError(this.message);
}

class ToggleFavoriteLoading extends AdminState {}

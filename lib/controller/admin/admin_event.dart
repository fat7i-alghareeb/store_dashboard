part of 'admin_bloc.dart';

@immutable
sealed class AdminEvent {}

class AddProductEvent extends AdminEvent {
  final String title;
  final String description;
  final int price;
  final String catigory;
  final bool isSpecial;
  final File image;
  AddProductEvent(
      {required this.title,
      required this.description,
      required this.price,
      required this.isSpecial,
      required this.image,
      required this.catigory});
}

class AddCategoryEvent extends AdminEvent {
  final String title;
  final File image;
  AddCategoryEvent({required this.title, required this.image});
}

class EditProductEvent extends AdminEvent {
  final int id;
  final String title;
  final String description;
  final int price;
  final String catigory;
  EditProductEvent(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.catigory});
}

class EditCategoryEvent extends AdminEvent {
  final String title;
  final File image;
  final int id;
  EditCategoryEvent(
      {required this.title, required this.image, required this.id});
}

class DeleteCategoryEvent extends AdminEvent {
  final int id;
  DeleteCategoryEvent({required this.id});
}

/// ✅ حدث حذف المنتج
class DeleteProductEvent extends AdminEvent {
  final int id;

  DeleteProductEvent({required this.id});
}

class ToggleFavoriteEvent extends AdminEvent {
  final int productId;
  final bool isFavorite; // true if adding to favorites, false if removing

  ToggleFavoriteEvent({required this.productId, required this.isFavorite});
}

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../utils/bloc_status/bloc_status.dart';
import '../data/models/product_color.dart';
import '../data/models/product_summary_item.dart';
import '../data/products_supabase_data_source.dart';
import '../../categories/data/models/category_item.dart';

part 'products_state.dart';
part 'products_cubit.freezed.dart';

@immutable
class CreateProductVariant {
  const CreateProductVariant({required this.colorId, required this.images});

  final int colorId;
  final List<File> images;
}

@injectable
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._dataSource) : super(ProductsState.initial());

  final ProductsSupabaseDataSource _dataSource;

  Future<void> load() async {
    await Future.wait([loadProducts(), loadColors(), loadCategories()]);
  }

  Future<void> loadProducts() async {
    emit(state.copyWith(productsStatus: const BlocStatus.loading()));
    try {
      final list = await _dataSource.fetchProducts();
      emit(state.copyWith(productsStatus: BlocStatus.success(list)));
    } catch (e) {
      emit(state.copyWith(productsStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> loadColors() async {
    emit(state.copyWith(colorsStatus: const BlocStatus.loading()));
    try {
      final list = await _dataSource.fetchColors();
      emit(state.copyWith(colorsStatus: BlocStatus.success(list)));
    } catch (e) {
      emit(state.copyWith(colorsStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> loadCategories() async {
    emit(state.copyWith(categoriesStatus: const BlocStatus.loading()));
    try {
      final list = await _dataSource.fetchCategories();
      emit(state.copyWith(categoriesStatus: BlocStatus.success(list)));
    } catch (e) {
      emit(state.copyWith(categoriesStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> createColor({
    required String title,
    required String hexCode,
  }) async {
    emit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.createColor(title: title, hexCode: hexCode);
      emit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await loadColors();
    } catch (e) {
      emit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> createProduct({
    required String title,
    required String description,
    required num price,
    required int categoryId,
    required bool isSpecial,
    required bool isTrending,
    required List<String> sizes,
    required List<CreateProductVariant> variants,
  }) async {
    emit(state.copyWith(actionStatus: const BlocStatus.loading()));
    int? createdProductId;
    try {
      if (variants.isEmpty) {
        throw Exception('No variants');
      }

      for (final v in variants) {
        if (v.images.isEmpty) {
          throw Exception('Variant has no images');
        }
      }

      final productId = await _dataSource.createProduct(
        title: title,
        description: description,
        price: price,
        categoryId: categoryId,
        isSpecial: isSpecial,
        isTrending: isTrending,
      );
      createdProductId = productId;

      if (sizes.isNotEmpty) {
        await _dataSource.addSizesToProduct(productId: productId, sizes: sizes);
      }

      for (final v in variants) {
        final productColorId = await _dataSource.createProductColor(
          productId: productId,
          colorId: v.colorId,
        );

        await _dataSource.addImagesToProductColor(
          productColorId: productColorId,
          images: v.images,
        );
      }

      emit(state.copyWith(actionStatus: const BlocStatus.success(null)));
    } catch (e) {
      final productId = createdProductId;
      if (productId != null) {
        try {
          await _dataSource.deleteProduct(productId: productId);
        } catch (_) {}
      }
      emit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> updateProduct({
    required int productId,
    required String title,
    required String description,
    required num price,
    required int categoryId,
    required bool isSpecial,
    required bool isTrending,
  }) async {
    emit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.updateProduct(
        productId: productId,
        title: title,
        description: description,
        price: price,
        categoryId: categoryId,
        isSpecial: isSpecial,
        isTrending: isTrending,
      );
      emit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await loadProducts();
    } catch (e) {
      emit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  void clearActionStatus() {
    emit(state.copyWith(actionStatus: const BlocStatus.initial()));
  }
}

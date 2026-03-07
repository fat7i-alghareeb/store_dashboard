import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../utils/bloc_status/bloc_status.dart';
import '../data/models/product_color.dart';
import '../data/models/product_summary_item.dart';
import '../data/models/update_product_variant.dart';
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

  void _safeEmit(ProductsState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> load() async {
    await Future.wait([loadProducts(), loadColors(), loadCategories()]);
  }

  Future<List<Map<String, dynamic>>> fetchUsersForReviewPermissions() {
    return _dataSource.fetchUsersForReviewPermissions();
  }

  Future<Set<String>> fetchProductAllowedReviewUserIds({
    required int productId,
  }) {
    return _dataSource.fetchProductAllowedReviewUserIds(productId: productId);
  }

  Future<void> replaceProductReviewPermissions({
    required int productId,
    required Set<String> allowedUserIds,
  }) {
    return _dataSource.replaceProductReviewPermissions(
      productId: productId,
      allowedUserIds: allowedUserIds,
    );
  }

  Future<void> updateProductFull({
    required int productId,
    required String title,
    required String description,
    required num price,
    required int categoryId,
    required bool isSpecial,
    required bool isTrending,
    required List<String> sizes,
    required List<UpdateProductVariant> variants,
  }) async {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      if (variants.isEmpty) {
        throw Exception('No variants');
      }

      for (final v in variants) {
        if (v.newImages.isEmpty && v.existingImageUrls.isEmpty) {
          throw Exception('Variant has no images');
        }
      }

      await _dataSource.updateProduct(
        productId: productId,
        title: title,
        description: description,
        price: price,
        categoryId: categoryId,
        isSpecial: isSpecial,
        isTrending: isTrending,
      );

      await _dataSource.replaceProductChildren(
        productId: productId,
        sizes: sizes,
        variants: variants,
      );

      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> deleteProductFull({required int productId}) async {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.deleteProductCascade(productId: productId);
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await loadProducts();
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> loadProducts() async {
    debugPrint('[ProductsCubit] loadProducts -> loading');
    _safeEmit(state.copyWith(productsStatus: const BlocStatus.loading()));
    try {
      final list = await _dataSource.fetchProducts();
      debugPrint(
        '[ProductsCubit] loadProducts -> success (count=${list.length})',
      );
      _safeEmit(state.copyWith(productsStatus: BlocStatus.success(list)));
    } catch (e) {
      debugPrint('[ProductsCubit] loadProducts -> failure ($e)');
      _safeEmit(
        state.copyWith(productsStatus: BlocStatus.failure(e.toString())),
      );
    }
  }

  Future<void> loadColors() async {
    _safeEmit(state.copyWith(colorsStatus: const BlocStatus.loading()));
    try {
      final list = await _dataSource.fetchColors();
      _safeEmit(state.copyWith(colorsStatus: BlocStatus.success(list)));
    } catch (e) {
      _safeEmit(state.copyWith(colorsStatus: BlocStatus.failure(e.toString())));
    }
  }

  Future<void> loadCategories() async {
    _safeEmit(state.copyWith(categoriesStatus: const BlocStatus.loading()));
    try {
      final list = await _dataSource.fetchCategories();
      _safeEmit(state.copyWith(categoriesStatus: BlocStatus.success(list)));
    } catch (e) {
      _safeEmit(
        state.copyWith(categoriesStatus: BlocStatus.failure(e.toString())),
      );
    }
  }

  Future<void> createColor({
    required String title,
    required String hexCode,
  }) async {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
    try {
      await _dataSource.createColor(title: title, hexCode: hexCode);
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await loadColors();
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
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
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
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

      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
    } catch (e) {
      final productId = createdProductId;
      if (productId != null) {
        try {
          await _dataSource.deleteProduct(productId: productId);
        } catch (_) {}
      }
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
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
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.loading()));
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
      _safeEmit(state.copyWith(actionStatus: const BlocStatus.success(null)));
      await loadProducts();
    } catch (e) {
      _safeEmit(state.copyWith(actionStatus: BlocStatus.failure(e.toString())));
    }
  }

  void clearActionStatus() {
    _safeEmit(state.copyWith(actionStatus: const BlocStatus.initial()));
  }
}

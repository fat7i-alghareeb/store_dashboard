import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/data/supabase/supabase_constants.dart';
import '../../categories/data/models/category_item.dart';
import 'models/product_color.dart';
import 'models/product_summary_item.dart';

@lazySingleton
class ProductsSupabaseDataSource {
  ProductsSupabaseDataSource(this._supabase);

  final SupabaseClient _supabase;

  Future<List<ProductSummaryItem>> fetchProducts() async {
    final response = await _supabase
        .from(SupabaseTables.products)
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.createdAt},'
          '${SupabaseColumns.title},'
          '${SupabaseColumns.description},'
          '${SupabaseColumns.price},'
          '${SupabaseColumns.categoryId},'
          '${SupabaseColumns.isSpecial},'
          '${SupabaseColumns.isDeal},'
          '${SupabaseColumns.dealPercent},'
          '${SupabaseColumns.isTrending},'
          '${SupabaseTables.productColors}('
          '${SupabaseColumns.id},'
          '${SupabaseColumns.colorId},'
          '${SupabaseTables.colors}(${SupabaseColumns.id},${SupabaseColumns.colorTitle},${SupabaseColumns.hexCode}),'
          '${SupabaseTables.productImages}(${SupabaseColumns.id},${SupabaseColumns.imageUrl},${SupabaseColumns.displayOrder})'
          ')',
        )
        .order(SupabaseColumns.createdAt, ascending: false);

    final list = List<Map<String, dynamic>>.from(response as List);
    return list.map(ProductSummaryItem.fromJson).toList(growable: false);
  }

  Future<List<ProductColor>> fetchColors() async {
    final response = await _supabase
        .from(SupabaseTables.colors)
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.colorTitle},'
          '${SupabaseColumns.hexCode}',
        )
        .order(SupabaseColumns.createdAt, ascending: false);

    final list = List<Map<String, dynamic>>.from(response as List);
    return list.map(ProductColor.fromJson).toList(growable: false);
  }

  Future<List<CategoryItem>> fetchCategories() async {
    final response = await _supabase
        .from(SupabaseTables.categories)
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.createdAt},'
          '${SupabaseColumns.categoryTitle},'
          '${SupabaseColumns.categoryImage}',
        )
        .order(SupabaseColumns.createdAt, ascending: false);

    final list = List<Map<String, dynamic>>.from(response as List);
    return list.map(CategoryItem.fromJson).toList(growable: false);
  }

  Future<ProductColor> createColor({
    required String title,
    required String hexCode,
  }) async {
    final response = await _supabase
        .from(SupabaseTables.colors)
        .insert({
          SupabaseColumns.colorTitle: title,
          SupabaseColumns.hexCode: hexCode,
        })
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.colorTitle},'
          '${SupabaseColumns.hexCode}',
        )
        .single();

    return ProductColor.fromJson(response);
  }

  Future<int> createProduct({
    required String title,
    required String description,
    required num price,
    required int categoryId,
    required bool isSpecial,
    required bool isTrending,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.products)
          .insert({
            SupabaseColumns.title: title,
            SupabaseColumns.description: description,
            SupabaseColumns.price: price,
            SupabaseColumns.categoryId: categoryId,
            SupabaseColumns.isSpecial: isSpecial,
            SupabaseColumns.isTrending: isTrending,
          })
          .select(SupabaseColumns.id)
          .single();

      return (response[SupabaseColumns.id] as num).toInt();
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        throw Exception(
          'Permission denied: Unable to create product. '
          'Please check your Supabase RLS policies or ensure you are logged in with appropriate permissions.',
        );
      }
      rethrow;
    }
  }

  Future<int> createProductColor({
    required int productId,
    required int colorId,
  }) async {
    final response = await _supabase
        .from(SupabaseTables.productColors)
        .insert({
          SupabaseColumns.productId: productId,
          SupabaseColumns.colorId: colorId,
        })
        .select(SupabaseColumns.id)
        .single();

    return (response[SupabaseColumns.id] as num).toInt();
  }

  Future<void> addImagesToProductColor({
    required int productColorId,
    required List<File> images,
  }) async {
    for (var i = 0; i < images.length; i++) {
      final file = images[i];
      final url = await _uploadProductImage(file);
      await _supabase.from(SupabaseTables.productImages).insert({
        SupabaseColumns.productColorId: productColorId,
        SupabaseColumns.imageUrl: url,
        SupabaseColumns.displayOrder: i,
      });
    }
  }

  Future<void> addSizesToProduct({
    required int productId,
    required List<String> sizes,
  }) async {
    final cleaned = sizes
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
    if (cleaned.isEmpty) return;

    try {
      await _supabase
          .from(SupabaseTables.productSizes)
          .insert(
            cleaned
                .map(
                  (s) => {
                    SupabaseColumns.productId: productId,
                    SupabaseColumns.sizeLabel: s,
                  },
                )
                .toList(growable: false),
          );
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        throw Exception(
          'Permission denied: Unable to add product sizes. '
          'Please check your Supabase RLS policies for the product_sizes table.',
        );
      }
      rethrow;
    }
  }

  Future<void> deleteProduct({required int productId}) async {
    await _supabase
        .from(SupabaseTables.products)
        .delete()
        .eq(SupabaseColumns.id, productId);
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
    await _supabase
        .from(SupabaseTables.products)
        .update({
          SupabaseColumns.title: title,
          SupabaseColumns.description: description,
          SupabaseColumns.price: price,
          SupabaseColumns.categoryId: categoryId,
          SupabaseColumns.isSpecial: isSpecial,
          SupabaseColumns.isTrending: isTrending,
        })
        .eq(SupabaseColumns.id, productId);
  }

  Future<String> _uploadProductImage(File file) async {
    final fileNameImage = p.basename(file.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_/$fileNameImage';
    final bytes = await file.readAsBytes();

    await _supabase.storage
        .from(SupabaseStorageBuckets.photo)
        .uploadBinary(fileName, bytes);

    return _supabase.storage
        .from(SupabaseStorageBuckets.photo)
        .getPublicUrl(fileName);
  }
}

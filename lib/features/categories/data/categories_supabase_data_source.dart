import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/data/supabase/supabase_constants.dart';
import 'models/category_item.dart';

@lazySingleton
class CategoriesSupabaseDataSource {
  CategoriesSupabaseDataSource(this._supabase);

  final SupabaseClient _supabase;

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

  Future<CategoryItem> createCategory({
    required String title,
    required File imageFile,
  }) async {
    final imageUrl = await _uploadCategoryImage(imageFile);

    final response = await _supabase
        .from(SupabaseTables.categories)
        .insert({
          SupabaseColumns.categoryTitle: title,
          SupabaseColumns.categoryImage: imageUrl,
        })
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.createdAt},'
          '${SupabaseColumns.categoryTitle},'
          '${SupabaseColumns.categoryImage}',
        )
        .single();

    return CategoryItem.fromJson(response);
  }

  Future<CategoryItem> updateCategory({
    required int id,
    required String title,
    File? imageFile,
  }) async {
    String? nextImageUrl;
    if (imageFile != null) {
      nextImageUrl = await _uploadCategoryImage(imageFile);
    }

    final update = <String, dynamic>{
      SupabaseColumns.categoryTitle: title,
      SupabaseColumns.categoryImage: ?nextImageUrl,
    };

    final response = await _supabase
        .from(SupabaseTables.categories)
        .update(update)
        .eq(SupabaseColumns.id, id)
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.createdAt},'
          '${SupabaseColumns.categoryTitle},'
          '${SupabaseColumns.categoryImage}',
        )
        .single();

    return CategoryItem.fromJson(response);
  }

  Future<void> deleteCategory({required int id}) async {
    await _supabase
        .from(SupabaseTables.categories)
        .delete()
        .eq(SupabaseColumns.id, id);
  }

  Future<String> _uploadCategoryImage(File file) async {
    final fileNameImage = p.basename(file.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_/$fileNameImage';
    final bytes = await file.readAsBytes();

    await _supabase.storage
        .from(SupabaseStorageBuckets.photoCategory)
        .uploadBinary(fileName, bytes);

    return _supabase.storage
        .from(SupabaseStorageBuckets.photoCategory)
        .getPublicUrl(fileName);
  }
}

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminInitial()) {
    on<ToggleFavoriteEvent>((event, emit) async {
      emit(ToggleFavoriteLoading());
      try {
        final supabase = Supabase.instance.client;

        // Update the product’s "is_favorite" field in Supabase
        final response = await supabase
            .from('products2')
            .update({'is_special': event.isFavorite})
            .eq('id', event.productId)
            .select();

        if (response.isEmpty) {
          emit(ToggleFavoriteError('Product not found'));
        } else {
          emit(
            ToggleFavoriteSuccess(
              productId: event.productId,
              isFavorite: event.isFavorite,
            ),
          );
        }
      } catch (e) {
        emit(ToggleFavoriteError('Failed to toggle favorite: $e'));
      }
    });

    on<AdminEvent>((event, emit) async {
      if (event is AddProductEvent) {
        emit(AdminInitial());
        final fileNameimage = p.basename(
          event.image.path,
        ); // ⬅️ This gives just the file name
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_/$fileNameimage';

        final fileBinary = await event.image.readAsBytes();
        try {
          final supabase = Supabase.instance.client;

          // Upload image to Supabase storage
          await supabase.storage
              .from('photo')
              .uploadBinary(fileName, fileBinary);

          final publicUrl = supabase.storage
              .from('photo')
              .getPublicUrl(fileName);

          await supabase
              .from('products2')
              .insert({
                'title': event.title,
                'description': event.description,
                'price': event.price,
                'category': event.catigory,
                'image_url': publicUrl,
                'is_special': event.isSpecial,
              })
              .then((value) {
                print('add product success');
                emit(AddProductSucces());
              });
        } catch (e) {
          emit(AddProductError());
          print('error add product$e');
        }
      } else if (event is DeleteCategoryEvent) {
        emit(AdminInitial());
        try {
          final supabase = Supabase.instance.client;

          // جلب اسم الفئة
          final category = await supabase
              .from('categories')
              .select('category_title')
              .eq('id', event.id)
              .single();

          final categoryTitle = category['category_title'];

          // حذف جميع المنتجات التي تنتمي لهذه الفئة
          await supabase
              .from('products2')
              .delete()
              .eq('category', categoryTitle);

          // حذف الفئة نفسها
          await supabase.from('categories').delete().eq('id', event.id);

          emit(DeleteCategorySuccess());
        } catch (e) {
          emit(AdminError("حدث خطأ: $e"));
        }
      } else if (event is AddCategoryEvent) {
        emit(AdminInitial());
        final fileNameimage = p.basename(
          event.image.path,
        ); // ⬅️ This gives just the file name
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_/$fileNameimage';

        final fileBinary = await event.image.readAsBytes();
        try {
          final supabase = Supabase.instance.client;

          // Upload image to Supabase storage
          await supabase.storage
              .from('photocategory')
              .uploadBinary(fileName, fileBinary);

          final publicUrl = supabase.storage
              .from('photocategory')
              .getPublicUrl(fileName);

          await supabase
              .from('categories')
              .insert({'category_title': event.title, 'image': publicUrl})
              .then((value) {
                print('add Category success');
                emit(AddCategorySuccess());
              });
        } catch (e) {
          emit(AddProductError());
          print('error add product$e');
        }
      } else if (event is EditProductEvent) {
        emit(AdminInitial());

        try {
          final supabase = Supabase.instance.client;
          await supabase
              .from('products2')
              .update({
                'title': event.title,
                'description': event.description,
                'price': event.price,
                'category': event.catigory,
              })
              .eq('id', event.id)
              .then((value) {
                print('edit product success');
                emit(AddProductSucces());
              });
        } catch (e) {
          emit(AddProductError());
          print('error add product$e');
        }
      } else if (event is EditCategoryEvent) {
        emit(AdminInitial());
        final fileNameimage = p.basename(
          event.image.path,
        ); // ⬅️ This gives just the file name
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_/$fileNameimage';

        final fileBinary = await event.image.readAsBytes();
        try {
          final supabase = Supabase.instance.client;

          // Upload image to Supabase storage
          await supabase.storage
              .from('photocategory')
              .uploadBinary(fileName, fileBinary);

          final publicUrl = supabase.storage
              .from('photocategory')
              .getPublicUrl(fileName);

          await supabase
              .from('categories')
              .update({'title': event.title, 'image': publicUrl})
              .eq('id', event.id)
              .then((value) {
                print('add Category success');
                emit(AddCategorySuccess());
              });
        } catch (e) {
          emit(AddProductError());
          print('error add product$e');
        }
      } else if (event is DeleteProductEvent) {
        emit(DeleteProductLoading());
        try {
          final supabase = Supabase.instance.client;

          // حذف المنتج من جدول products2 حسب id
          await supabase.from('products2').delete().eq('id', event.id);

          print('✅ Product deleted successfully');
          emit(DeleteProductSuccess());
        } catch (e) {
          print('❌ Error deleting product: $e');
          emit(DeleteProductError());
        }
      }
    });
  }

  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    final products = await Supabase.instance.client
        .from('products2')
        .select('')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(products);
  }

  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final categories = await Supabase.instance.client
        .from('categories')
        .select('')
        .order('created_at', ascending: false);
    print(categories);

    return List<Map<String, dynamic>>.from(categories);
  }

  static Future<List<Map<String, dynamic>>> fetchDeals() async {
    final deals = await Supabase.instance.client
        .from('products2')
        .select('')
        .filter('is_deal', 'eq', true)
        .order('created_at', ascending: false);
    print(deals);

    return List<Map<String, dynamic>>.from(deals);
  }

  static Future<List<Map<String, dynamic>>> fetchproduct(int id) async {
    final product = await Supabase.instance.client
        .from('products2')
        .select('')
        .eq('id', id)
        .order('created_at', ascending: false);
    print(product);
    return List<Map<String, dynamic>>.from(product);
  }

  static Future<List<Map<String, dynamic>>> searchProductsNotInDeals(
    String query,
  ) async {
    final response = await Supabase.instance.client
        .from('products2')
        .select()
        .ilike('title', '%$query%')
        .eq('is_deal', false);

    final data = response as List<dynamic>?;
    return data?.map((e) => e as Map<String, dynamic>).toList() ?? [];
  }

  static Future<bool> updateProductDeal(int productId, double percent) async {
    // In newer supabase_flutter versions, update() returns the data or null.
    // If it doesn't throw, it's generally successful.
    try {
      await Supabase.instance.client
          .from('products2')
          .update({'is_deal': true, 'deal_percent': percent})
          .eq('id', productId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

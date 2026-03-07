import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/data/supabase/supabase_constants.dart';
import '../../categories/data/models/category_item.dart';
import 'models/product_color.dart';
import 'models/product_summary_item.dart';
import 'models/update_product_variant.dart';

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
          '${SupabaseTables.productSizes}(${SupabaseColumns.sizeLabel}),'
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

  Future<List<Map<String, dynamic>>> fetchUsersForReviewPermissions() async {
    final response = await _supabase
        .from(SupabaseTables.users)
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.email},'
          '${SupabaseColumns.username},'
          'role,'
          'is_blocked',
        )
        .neq('role', 'admin')
        .eq('is_blocked', false)
        .order(SupabaseColumns.createdAt, ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<Set<String>> fetchProductAllowedReviewUserIds({
    required int productId,
  }) async {
    final response = await _supabase
        .from(SupabaseTables.productReviewPermissions)
        .select('${SupabaseColumns.userId},can_rate')
        .eq(SupabaseColumns.productId, productId)
        .eq('can_rate', true);

    final rows = List<Map<String, dynamic>>.from(response as List);
    return rows
        .map((e) => (e[SupabaseColumns.userId] ?? '').toString())
        .toSet();
  }

  Future<void> replaceProductReviewPermissions({
    required int productId,
    required Set<String> allowedUserIds,
  }) async {
    await _supabase
        .from(SupabaseTables.productReviewPermissions)
        .delete()
        .eq(SupabaseColumns.productId, productId);

    if (allowedUserIds.isEmpty) return;

    await _supabase
        .from(SupabaseTables.productReviewPermissions)
        .insert(
          allowedUserIds
              .map(
                (uid) => {
                  SupabaseColumns.userId: uid,
                  SupabaseColumns.productId: productId,
                  'can_rate': true,
                },
              )
              .toList(growable: false),
        );
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

  Future<void> replaceProductChildren({
    required int productId,
    required List<String> sizes,
    required List<UpdateProductVariant> variants,
  }) async {
    await _deleteProductChildren(productId: productId);

    await addSizesToProduct(productId: productId, sizes: sizes);

    for (final v in variants) {
      final productColorId = await createProductColor(
        productId: productId,
        colorId: v.colorId,
      );

      var displayOrder = 0;
      final existing = v.existingImageUrls
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
      if (existing.isNotEmpty) {
        await _supabase
            .from(SupabaseTables.productImages)
            .insert(
              List.generate(existing.length, (i) {
                return {
                  SupabaseColumns.productColorId: productColorId,
                  SupabaseColumns.imageUrl: existing[i],
                  SupabaseColumns.displayOrder: i,
                };
              }, growable: false),
            );
        displayOrder = existing.length;
      }

      if (v.newImages.isNotEmpty) {
        for (var i = 0; i < v.newImages.length; i++) {
          final file = v.newImages[i];
          final url = await _uploadProductImage(file);
          await _supabase.from(SupabaseTables.productImages).insert({
            SupabaseColumns.productColorId: productColorId,
            SupabaseColumns.imageUrl: url,
            SupabaseColumns.displayOrder: displayOrder + i,
          });
        }
      }
    }
  }

  Future<void> deleteProductCascade({required int productId}) async {
    await _deleteProductChildren(productId: productId);
    await deleteProduct(productId: productId);
  }

  Future<void> _deleteProductChildren({required int productId}) async {
    await _supabase
        .from(SupabaseTables.productSizes)
        .delete()
        .eq(SupabaseColumns.productId, productId);

    final colorRows = await _supabase
        .from(SupabaseTables.productColors)
        .select(SupabaseColumns.id)
        .eq(SupabaseColumns.productId, productId);
    final colorIds = (colorRows as List)
        .whereType<Map>()
        .map((e) => e[SupabaseColumns.id])
        .whereType<num>()
        .map((e) => e.toInt())
        .toList(growable: false);

    if (colorIds.isNotEmpty) {
      await _supabase
          .from(SupabaseTables.productImages)
          .delete()
          .inFilter(SupabaseColumns.productColorId, colorIds);
    }

    await _supabase
        .from(SupabaseTables.productColors)
        .delete()
        .eq(SupabaseColumns.productId, productId);
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
    final fileNameImage = p.basenameWithoutExtension(file.path);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_/$fileNameImage.jpg';
    final bytes = await _compressProductImage(file);

    await _supabase.storage
        .from(SupabaseStorageBuckets.photo)
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );

    return _supabase.storage
        .from(SupabaseStorageBuckets.photo)
        .getPublicUrl(fileName);
  }

  Future<Uint8List> _compressProductImage(
    File file, {
    int targetBytes = 1024 * 1024,
    int maxDimension = 1920,
  }) async {
    final originalBytes = await file.readAsBytes();
    if (originalBytes.lengthInBytes <= targetBytes) return originalBytes;

    final decoded = img.decodeImage(originalBytes);
    if (decoded == null) return originalBytes;

    var current = decoded;
    final w = current.width;
    final h = current.height;
    final largest = w > h ? w : h;
    if (largest > maxDimension) {
      final scale = maxDimension / largest;
      final newW = (w * scale).round();
      final newH = (h * scale).round();
      current = img.copyResize(
        current,
        width: newW,
        height: newH,
        interpolation: img.Interpolation.average,
      );
    }

    var quality = 92;
    var encoded = Uint8List.fromList(img.encodeJpg(current, quality: quality));
    while (encoded.lengthInBytes > targetBytes && quality > 45) {
      quality -= 7;
      encoded = Uint8List.fromList(img.encodeJpg(current, quality: quality));
    }

    return encoded;
  }
}

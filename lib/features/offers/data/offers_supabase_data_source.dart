import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import '../../shared/data/supabase/supabase_constants.dart';

@lazySingleton
class OffersSupabaseDataSource {
  OffersSupabaseDataSource(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Map<String, dynamic>>> fetchOffers() async {
    final response = await _supabase
        .from(SupabaseTables.offers)
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.createdAt},'
          '${SupabaseColumns.title},'
          '${SupabaseColumns.subtitle},'
          '${SupabaseColumns.description},'
          '${SupabaseColumns.imageUrl},'
          '${SupabaseColumns.validUntil},'
          '${SupabaseColumns.isActive}',
        )
        .order(SupabaseColumns.createdAt, ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<int> createOffer({
    required String title,
    required String subtitle,
    required String description,
    required String imageUrl,
    required DateTime? validUntil,
    required bool isActive,
  }) async {
    final response = await _supabase
        .from(SupabaseTables.offers)
        .insert({
          SupabaseColumns.title: title,
          SupabaseColumns.subtitle: subtitle,
          SupabaseColumns.description: description,
          SupabaseColumns.imageUrl: imageUrl,
          SupabaseColumns.validUntil: validUntil?.toIso8601String(),
          SupabaseColumns.isActive: isActive,
        })
        .select(SupabaseColumns.id)
        .single();

    return (response[SupabaseColumns.id] as num).toInt();
  }

  Future<void> updateOffer({
    required int offerId,
    required String title,
    required String subtitle,
    required String description,
    required String imageUrl,
    required DateTime? validUntil,
    required bool isActive,
  }) async {
    await _supabase
        .from(SupabaseTables.offers)
        .update({
          SupabaseColumns.title: title,
          SupabaseColumns.subtitle: subtitle,
          SupabaseColumns.description: description,
          SupabaseColumns.imageUrl: imageUrl,
          SupabaseColumns.validUntil: validUntil?.toIso8601String(),
          SupabaseColumns.isActive: isActive,
        })
        .eq(SupabaseColumns.id, offerId);
  }

  Future<String> uploadOfferImage(File file) async {
    final fileNameImage = p.basenameWithoutExtension(file.path);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_/$fileNameImage.jpg';
    final bytes = await _compressOfferImage(file);

    await _supabase.storage
        .from(SupabaseStorageBuckets.offers)
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );

    return _supabase.storage
        .from(SupabaseStorageBuckets.offers)
        .getPublicUrl(fileName);
  }

  Future<Uint8List> _compressOfferImage(
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

  Future<void> deleteOffer({required int offerId}) async {
    await _supabase
        .from(SupabaseTables.offers)
        .delete()
        .eq(SupabaseColumns.id, offerId);
  }

  Future<List<Map<String, dynamic>>> fetchProductsForPicker() async {
    final response = await _supabase
        .from(SupabaseTables.products)
        .select(
          '${SupabaseColumns.id},'
          '${SupabaseColumns.title},'
          '${SupabaseTables.productColors}('
          '${SupabaseColumns.id},'
          '${SupabaseColumns.colorId},'
          '${SupabaseTables.productImages}(${SupabaseColumns.id},${SupabaseColumns.imageUrl},${SupabaseColumns.displayOrder})'
          ')',
        )
        .order(SupabaseColumns.createdAt, ascending: false);

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<Set<int>> fetchOfferProductIds({required int offerId}) async {
    final response = await _supabase
        .from(SupabaseTables.productOffers)
        .select(SupabaseColumns.productId)
        .eq(SupabaseColumns.offerId, offerId);

    final rows = List<Map<String, dynamic>>.from(response as List);
    return rows
        .map((e) => (e[SupabaseColumns.productId] as num).toInt())
        .toSet();
  }

  Future<void> replaceOfferProducts({
    required int offerId,
    required Iterable<int> productIds,
  }) async {
    await _supabase
        .from(SupabaseTables.productOffers)
        .delete()
        .eq(SupabaseColumns.offerId, offerId);

    final list = productIds.toList(growable: false);
    if (list.isEmpty) return;

    await _supabase
        .from(SupabaseTables.productOffers)
        .insert(
          list
              .map(
                (productId) => {
                  SupabaseColumns.offerId: offerId,
                  SupabaseColumns.productId: productId,
                },
              )
              .toList(growable: false),
        );
  }
}

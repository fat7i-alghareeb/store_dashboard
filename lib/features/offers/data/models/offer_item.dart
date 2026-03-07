import 'package:store_dashboard/features/shared/data/supabase/supabase_constants.dart';

class OfferItem {
  const OfferItem({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.validUntil,
    required this.isActive,
  });

  final int id;
  final DateTime createdAt;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final DateTime? validUntil;
  final bool isActive;

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(
      (json[SupabaseColumns.createdAt] ?? '').toString(),
    );

    final rawValidUntil = json[SupabaseColumns.validUntil];
    DateTime? validUntil;
    if (rawValidUntil is String && rawValidUntil.trim().isNotEmpty) {
      validUntil = DateTime.tryParse(rawValidUntil);
    }

    return OfferItem(
      id: (json[SupabaseColumns.id] as num).toInt(),
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      title: (json[SupabaseColumns.title] ?? '').toString(),
      subtitle: (json[SupabaseColumns.subtitle] ?? '').toString(),
      description: (json[SupabaseColumns.description] ?? '').toString(),
      imageUrl: (json[SupabaseColumns.imageUrl] ?? '').toString(),
      validUntil: validUntil,
      isActive: (json[SupabaseColumns.isActive] ?? false) as bool,
    );
  }
}

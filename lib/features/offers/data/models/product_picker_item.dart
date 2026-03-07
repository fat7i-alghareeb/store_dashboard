import 'package:store_dashboard/features/products/data/models/product_color_variant_item.dart';

class ProductPickerItem {
  const ProductPickerItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  final int id;
  final String title;
  final String imageUrl;

  factory ProductPickerItem.fromJson(Map<String, dynamic> json) {
    final variantsJson =
        (json['product_colors'] as List?)
            ?.whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList(growable: false) ??
        const <Map<String, dynamic>>[];

    final variants = variantsJson
        .map(ProductColorVariantItem.fromJson)
        .toList(growable: false);

    String derivedMainImageUrl() {
      for (final v in variants) {
        final sorted = [...v.images]
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        for (final img in sorted) {
          if (img.imageUrl.trim().isNotEmpty) return img.imageUrl;
        }
      }
      return '';
    }

    return ProductPickerItem(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      imageUrl: derivedMainImageUrl(),
    );
  }
}

import 'product_color_variant_item.dart';

class ProductSummaryItem {
  final int id;
  final DateTime createdAt;
  final String title;
  final String description;
  final double price;
  final bool isSpecial;
  final bool isDeal;
  final double dealPercent;
  final int? categoryId;
  final bool isTrending;
  final List<ProductColorVariantItem> variants;

  const ProductSummaryItem({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.price,
    required this.isSpecial,
    required this.isDeal,
    required this.dealPercent,
    required this.categoryId,
    required this.isTrending,
    required this.variants,
  });

  String get derivedMainImageUrl {
    for (final v in variants) {
      final sorted = [...v.images]..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      for (final img in sorted) {
        if (img.imageUrl.trim().isNotEmpty) return img.imageUrl;
      }
    }
    return '';
  }

  factory ProductSummaryItem.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse((json['created_at'] ?? '') as String);

    final variantsJson = (json['product_colors'] as List?)
            ?.whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList(growable: false) ??
        const <Map<String, dynamic>>[];

    final variants = variantsJson
        .map(ProductColorVariantItem.fromJson)
        .toList(growable: false);

    final rawPrice = json['price'];
    final rawDealPercent = json['deal_percent'];

    return ProductSummaryItem(
      id: (json['id'] as num).toInt(),
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      price: rawPrice is int
          ? rawPrice.toDouble()
          : (rawPrice is double ? rawPrice : (rawPrice ?? 0.0) as num)
                .toDouble(),
      isSpecial: (json['is_special'] ?? false) as bool,
      isDeal: (json['is_deal'] ?? false) as bool,
      dealPercent: rawDealPercent is int
          ? rawDealPercent.toDouble()
          : (rawDealPercent is double
                    ? rawDealPercent
                    : (rawDealPercent ?? 0.0) as num)
                .toDouble(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      isTrending: (json['is_trending'] ?? false) as bool,
      variants: variants,
    );
  }
}

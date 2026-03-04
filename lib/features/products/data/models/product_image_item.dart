class ProductImageItem {
  final int id;
  final String imageUrl;
  final int displayOrder;

  const ProductImageItem({
    required this.id,
    required this.imageUrl,
    required this.displayOrder,
  });

  factory ProductImageItem.fromJson(Map<String, dynamic> json) {
    return ProductImageItem(
      id: (json['id'] as num).toInt(),
      imageUrl: (json['image_url'] ?? '') as String,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
    );
  }
}

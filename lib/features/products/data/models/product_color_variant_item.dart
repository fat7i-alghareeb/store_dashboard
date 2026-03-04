import 'product_color.dart';
import 'product_image_item.dart';

class ProductColorVariantItem {
  final int id;
  final int colorId;
  final ProductColor? color;
  final List<ProductImageItem> images;

  const ProductColorVariantItem({
    required this.id,
    required this.colorId,
    required this.color,
    required this.images,
  });

  factory ProductColorVariantItem.fromJson(Map<String, dynamic> json) {
    final colorJson = json['colors'];
    final imagesJson = (json['product_images'] as List?)
            ?.whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList(growable: false) ??
        const <Map<String, dynamic>>[];

    return ProductColorVariantItem(
      id: (json['id'] as num).toInt(),
      colorId: (json['color_id'] as num).toInt(),
      color: colorJson is Map<String, dynamic>
          ? ProductColor.fromJson(colorJson)
          : null,
      images: imagesJson.map(ProductImageItem.fromJson).toList(growable: false),
    );
  }
}

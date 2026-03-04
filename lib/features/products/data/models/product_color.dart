class ProductColor {
  final int id;
  final String title;
  final String hexCode;

  const ProductColor({
    required this.id,
    required this.title,
    required this.hexCode,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: (json['id'] as num).toInt(),
      title: (json['color_title'] ?? '') as String,
      hexCode: (json['hex_code'] ?? '') as String,
    );
  }
}

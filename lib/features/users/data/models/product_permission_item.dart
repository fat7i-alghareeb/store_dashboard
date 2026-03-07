class ProductPermissionItem {
  const ProductPermissionItem({
    required this.productId,
    required this.title,
    required this.canRate,
  });

  final int productId;
  final String title;
  final bool canRate;
}

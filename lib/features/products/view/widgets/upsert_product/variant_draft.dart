import 'dart:io';

import 'package:store_dashboard/features/products/data/models/product_color.dart';

class VariantDraft {
  const VariantDraft({required this.color, required this.images});

  final ProductColor color;
  final List<File> images;
}

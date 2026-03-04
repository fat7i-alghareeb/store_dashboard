import 'dart:io';

import 'package:store_dashboard/features/products/data/models/product_color.dart';

class VariantImageDraft {
  const VariantImageDraft._({this.file, this.url});

  final File? file;
  final String? url;

  factory VariantImageDraft.file(File file) => VariantImageDraft._(file: file);

  factory VariantImageDraft.url(String url) => VariantImageDraft._(url: url);
}

class VariantDraft {
  const VariantDraft({required this.color, required this.images});

  final ProductColor color;
  final List<VariantImageDraft> images;
}

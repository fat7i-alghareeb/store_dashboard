import 'dart:io';

class UpdateProductVariant {
  const UpdateProductVariant({
    required this.colorId,
    required this.newImages,
    required this.existingImageUrls,
  });

  final int colorId;
  final List<File> newImages;
  final List<String> existingImageUrls;
}

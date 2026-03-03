import 'package:flutter/foundation.dart';

@immutable
class CategoryItem {
  const CategoryItem({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.imageUrl,
  });

  final int id;
  final DateTime createdAt;
  final String title;
  final String imageUrl;

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt = json['created_at'];
    final createdAt = rawCreatedAt is String
        ? DateTime.tryParse(rawCreatedAt) ??
              DateTime.fromMillisecondsSinceEpoch(0)
        : (rawCreatedAt is DateTime
              ? rawCreatedAt
              : DateTime.fromMillisecondsSinceEpoch(0));

    final rawId = json['id'];
    final id = rawId is int ? rawId : (rawId as num).toInt();

    return CategoryItem(
      id: id,
      createdAt: createdAt,
      title: (json['category_title'] ?? '') as String,
      imageUrl: (json['image'] ?? '') as String,
    );
  }

  Map<String, dynamic> toUpdateJson({String? title, String? imageUrl}) {
    final map = <String, dynamic>{};
    if (title != null) map['category_title'] = title;
    if (imageUrl != null) map['image'] = imageUrl;
    return map;
  }
}

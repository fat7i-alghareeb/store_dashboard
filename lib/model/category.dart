class Category {
  final int id;
  final String title;
  final String imageUrl;

  Category({required this.imageUrl, required this.title, required this.id});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '') as String,
      imageUrl: (json['image_url'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'image_url': imageUrl};
  }
}

class Item { 
  final int id; 
  final String title; 
  final String imageUrl; 
  final double price; 
  final String description; 
  final String?catigory; 
  List?favoriteUsers; 
 
  Item({ 
    required this.id, 
    required this.title, 
    required this.imageUrl, 
    required this.price, 
    required this.description, 
    this.catigory, 
    this.favoriteUsers, 
  }); 
 
  factory Item.fromJson(Map<String, dynamic> json) { 
    return Item( 
      id:json['id'], 
      title: json['title'] ?? '', 
      imageUrl: json['image_url'] ?? '', 
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : (json['price'] ?? 0.0), 
      description: json['description'] ?? '', 
      catigory:json['category']??'', 
      favoriteUsers: json['users_favorite']??[], 
    ); 
  } 
 
  // Optionally, add toJson if needed later 
  Map<String, dynamic> toJson() { 
    return { 
      'title': title, 
      'image_url': imageUrl, 
      'price': price, 
      'description': description, 
      'category':catigory, 
      // 'favoriteUsers': favoriteUsers, 
 
    }; 
  } 
}
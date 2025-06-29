// File: models/food_item.dart
class FoodItem {
  final String image;
  final String title;
  final String price;
  final String store;

  FoodItem({
    required this.image,
    required this.title,
    required this.price,
    required this.store,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      image: json['image'],
      title: json['title'],
      price: json['price'],
      store: json['store'],
    );
  }

  Map<String, String> toMap() {
    return {
      'image': image,
      'title': title,
      'price': price,
      'store': store,
    };
  }
}

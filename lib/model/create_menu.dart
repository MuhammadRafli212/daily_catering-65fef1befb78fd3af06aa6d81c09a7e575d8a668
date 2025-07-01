// To parse this JSON data, do
//
//     final createmenu = createmenuFromJson(jsonString);

import 'dart:convert';

Createmenu createmenuFromJson(String str) =>
    Createmenu.fromJson(json.decode(str));

String createmenuToJson(Createmenu data) => json.encode(data.toJson());

class Createmenu {
  String message;
  Data data;

  Createmenu({required this.message, required this.data});

  factory Createmenu.fromJson(Map<String, dynamic> json) =>
      Createmenu(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int id;
  String title;
  String description;
  DateTime date;
  int price;
  String imageUrl;
  String imagePath;
  String category;
  String categoryId;

  Data({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.price,
    required this.imageUrl,
    required this.imagePath,
    required this.category,
    required this.categoryId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    date: DateTime.parse(json["date"]),
    price: json["price"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
    category: json["category"],
    categoryId: json["category_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "price": price,
    "image_url": imageUrl,
    "image_path": imagePath,
    "category": category,
    "category_id": categoryId,
  };
}

import 'dart:convert';

Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));
String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
  String message;
  List<DataMenu> data;

  Menu({required this.message, required this.data});

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    message: json["message"],
    data: List<DataMenu>.from(json["data"].map((x) => DataMenu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataMenu {
  int id;
  Title title;
  Description description;
  DateTime date;
  int price;
  String? imageUrl;
  String? imagePath;
  String? category;
  String? categoryId;

  DataMenu({
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

  factory DataMenu.fromJson(Map<String, dynamic> json) {
    // Fallback jika nilai tidak ditemukan dalam enum map
    final fallbackTitle = Title.MAKANAN_AMRIK;
    final fallbackDesc = Description.NASI_GORENG_TELUR_DAGING;

    return DataMenu(
      id: json["id"],
      title: titleValues.map[json["title"]] ?? fallbackTitle,
      description: descriptionValues.map[json["description"]] ?? fallbackDesc,
      date: DateTime.tryParse(json["date"] ?? '') ?? DateTime.now(),
      price: json["price"] ?? 0,
      imageUrl:
          json["image_url"] != null
              ? (json["image_url"] as String).replaceFirst(
                '/menus/',
                '/public/menus/',
              )
              : null,
      imagePath: json["image_path"],
      category: json["category"],
      categoryId: json["category_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": titleValues.reverse[title],
    "description": descriptionValues.reverse[description],
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "price": price,
    "image_url": imageUrl,
    "image_path": imagePath,
    "category": category,
    "category_id": categoryId,
  };
}

// ENUMS

enum Description { NASI_GORENG_TELUR_DAGING }

final descriptionValues = EnumValues({
  "Nasi goreng + telur + Daging": Description.NASI_GORENG_TELUR_DAGING,
});

enum Title {
  MAKANAN_AMRIK,
  NASI_GORENG_DAGING,
  NASI_GORENG_DAGING_ASDASDASDASDASDASD,
}

final titleValues = EnumValues({
  "Makanan amrik": Title.MAKANAN_AMRIK,
  "Nasi Goreng Daging": Title.NASI_GORENG_DAGING,
  "Nasi Goreng Daging asdasdasdasdasdasd":
      Title.NASI_GORENG_DAGING_ASDASDASDASDASDASD,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

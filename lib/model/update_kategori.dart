// To parse this JSON data, do
//
//     final update = updateFromJson(jsonString);

import 'dart:convert';

Update updateFromJson(String str) => Update.fromJson(json.decode(str));

String updateToJson(Update data) => json.encode(data.toJson());

class Update {
  String message;
  DataKategori data;

  Update({required this.message, required this.data});

  factory Update.fromJson(Map<String, dynamic> json) => Update(
    message: json["message"],
    data: DataKategori.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class DataKategori {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  DataKategori({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataKategori.fromJson(Map<String, dynamic> json) => DataKategori(
    id: json["id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

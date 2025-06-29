// To parse this JSON data, do
//
//     final tambahKategori = tambahKategoriFromJson(jsonString);

import 'dart:convert';

TambahKategori tambahKategoriFromJson(String str) => TambahKategori.fromJson(json.decode(str));

String tambahKategoriToJson(TambahKategori data) => json.encode(data.toJson());

class TambahKategori {
    String message;
    Data data;

    TambahKategori({
        required this.message,
        required this.data,
    });

    factory TambahKategori.fromJson(Map<String, dynamic> json) => TambahKategori(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String name;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Data({
        required this.name,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}

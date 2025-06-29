// To parse this JSON data, do
//
//     final getAll = getAllFromJson(jsonString);

import 'dart:convert';

GetAll getAllFromJson(String str) => GetAll.fromJson(json.decode(str));

String getAllToJson(GetAll data) => json.encode(data.toJson());

class GetAll {
    String message;
    List<All> data;

    GetAll({
        required this.message,
        required this.data,
    });

    factory GetAll.fromJson(Map<String, dynamic> json) => GetAll(
        message: json["message"],
        data: List<All>.from(json["data"].map((x) => All.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class All {
    int id;
    String name;
    DateTime createdAt;
    DateTime updatedAt;

    All({
        required this.id,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
    });

    factory All.fromJson(Map<String, dynamic> json) => All(
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

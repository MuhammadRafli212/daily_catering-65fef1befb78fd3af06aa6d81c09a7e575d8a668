// To parse this JSON data, do
//
//     final deliverystatus = deliverystatusFromJson(jsonString);

import 'dart:convert';

Deliverystatus deliverystatusFromJson(String str) =>
    Deliverystatus.fromJson(json.decode(str));

String deliverystatusToJson(Deliverystatus data) => json.encode(data.toJson());

class Deliverystatus {
  String message;
  Data data;

  Deliverystatus({required this.message, required this.data});

  factory Deliverystatus.fromJson(Map<String, dynamic> json) => Deliverystatus(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int id;
  String userId;
  String menuId;
  String deliveryAddress;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.userId,
    required this.menuId,
    required this.deliveryAddress,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    menuId: json["menu_id"],
    deliveryAddress: json["delivery_address"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "menu_id": menuId,
    "delivery_address": deliveryAddress,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

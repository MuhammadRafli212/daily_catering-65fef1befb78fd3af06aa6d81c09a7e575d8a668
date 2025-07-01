// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String message;
  DataOrder data;

  Order({required this.message, required this.data});

  factory Order.fromJson(Map<String, dynamic> json) =>
      Order(message: json["message"], data: DataOrder.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class DataOrder {
  int userId;
  int menuId;
  String deliveryAddress;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  DataOrder({
    required this.userId,
    required this.menuId,
    required this.deliveryAddress,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory DataOrder.fromJson(Map<String, dynamic> json) => DataOrder(
    userId: json["user_id"],
    menuId: json["menu_id"],
    deliveryAddress: json["delivery_address"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "menu_id": menuId,
    "delivery_address": deliveryAddress,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}

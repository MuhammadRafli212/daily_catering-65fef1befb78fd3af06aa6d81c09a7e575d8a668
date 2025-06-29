// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
    String message;
    Data data;

    Order({
        required this.message,
        required this.data,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int userId;
    int menuId;
    String deliveryAddress;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Data({
        required this.userId,
        required this.menuId,
        required this.deliveryAddress,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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

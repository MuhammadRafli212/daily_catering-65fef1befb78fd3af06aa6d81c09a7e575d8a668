// To parse this JSON data, do
//
//     final deleteMenu = deleteMenuFromJson(jsonString);

import 'dart:convert';

DeleteMenu deleteMenuFromJson(String str) => DeleteMenu.fromJson(json.decode(str));

String deleteMenuToJson(DeleteMenu data) => json.encode(data.toJson());

class DeleteMenu {
    String message;
    dynamic data;

    DeleteMenu({
        required this.message,
        required this.data,
    });

    factory DeleteMenu.fromJson(Map<String, dynamic> json) => DeleteMenu(
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
    };
}

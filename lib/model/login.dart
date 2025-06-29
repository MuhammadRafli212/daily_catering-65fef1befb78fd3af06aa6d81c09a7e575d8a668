// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);
//     final login = loginFromJson(jsonString);
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Empty emptyFromJson(String str) => Empty.fromJson(json.decode(str));

String emptyToJson(Empty data) => json.encode(data.toJson());

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Empty {
  Empty();

  factory Empty.fromJson(Map<String, dynamic> json) => Empty();

  Map<String, dynamic> toJson() => {};
}

class Login {
  String message;
  Data data;

  Login({required this.message, required this.data});

  factory Login.fromJson(Map<String, dynamic> json) =>
      Login(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  String token;
  User user;

  Data({required this.token, required this.user});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"], user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"token": token, "user": user.toJson()};
}

class User {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Register {
  String message;
  Data data;

  Register({required this.message, required this.data});

  factory Register.fromJson(Map<String, dynamic> json) =>
      Register(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

import 'dart:convert';

class ResponseModel<T> {
  String message;
  T? data;
  Errors? errors;

  ResponseModel({required this.message, this.data, this.errors});

  factory ResponseModel.fromRawJson({
    required String str,
    T Function(Map<String, dynamic>)? fromJsonT,
  }) => ResponseModel.fromJson(json: json.decode(str), fromJsonT: fromJsonT);

  String toRawJson() => json.encode(toJson());

  factory ResponseModel.fromJson({
    required Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  }) {
    return ResponseModel(
      message: json["message"],
      errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      data:
          json["data"] == null
              ? null
              : fromJsonT != null
              ? fromJsonT(json["data"])
              : null,
    );
  }

  static ResponseModel<List<T>> listFromJson<T>({
    required Map<String, dynamic> json,
    required T Function(Map<String, dynamic>) fromJsonT,
  }) {
    print(json["data"]);
    return ResponseModel<List<T>>(
      message: json['message'],
      data:
          json['data'] == null
              ? null
              : List<T>.from(json['data'].map((x) => fromJsonT(x))),
      errors: json['errors'] == null ? null : Errors.fromJson(json['errors']),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "errors": errors?.toJson(),
  };
}

class Errors {
  List<String>? name;
  List<String>? email;
  List<String>? password;
  List<String>? title;
  List<String>? date;
  List<String>? price;
  List<String>? categoryId;

  Errors({
    this.name,
    this.email,
    this.password,
    this.title,
    this.date,
    this.price,
    this.categoryId,
  });

  factory Errors.fromRawJson(String str) => Errors.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
    name:
        json["name"] == null
            ? []
            : List<String>.from(json["name"].map((x) => x)),
    email:
        json["email"] == null
            ? []
            : List<String>.from(json["email"].map((x) => x)),
    password:
        json["password"] == null
            ? []
            : List<String>.from(json["password"].map((x) => x)),
    title:
        json["title"] == null
            ? []
            : List<String>.from(json["title"].map((x) => x)),
    date:
        json["date"] == null
            ? []
            : List<String>.from(json["date"].map((x) => x)),
    price:
        json["price"] == null
            ? []
            : List<String>.from(json["price"].map((x) => x)),
    categoryId:
        json["category_id"] == null
            ? []
            : List<String>.from(json["category_id"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name ?? [],
    "email": email ?? [],
    "password": password ?? [],
    "title": title ?? [],
    "date": date ?? [],
    "price": price ?? [],
    "category_id": categoryId ?? [],
  };

  List<String> toList() {
    List<String> errorMessages = [];
    if (name?.isNotEmpty ?? false) errorMessages.add(name!.first);
    if (email?.isNotEmpty ?? false) errorMessages.add(email!.first);
    if (password?.isNotEmpty ?? false) errorMessages.add(password!.first);
    if (title?.isNotEmpty ?? false) errorMessages.add(title!.first);
    if (date?.isNotEmpty ?? false) errorMessages.add(date!.first);
    if (price?.isNotEmpty ?? false) errorMessages.add(price!.first);
    if (categoryId?.isNotEmpty ?? false) errorMessages.add(categoryId!.first);
    return errorMessages;
  }
}

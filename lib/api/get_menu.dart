import 'dart:convert';

import 'package:daily_catering/api/preferences.dart';
import 'package:daily_catering/endpoint/endpoint.dart';
import 'package:daily_catering/model/order.dart';
import 'package:daily_catering/model/response_model.dart';
import 'package:daily_catering/model/update_kategori.dart';
import 'package:http/http.dart' as http;

import '../model/menu_model.dart';

class GetMenu {
  /// Ambil semua data menu
  Future<List<DataMenu>> fetchMenuItems() async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.menus),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((item) => DataMenu.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data menu: ${response.statusCode}');
    }
  }

  /// Tambahkan menu baru
  Future<bool> createMenu({
    required String title,
    required String description,
    required DateTime date,
    required int price,
    required String imagePath,
    required String categoryId,
  }) async {
    final String? token = await PreferencesHelper.getToken();
    final request = http.MultipartRequest('POST', Uri.parse(Endpoint.menus));

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['date'] = date.toIso8601String();
    request.fields['price'] = price.toString();
    request.fields['category_id'] = categoryId;

    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Create menu failed: ${response.statusCode}");
      return false;
    }
  }

  /// Update menu
  Future<bool> updateMenu({
    required int id,
    required String title,
    required String description,
    required DateTime date,
    required int price,
    String? imagePath,
    required String categoryId,
  }) async {
    final String? token = await PreferencesHelper.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Endpoint.menus}/$id?_method=PUT'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['date'] = date.toIso8601String();
    request.fields['price'] = price.toString();
    request.fields['category_id'] = categoryId;

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Update menu failed: ${response.statusCode}");
      return false;
    }
  }

  /// Hapus menu
  Future<bool> deleteMenu(int id) async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.delete(
      Uri.parse('${Endpoint.menus}/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Delete menu failed: ${response.statusCode}");
      return false;
    }
  }

  static Future<ResponseModel<List<Order>>> getOrder() async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.get(
      Uri.parse("${Endpoint.orders}/history"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return ResponseModel.listFromJson<Order>(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Order.fromJson(x),
      );
    } else {
      throw Exception("Error Update Delivery");
    }
  }

  static Future<ResponseModel<Order>> postOrder({
    required int menuId,
    required String deliveryAddress,
  }) async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.post(
      Uri.parse(Endpoint.orders),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "menu_id": menuId,
        "delivery_address": deliveryAddress,
      }),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 422) {
      return ResponseModel<Order>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Order.fromJson(x),
      );
    } else {
      throw Exception("Error Order catering");
    }
  }

  static Future<ResponseModel<Order>> deleteOrder({
    required int orderId,
  }) async {
    final String? token = await PreferencesHelper.getToken();
    // TODO Problem
    final response = await http.delete(
      Uri.parse("${Endpoint.orders}/$orderId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<Order>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Order.fromJson(x),
      );
    } else {
      throw Exception("Error Delete Order");
    }
  }

  static Future<ResponseModel<List<Update>>> getCategory() async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.categories),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel.listFromJson<Update>(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Update.fromJson(x),
      );
    } else {
      throw Exception("Error Get Category");
    }
  }

  static Future<ResponseModel<Update>> postCategory({
    required String name,
  }) async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.post(
      Uri.parse(Endpoint.categories),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"name": name}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<Update>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Update.fromJson(x),
      );
    } else {
      throw Exception("Error Post Category");
    }
  }

  static Future<ResponseModel<Update>> updateCategory({
    required String name,
    required int categoryId,
  }) async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.put(
      Uri.parse("${Endpoint.categories}/$categoryId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: {"name": name},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<Update>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Update.fromJson(x),
      );
    } else {
      throw Exception("Error Update Category");
    }
  }

  static Future<ResponseModel<Update>> deleteCategory({
    required int categoryId,
  }) async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.delete(
      Uri.parse("${Endpoint.categories}/$categoryId"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<Update>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Update.fromJson(x),
      );
    } else {
      throw Exception("Error Delete Category");
    }
  }

  static Future<ResponseModel<Order>> updateDeliveryStatus({
    required String status,
    required int orderId,
  }) async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.put(
      Uri.parse("${Endpoint.orders}/$orderId/status"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"status": status},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<Order>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Order.fromJson(x),
      );
    } else {
      throw Exception("Error Update Delivery Status");
    }
  }

  static Future<ResponseModel<Order>> updateDeliveryAddress({
    required String deliveryAddress,
    required int orderId,
  }) async {
    final String? token = await PreferencesHelper.getToken();

    //TODO Problem
    final response = await http.put(
      Uri.parse("${Endpoint.orders}/$orderId/address"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {"delivery_address": deliveryAddress},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return ResponseModel<Order>.fromJson(
        json: jsonDecode(response.body),
        fromJsonT: (x) => Order.fromJson(x),
      );
    } else {
      throw Exception("Error Update Delivery Address");
    }
  }
}

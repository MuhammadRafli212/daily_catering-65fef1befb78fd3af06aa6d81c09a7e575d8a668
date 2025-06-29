import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:daily_catering/api/preferences.dart';
import 'package:daily_catering/endpoint/endpoint.dart';
import '../model/menu_model.dart';

class GetMenu {
  /// Ambil semua data menu
  Future<List<DataMenu>> fetchMenuItems() async {
    final String? token = await PreferencesHelper.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.menus),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(Endpoint.menus),
    );

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
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Delete menu failed: ${response.statusCode}");
      return false;
    }
  }
}

 
  
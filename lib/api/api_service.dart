// File: services/api_service.dart
import 'dart:convert';
import 'package:daily_catering/model/test_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  static const String baseUrl = 'http://appkaterings.mobileprojp.com/api/orders'; 

  static Future<List<FoodItem>> fetchCategoryItems(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/menu/$category'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => FoodItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load $category');
    }
  }
  
}
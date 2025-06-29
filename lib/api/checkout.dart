import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutService {
  static const String _checkoutUrl = 'http://appkaterings.mobileprojp.com';

  static Future<bool> checkout(List<Map<String, String>> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.post(
        Uri.parse(_checkoutUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'items': items,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Checkout error: $e");
      return false;
    }
  }
}

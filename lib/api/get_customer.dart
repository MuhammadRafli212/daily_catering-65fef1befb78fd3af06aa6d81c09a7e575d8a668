import 'dart:convert';

import 'package:daily_catering/endpoint/endpoint.dart';
import 'package:daily_catering/model/register.dart';
import 'package:daily_catering/model/register_error.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(registerFromJson(response.body).toJson());
      return registerFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json", 
      },
      body: jsonEncode({
       
        "email": email,
        "password": password,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return registerFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      throw Exception("Failed to login user: ${response.statusCode}");
    }
  }
}

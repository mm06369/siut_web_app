import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://muhammadmurtaza5253.pythonanywhere.com';

  ApiService();

  Future<Map<String, dynamic>> get(String text) async {
    final response = await http.get(Uri.parse('$baseUrl/get_query?plain_text=$text',),
    headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });
    debugPrint("Reponse in get function: $response");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {

      throw Exception('Failed to load data');
    }
  }

  // You can add more methods for different HTTP request types (POST, PUT, DELETE, etc.)
}

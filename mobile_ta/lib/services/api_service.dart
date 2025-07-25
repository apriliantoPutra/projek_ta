import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_ta/models/api_key_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final String baseUrl = dotenv.env['URL'] ?? '';

  static Future<ApiKeyResponse> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null)
      return ApiKeyResponse(success: false, message: 'Token not found');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api-key'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return ApiKeyResponse.fromJson(jsonData);
      } else {
        return ApiKeyResponse(
          success: false,
          message: 'Failed to load API key. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Debugging: Print error
      print('Error fetching API key: $e');
      return ApiKeyResponse(success: false, message: 'Connection error: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_ta/models/api_key_model.dart';

class ApiService {
  static final String baseUrl = dotenv.env['URL'] ?? '';

  static Future<ApiKeyResponse> getApiKey() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api-key'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ApiKeyResponse.fromJson(json.decode(response.body));
      } else {
        return ApiKeyResponse(
          success: false,
          message: 'Failed to load API key: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiKeyResponse(
        success: false,
        message: 'Error fetching API key: $e',
      );
    }
  }
}

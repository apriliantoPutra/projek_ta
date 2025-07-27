import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_ta/models/api_key_model.dart';
import 'package:mobile_ta/services/auth_service.dart';

class ApiService {
  static final String baseUrl = dotenv.env['URL'] ?? '';

  static Future<ApiKeyResponse> getApiKey() async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      return ApiKeyResponse(success: false, message: 'Token not found');
    }

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
      } else if (response.statusCode == 401) {
        // Handle token expiration
        final refreshed = await authService.refreshToken();
        if (refreshed) {
          return await getApiKey(); // Retry after refresh
        }
        return ApiKeyResponse(
          success: false,
          message: 'Session expired. Please login again',
        );
      } else {
        return ApiKeyResponse(
          success: false,
          message: 'Failed to load API key. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching API key: $e');
      return ApiKeyResponse(success: false, message: 'Connection error: $e');
    }
  }
}

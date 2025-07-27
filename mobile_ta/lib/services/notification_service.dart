import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ta/models/notification_model.dart';
import 'package:mobile_ta/services/auth_service.dart';

class NotificationService {
  final AuthService _authService = AuthService();

  Future<List<NotificationModel>> fetchNotifications() async {
    final token = await _authService.getToken();

    if (token == null) {
      debugPrint('Token not found');
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL']}/notifikasi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List data = jsonBody['data'];
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        // Handle token expiration
        final refreshed = await _authService.refreshToken();
        if (refreshed) {
          return await fetchNotifications(); // Retry after refresh
        }
        return [];
      } else {
        throw Exception('Gagal memuat notifikasi. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      throw Exception('Gagal memuat notifikasi: $e');
    }
  }
}

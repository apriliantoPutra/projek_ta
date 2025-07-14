import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_ta/constants/constants.dart';
import 'package:mobile_ta/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  Future<List<NotificationModel>> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return [];

    final response = await http.get(
      Uri.parse('$baseUrl/notifikasi'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List data = jsonBody['data'];
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat notifikasi');
    }
  }
}

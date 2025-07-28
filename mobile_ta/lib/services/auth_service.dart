import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final _baseUrl = dotenv.env['URL'] ?? '';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Timer? _tokenRefreshTimer;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/authenticate'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuthData(data);
        _startTokenRefreshTimer();
        return {'success': true, 'data': data['data']};
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return {'success': false, 'message': 'Connection error'};
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    await _storage.write(key: 'access_token', value: data['access_token']);
    await _storage.write(key: 'refresh_token', value: data['refresh_token']);
    await _storage.write(key: 'user_data', value: jsonEncode(data['data']));
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) return false;

    // Cek expired token
    final response = await http.get(
      Uri.parse('$_baseUrl/akun'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      return await refreshToken();
    }
    return false;
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: {'Authorization': 'Bearer $refreshToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'access_token', value: data['access_token']);
        return true;
      }
    } catch (e) {
      debugPrint('Refresh token error: $e');
    }

    await logout();
    return false;
  }

  void _startTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer.periodic(const Duration(minutes: 15), (
      timer,
    ) async {
      await refreshToken();
    });
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _storage.read(key: 'user_data');
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> logout() async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
    }
    await _storage.deleteAll();
    _tokenRefreshTimer?.cancel();
  }
}

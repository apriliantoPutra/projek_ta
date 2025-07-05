import 'package:flutter/services.dart';

class ApiKeyLoader {
  static const MethodChannel _channel = MethodChannel(
    'com.example.app/api_key',
  );

  static Future<String?> getApiKey() async {
    try {
      final String? apiKey = await _channel.invokeMethod('getGoogleApiKey');
      return apiKey;
    } catch (e) {
      return null;
    }
  }
}

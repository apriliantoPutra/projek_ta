// api_key_model.dart
class ApiKeyResponse {
  final bool success;
  final String? data;
  final String? message;

  ApiKeyResponse({required this.success, this.data, this.message});

  factory ApiKeyResponse.fromJson(Map<String, dynamic> json) {
    return ApiKeyResponse(
      success: json['success'],
      data: json['data'],
      message: json['message'],
    );
  }
}

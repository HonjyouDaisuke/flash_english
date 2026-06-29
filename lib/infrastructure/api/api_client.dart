import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class ApiClient {
  final TokenStorage _storage;
  final String baseUrl;

  static const _timeout = Duration(seconds: 30);

  ApiClient(
    this._storage,
    this.baseUrl,
  );

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _storage.getAccessToken();
    final response = await http
        .post(
          Uri.parse(_buildUrl(path)),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    if (response.statusCode == 401) {
      final body = jsonDecode(response.body);

      if (body["error"] == "TOKEN_EXPIRED") {
        await _storage.clear(); // or logout処理
      }

      throw Exception("Unauthorized");
    }

    return response;
  }

  Future<http.Response> get(String path) async {
    final token = await _storage.getAccessToken();

    return http.get(
      Uri.parse(_buildUrl(path)),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ).timeout(_timeout);
  }

  String _buildUrl(String path) {
    if (path.startsWith('http')) {
      return path;
    }

    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final cleanPath = path.startsWith('/') ? path : '/$path';

    return '$cleanBase$cleanPath';
  }
}

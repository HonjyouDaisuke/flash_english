import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class ApiClient {
  final TokenStorage _storage;
  static const _timeout = Duration(seconds: 30);
  ApiClient(this._storage);

  Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _storage.getAccessToken();

    return http
        .post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        )
        .timeout(_timeout);
  }

  Future<http.Response> get(String url) async {
    final token = await _storage.getAccessToken();

    return http.get(
      Uri.parse(url),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ).timeout(_timeout);
  }
}

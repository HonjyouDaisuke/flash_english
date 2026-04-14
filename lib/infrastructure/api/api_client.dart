import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class ApiClient {
  final TokenStorage _storage;

  ApiClient(this._storage);

  Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _storage.getAccessToken();
    debugPrint("API TOKEN: $token");

    return http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(String url) async {
    final token = await _storage.getAccessToken();

    return http.get(
      Uri.parse(url),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}

import 'dart:convert';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flutter/material.dart';

class AuthBackend {
  final ApiClient _apiClient;

  AuthBackend(this._apiClient);
  Future<Map<String, dynamic>?> callBackend(String idToken) async {
    final response = await _apiClient.post(
        'http://10.0.2.2:8888/flash_english_backend/api/auth/google',
        body: {
          'id_token': idToken,
        });

    debugPrint("status: ${response.statusCode}");
    debugPrint("body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    debugPrint("バックエンドエラー: ${response.statusCode}");
    return null;
  }
}

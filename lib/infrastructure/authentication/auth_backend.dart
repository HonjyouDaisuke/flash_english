import 'dart:convert';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flutter/material.dart';

class AuthBackend {
  final ApiClient _apiClient;
  final String _baseUrl;

  AuthBackend(this._apiClient, this._baseUrl);
  Future<Map<String, dynamic>?> callBackend(String idToken) async {
    final response = await _apiClient
        .post('$_baseUrl/flash_english_backend/api/auth/google', body: {
      'id_token': idToken,
    });
    debugPrint("statusCode = ${response.statusCode}");
    assert(() {
      // ローカルデバッグ時のみ本文を出力（リリースには含めない）
      debugPrint("body = ${response.body}");
      return true;
    }());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    debugPrint("バックエンドエラー: ${response.statusCode}");
    return null;
  }
}

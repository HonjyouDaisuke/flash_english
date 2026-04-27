import 'dart:convert';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flutter/material.dart';

class AuthBackend {
  final ApiClient _apiClient;

  AuthBackend(this._apiClient);

  Future<Map<String, dynamic>?> callBackend(
    String idToken,
  ) async {
    final response = await _apiClient.post(
      '/flash_english_backend/api/auth/google',
      body: {
        'id_token': idToken,
      },
    );

    debugPrint(
      'statusCode = ${response.statusCode}',
    );

    assert(() {
      debugPrint(
        'body = ${response.body}',
      );
      return true;
    }());

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    debugPrint(
      'バックエンドエラー: ${response.statusCode}',
    );

    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  Future<void> saveTokens(
      {required String accessToken, String? refreshToken}) async {
    debugPrint("token saves...");

    await _storage.write(key: _accessKey, value: accessToken);

    if (refreshToken != null) {
      await _storage.write(key: _refreshKey, value: refreshToken);
    } else {
      await _storage.delete(key: _refreshKey);
    }
    debugPrint("token saves...OK");
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}

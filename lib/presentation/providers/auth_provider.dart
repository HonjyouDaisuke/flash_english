import 'package:flash_english/infrastructure/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage());

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier(
    ref.read(tokenStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<String?> {
  final TokenStorage storage;

  AuthNotifier(this.storage) : super(null);

  Future<void> loadToken() async {
    state = await storage.getAccessToken();
  }

  Future<void> setTokens(String accessToken, String? refreshToken) async {
    await storage.saveTokens(
        accessToken: accessToken, refreshToken: refreshToken);
    state = accessToken;
  }

  Future<void> logout() async {
    await storage.clear();
    state = null;
  }
}

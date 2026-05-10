import 'package:flash_english/domain/entities/auth_status.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';
import 'package:flash_english/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(tokenStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final TokenStorage storage;

  AuthNotifier(this.storage) : super(const AuthState());
  Future<void> loadToken() async {
    final token = await storage.getAccessToken();

    if (token == null) {
      state = state.copyWith(
        token: null,
        userId: null,
      );
      return;
    }

    final userId = JwtDecoder.decode(token)['sub'];

    state = state.copyWith(
      token: token,
      userId: userId,
    );
  }

  Future<void> setTokens(
    String accessToken,
    String? refreshToken,
  ) async {
    await storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    final userId = JwtDecoder.decode(accessToken)['sub'];

    state = state.copyWith(
      token: accessToken,
      userId: userId,
      status: AuthStatus.onlineAuthenticated,
    );
  }

  Future<void> setIsExpired(bool isExpired) async {
    state = state.copyWith(
      isExpired: isExpired,
    );
  }

  Future<void> setIsOffline(bool isOffline) async {
    state = state.copyWith(
      isOffline: isOffline,
    );
  }

  Future<void> logout() async {
    await storage.clear();

    state = state.copyWith(
      token: null,
      userId: null,
      status: AuthStatus.onlineAuthExpired,
    );
  }

  void updateStatus(AuthStatus status) {
    state = state.copyWith(
      status: status,
    );
  }
}

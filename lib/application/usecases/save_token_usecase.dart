import 'package:flash_english/infrastructure/storage/token_storage.dart';

class SaveTokenUseCase {
  final TokenStorage storage;

  SaveTokenUseCase(this.storage);

  Future<void> execute(String accessToken, String? refreshToken) {
    return storage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

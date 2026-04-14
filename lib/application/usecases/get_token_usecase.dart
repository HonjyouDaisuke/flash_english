import 'package:flash_english/infrastructure/storage/token_storage.dart';

class GetTokenUseCase {
  final TokenStorage storage;

  GetTokenUseCase(this.storage);

  Future<String?> execute() {
    return storage.getAccessToken();
  }
}

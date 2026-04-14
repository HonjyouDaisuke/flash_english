import 'package:flash_english/infrastructure/storage/token_storage.dart';

class LogoutUseCase {
  final TokenStorage storage;

  LogoutUseCase(this.storage);

  Future<void> execute() {
    return storage.clear();
  }
}

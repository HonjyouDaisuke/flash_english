import 'package:flash_english/domain/repositories/ping_repository.dart';

class PingUseCase {
  final PingRepository repository;

  PingUseCase(this.repository);

  Future<bool> ping() async {
    return await repository.ping();
  }
}

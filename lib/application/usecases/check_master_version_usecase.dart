import 'package:flash_english/domain/repositories/master_version_repository.dart';

class CheckMasterVersionUseCase {
  CheckMasterVersionUseCase(this.repository);

  final MasterVersionRepository repository;

  Future<bool> execute(
    String versionName,
  ) {
    return repository.isNeedUpdate(versionName);
  }
}
